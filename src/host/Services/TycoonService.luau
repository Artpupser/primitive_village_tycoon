local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)

local TycoonService = {}
TycoonService.__index = TycoonService
TycoonService.__className = "TycoonService"

local DEFAULT = {
    ["Dcorations"] = {
        ["Platform"] = true
    },
    ["Triggers"] = {

    },
    ["NPC"] = {

    }
}

local TYCOON_TEMPLATE = ServerStorage.Prefabs
local AMOUNT = 4
local Tycoons = {}

function TycoonService.init()
    for i = AMOUNT, 1, -1 do
        print(i)
    end

    TriggerManager.getPrivateEvent("player_data_success_loaded").Event:Connect(function(player: Player, data: PlayerData)
        TriggerManager.fireRemoteEvent("notification", player, "Data with actual version '"..data.Version.."' successfuly loaded!")
    end)
end

return TycoonService