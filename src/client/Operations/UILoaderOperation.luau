local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MountUI = require(ReplicatedStorage.Shared.UI.MountUI)

local UILoaderOperation = {}
UILoaderOperation.__index = UILoaderOperation
UILoaderOperation.__className = UILoaderOperation

function UILoaderOperation:start()
    MountUI("Root")
end

return UILoaderOperation

