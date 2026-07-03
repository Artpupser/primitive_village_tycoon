local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)

local TriggerLoaderOperation = {}
TriggerLoaderOperation.__index = TriggerLoaderOperation

function TriggerLoaderOperation.start()
    TriggerManager.init()
    TriggerManager.createRemoteEvent("notification")
    StateManager.init()

    --task.wait(5)
    --TriggerManager.fireAllClientsEvent("notification", "Hello world!")
end

return TriggerLoaderOperation