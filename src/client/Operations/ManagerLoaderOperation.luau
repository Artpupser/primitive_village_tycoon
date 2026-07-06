local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)
local AudioManager = require(ReplicatedStorage.Shared.Core.AudioManager)


local ManagerLoaderOperation = {}
ManagerLoaderOperation.__index = ManagerLoaderOperation
ManagerLoaderOperation.__className = "ManagerLoaderOperation"

function ManagerLoaderOperation.start()
    TriggerManager.init()
    StateManager.init()
    AudioManager.init()
    AudioManager.next()
end

return ManagerLoaderOperation