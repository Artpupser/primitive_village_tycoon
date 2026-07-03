local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)
local DataService = require(ServerStorage.Host.Services.DataService)
local Enumerate = require(ReplicatedStorage.Shared.Utils.Enumerate)
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)


local PlayerLoaderOperation = {}
PlayerLoaderOperation.__className = "PlayerLoaderOperation"
PlayerLoaderOperation.__index = PlayerLoaderOperation
PlayerLoaderOperation.characterFolder = nil

--- LOCAL CONSTS ---

local CHARACTER_FOLDER_NAME = "Players"

local CHARACTER_PROPERTIES = {
    ["CollisionGroup"] = "Player",
    ["Material"] = Enum.Material.SmoothPlastic
}

local HUMANOID_PROPERTIES = {
    ["DisplayName"] = "",
    ["WalkSpeed"] = 16,
    ["NameDisplayDistance"] = 0,
    ["HealthDisplayDistance"] = 0,
    ["DisplayDistanceType"] = Enum.HumanoidDisplayDistanceType.None,
    ["MaxHealth"] = 100,
    ["AutomaticScalingEnabled"] = false
}


--- ------------ ---

local function CharacterMaterialSetter(part:Part)
    part.Material = CHARACTER_PROPERTIES.Material
end

local function CharacterCollisionGroupSetter(part:Part)
    part.CollisionGroup = CHARACTER_PROPERTIES.CollisionGroup
end


local function CharacterCanTouchSetter(part:Part)
    part.CanTouch = false
    part.AudioCanCollide = false
end

local function BasicHumanoidConfiguration(humanoid: Humanoid)
    for i, value in pairs(HUMANOID_PROPERTIES) do
        humanoid[i] = value
    end
end

local function CharcaterPutToFolder(humanoid: Humanoid)
    humanoid.Parent.Parent = PlayerLoaderOperation.characterFolder
end

local function CharacterFreeze(humanoid: Humanoid)
    humanoid.Parent:WaitForChild("HumanoidRootPart").Anchored = true
end

local function CharacterModifyBodyParts(humanoid: Humanoid)
    local root:Part = humanoid.Parent:WaitForChild("HumanoidRootPart");
    local touchPart:Part = SimpleInstance.new("Part")
    :rename("Touch")
    :canTouch(true)
    :canCollide(false)
    :canQeury(false)
    :audioCanCollide(false)
    :anchored(false)
    :transparency(1)
    :color(Color3.new(0, 0, 0))
    :cframe(CFrame.new(root.CFrame.X, 4.5, root.CFrame.Z - .2))
    :size(Vector3.new(2, 6, 0.75))
    :parent(root.Parent)
    :build()
    local weldConstraint:WeldConstraint = SimpleInstance.new("WeldConstraint")
    :parent(touchPart)
    :build()
    weldConstraint.Part0 = root
    weldConstraint.Part1 = touchPart
    SimpleInstance.new("Attachment")
        :parent(humanoid.Parent)
        :build()
end

function PlayerLoaderOperation.start()
    PlayerLoaderOperation.characterFolder = SimpleInstance.new("Folder"):rename(CHARACTER_FOLDER_NAME):parent(workspace):build()
    TriggerManager.createPrivateEvent("player_added")
    TriggerManager.createPrivateEvent("player_removed")
    TriggerManager.createRemoteEvent("player_complete_loading").OnServerEvent:Connect(function(player:Player)
        TriggerManager.fireRemoteEvent("notification", player, "Player: "..tostring(player.UserId).." loaded!")
    end)

    DataService.init()

    Players.PlayerAdded:Connect(function(player:Player)
        TriggerManager.firePrivateEvent("player_added", player)
        StateManager.create(player)
        player.CharacterAdded:Connect(function(character: Model)
            local humanoid = character:WaitForChild("Humanoid")
            Enumerate.characterParts(humanoid, function(part)
                CharacterCollisionGroupSetter(part)
                CharacterMaterialSetter(part)
                CharacterCanTouchSetter(part)
            end)
            BasicHumanoidConfiguration(humanoid)
            CharcaterPutToFolder(humanoid)
            CharacterModifyBodyParts(humanoid)
            --CharacterFreeze(humanoid)
        end)
    end)

    Players.PlayerRemoving:Connect(function(player:Player)
        TriggerManager.firePrivateEvent("player_removed", player)
        StateManager.clear(player)
    end)
end

return PlayerLoaderOperation