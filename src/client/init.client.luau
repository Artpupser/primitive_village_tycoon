local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoadingManager = require(ReplicatedStorage.Shared.Core.LoadingManager)
LoadingManager.operations(script.Operations, function(message, progress)
    print(message.." ".. progress*100 .."%")
end)

local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local MountUI = require(ReplicatedStorage.Shared.UI.MountUI)

Players.LocalPlayer.PlayerGui:FindFirstChild("BlackScreen"):Destroy()

TriggerManager.createPrivateEvent("loading_status")

MountUI("loading")

LoadingManager.assets(0,function(message, progress)
    TriggerManager.firePrivateEvent("loading_status", message, progress)
end)