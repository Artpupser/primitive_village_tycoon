local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)

local TriggerLoaderOperation = {}
TriggerLoaderOperation.__index = TriggerLoaderOperation
TriggerLoaderOperation.__className = "TriggerLoaderOperation"

function TriggerLoaderOperation.start()
    TriggerManager.init()
end

return TriggerLoaderOperation