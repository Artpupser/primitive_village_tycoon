local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)

local TriggerLoaderOperation = {}
TriggerLoaderOperation.__index = TriggerLoaderOperation
TriggerLoaderOperation.__className = "TriggerLoaderOperation"

function TriggerLoaderOperation.start()
    TriggerManager.init()
    StateManager.init()
end

return TriggerLoaderOperation