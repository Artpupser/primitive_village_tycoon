local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared");
local TriggerManager = require(Shared.Core.TriggerManager)
TriggerManager.createPrivateEvent("loading_progress")
local MountUI = require(Shared.UI.MountUI)
MountUI("Loading")
local Me = Players.LocalPlayer
local ContentProvider = game:GetService("ContentProvider")

local assets = game:GetChildren();
local amountAssets = #assets;
for i, v in pairs(assets) do
    ContentProvider:PreloadAsync({v})
    TriggerManager.firePrivateEvent("loading_progress", i/amountAssets)
    --print(amountAssets/i)
    task.wait(0.01)
end

TriggerManager.fireRemoteEvent("player_complete_loading", Me)