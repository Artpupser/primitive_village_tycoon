local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local ServerStorage = game:GetService("ServerStorage")
local GameplayLoaderOperation = {}
GameplayLoaderOperation.__index = GameplayLoaderOperation
GameplayLoaderOperation.__className = "TycoonLoaderOperation"

local TycoonService = require(ServerStorage.Host.Services.TycoonService)

function GameplayLoaderOperation.start()
    TycoonService.init()

    TriggerManager.getPrivateEvent("player_data_success_loaded").Event:Connect(function(player: Player, data: PlayerData)
        print(data)
    end)
end

return GameplayLoaderOperation;