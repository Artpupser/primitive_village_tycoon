local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)

local TriggerLoaderOperation = {}
TriggerLoaderOperation.__index = TriggerLoaderOperation

function TriggerLoaderOperation.start()
    TriggerManager.init()
    TriggerManager.createRemoteEvent("notification")

    --task.wait(5)
    --TriggerManager.fireAllClientsEvent("notification", "Hello world!")
end

return TriggerLoaderOperation