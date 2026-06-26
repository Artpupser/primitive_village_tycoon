local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local CollectionService = game:GetService("CollectionService")

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
    for _, v:BasePart in pairs(CollectionService:GetTagged("kill")) do
        v.Touched:Connect(function(otherPart)
            local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
            if humanoid ~= nil then
                humanoid.Health = 0
            end
        end)
    end
end

return TycoonService