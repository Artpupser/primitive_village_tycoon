local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local Pessimistic = require(ReplicatedStorage.Shared.Utils.Pessimistic)
local Logical = require(ReplicatedStorage.Shared.Utils.Logical)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local DATABASE_MODE = RunService:IsStudio() and "testing" or "production"

local Database : DataStore = Pessimistic.pcallAttempts(5, function()
    return DataStoreService:GetDataStore(DATABASE_MODE)
end, function()
    error("Database ["..DATABASE_MODE.."] bad loaded, server shutdown")
    Pessimistic.kickAllPlayers()
end)
print("Database ["..DATABASE_MODE.."] successfuly loaded!")

local ServerTypes = require(ServerStorage.Host.ServerTypes) 

local DataService = {}

local CURRENT_DATA_SCHEME = {
    ["Scores"] = {
        ["Gold"] = 0,
    },
    ["Version"] = 0,
}

DataService.Sessions = {}

local function session(player:Player, value:any?)
    if value ~= nil then
        DataService.Sessions[player.UserId] = value
    end
    return DataService.Sessions[player.UserId]
end

local function createEmptySession(player: Player)
    DataService.Sessions[player.UserId] = {}
end

local function removeSession(player: Player)
    DataService.Sessions[player.UserId] = nil
end

local function saveData(player: Player) : boolean
    local playerData = DataService.Sessions[player.UserId]
    if playerData == nil or playerData == false or type(playerData) ~= "table" then
        warn("Player ["..player.UserId.."] with bad temp data, skip saving")
        return true
    end

    local success, _ = pcall(function()
        return Database:SetAsync(player.UserId, playerData)
    end)

    if success then
        TriggerManager.fireRemoteEvent("notification", player, "Your data successfuly saved!")
        print("PlayerData ["..player.UserId.."] successfuly saved!")
        return true
    end
    TriggerManager.fireRemoteEvent("notification", player, "Failed while saving your data! Please try save game manually")
    error("Bad operation!, PlayerData ["..player.UserId.."] not saved")
    return false
end

local function initData(player: Player) : boolean
    TriggerManager.fireRemoteEvent("notification", player, "Welcome! new player "..player.DisplayName)
    print("PlayerData ["..player.UserId.."] is nil! initializing new data, version: "..CURRENT_DATA_SCHEME.Version)
    local new = table.clone(CURRENT_DATA_SCHEME)
    session(player, new)
    return saveData(player)
end

local function loadData(player: Player) : boolean
    local success, value = pcall(function()
        return Database:GetAsync(player.UserId)
    end)

    if success then
        if value ~= nil then
            if value.Version < CURRENT_DATA_SCHEME.Version then
                warn("PlayerData ["..player.UserId.."] is old version: "..value.Version..". Merging to actual version: "..CURRENT_DATA_SCHEME.Version)
                Logical.mergeRecursion(value, CURRENT_DATA_SCHEME)
                value.Version = CURRENT_DATA_SCHEME.Version
            end
            TriggerManager.fireRemoteEvent("notification", player, "Data with actual version '"..value.Version.."' successfuly loaded!")
            print("PlayerData ["..player.UserId.."] successfuly loaded! version "..value.Version.." is actual")
            session(player, value)
            return true
        end
        return initData(player)
    end
    TriggerManager.fireRemoteEvent("notification", player, "Your data not loaded! Please try re-enter the game")
    error("PlayerData ["..player.UserId.."] bad loaded...")
    session(player, false)
    return false
end

-- local function clearData(player:Player) : boolean
--     local success, _ = pcall(function()
--         return Database:RemoveAsync(player.UserId)
--     end)
--     if success then
--         TriggerManager.fireRemoteEvent("notification", player, "Your data successfuly cleared!")
--         print("PlayerData ["..player.UserId.."] clear")
--         return true
--     end
--     warn("PlayerData ["..player.UserId.."] bad clear")
--     TriggerManager.fireRemoteEvent("notification", player, "Your data bad clear, retry")
--     return false
-- end

local function clearAllData() : boolean
    warn("Removing all data!!!")
    
    local success, _ = pcall(function()
        for _, key in ipairs(Database:ListKeysAsync():GetCurrentPage()) do
            Database:RemoveAsync(key.KeyName)
            warn("Data number ["..key.KeyName.."] removed")
        end
    end)
    if success then
        print("All data successfuly removed.")
        return true        
    end
    warn("All data bad removed")     
    return false   
end


function DataService.set(player:Player, new: ServerTypes.PlayerData)
    if session(player) ~= nil then
        DataService.Sessions[player.UserId] = new
    end
end

function DataService.get(player:Player) : ServerTypes.PlayerData
    local playerSession = session(player);
    if playerSession ~= nil then
        return playerSession
    end
end

function DataService.init()
    TriggerManager.createPrivateFunction("player_data_get").OnInvoke = DataService.get
    TriggerManager.createPrivateFunction("player_data_set").OnInvoke = DataService.set

    TriggerManager.createPrivateEvent("player_data_success_loaded")
    TriggerManager.getPrivateEvent("player_added").Event:Connect(function(player:Player)
        createEmptySession(player)
        if loadData(player) == false then
            player:Kick("Data bad loaded, try another enter to server")
            return
        end
        TriggerManager.firePrivateEvent("player_data_success_loaded", player, DataService.get(player))
    end)
    
    TriggerManager.getPrivateEvent("player_removed").Event:Connect(function(player:Player)
        if saveData(player) == false then
            return
        end
        removeSession(player)
    end)
end

function DataService.print()
    for id, value in pairs(DataService.Sessions) do
        print("SESSION: ["..id.."] ", value)
    end
end

return DataService