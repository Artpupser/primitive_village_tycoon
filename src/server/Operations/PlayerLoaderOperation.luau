local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local DataService = require(ServerStorage.Host.Services.DataService)
local Enumerate = require(ReplicatedStorage.Shared.Utils.Enumerate)
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)


local PlayerLoaderOperation = {}
PlayerLoaderOperation.__className = "PlayerLoaderOperation"
PlayerLoaderOperation.__index = PlayerLoaderOperation
PlayerLoaderOperation.characterFolder = nil

--- LOCAL CONSTS ---

local CHARACTER_FOLDER_NAME = "Players"
 
local CHARACTER_PROPERTIES = {
    ["CollisionGroup"] = "Player",
    ["Material"] = Enum.Material.SmoothPlastic
}

local HUMANOID_PROPERTIES = {
    ["DisplayName"] = "",
    ["WalkSpeed"] = 16,
    ["NameDisplayDistance"] = 0,
    ["HealthDisplayDistance"] = 0,
    ["DisplayDistanceType"] = Enum.HumanoidDisplayDistanceType.None,
    ["MaxHealth"] = 100,
    ["AutomaticScalingEnabled"] = false
}

--- ------------ ---

local function CharacterMaterialChange(humanoid: Humanoid)
    Enumerate.characterParts(humanoid, function(part)
        part.Material = CHARACTER_PROPERTIES.Material
    end)
end

local function CharcaterPutToFolder(humanoid: Humanoid)
    humanoid.Parent.Parent = PlayerLoaderOperation.characterFolder
end

local function CharacterSetCollisionGroup(humanoid: Humanoid)
    Enumerate.characterParts(humanoid, function(part)
        part.CollisionGroup = CHARACTER_PROPERTIES.CollisionGroup
    end)
end

local function BasicHumanoidConfiguration(humanoid: Humanoid)
    for i, value in pairs(HUMANOID_PROPERTIES) do
        humanoid[i] = value
    end
end


function PlayerLoaderOperation.start()
    PlayerLoaderOperation.characterFolder = SimpleInstance.new("Folder"):rename(CHARACTER_FOLDER_NAME):parent(workspace):build()
    TriggerManager.createPrivateEvent("player_added")
    TriggerManager.createPrivateEvent("player_removed")
    TriggerManager.createRemoteEvent("player_complete_loading").OnServerEvent:Connect(function(player:Player)
        TriggerManager.fireRemoteEvent("notification", player, "Player: "..tostring(player.UserId).." loaded!")
    end)

    DataService.init()
    

    Players.PlayerAdded:Connect(function(player:Player)
        TriggerManager.firePrivateEvent("player_added", player)
        player.CharacterAdded:Connect(function(character: Model)
            local humanoid = character:WaitForChild("Humanoid")
            CharacterMaterialChange(humanoid)
            CharacterSetCollisionGroup(humanoid)
            BasicHumanoidConfiguration(humanoid)
            CharcaterPutToFolder(humanoid)
        end)
    end)

    Players.PlayerRemoving:Connect(function(player:Player)
        TriggerManager.firePrivateEvent("player_removed", player)
    end)
end

return PlayerLoaderOperation