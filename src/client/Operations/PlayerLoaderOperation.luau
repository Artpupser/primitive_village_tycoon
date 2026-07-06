local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Me = Players.LocalPlayer 
local StarterGui = game:GetService("StarterGui")
--local Enumerate = require(ReplicatedStorage.Shared.Utils.Enumerate)
local Logical = require(ReplicatedStorage.Shared.Utils.Logical)
local PlayerLoaderOperation = {}
local SoundService = game:GetService("SoundService")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)

PlayerLoaderOperation.__index = PlayerLoaderOperation
PlayerLoaderOperation.__className = "PlayerLoaderOperation"

--- CHARACTER CONSTS ---

local HUD_PROPERTIES = {
    [Enum.CoreGuiType.AvatarSwitcher] = false,
    [Enum.CoreGuiType.Backpack] = false,
    [Enum.CoreGuiType.Captures] = false,
    [Enum.CoreGuiType.EmotesMenu] = true,
    [Enum.CoreGuiType.ExperienceShop] = false,
    [Enum.CoreGuiType.PlayerList] = false,
    [Enum.CoreGuiType.SelfView] = false,
    [Enum.CoreGuiType.Health] = false,
    [Enum.CoreGuiType.Chat] = false,
    --[Enum.CoreGuiType.All] = true,
}

local AUDIO_DICTIONARY = {
    ["DEFAULT"] = {
        ["Volume"] = .05,
        ["RollOffMaxDistance"] = 200,
        ["RollOffMinDistance"] = 50,
    },
    ["Running"] = {
        ["SoundId"] = "rbxassetid://114867999179920",
        ["Volume"] = .05,
        ["PlaybackSpeed"] = .8,
        ["RollOffMaxDistance"] = "DEFAULT",
        ["RollOffMinDistance"] = 50,
    },
    ["Climbing"] = {
        ["SoundId"] = "rbxassetid://114640039515382",
        ["PlaybackSpeed"] = 1.45,
        ["Volume"] = .2,
        [1] = "DEFAULT"
    },
    ["FreeFalling"] = {
        ["SoundId"] = "rbxassetid://119669684568685",
        [1] = "DEFAULT"
    },
    ["Died"] = {
        ["SoundId"] = "rbxassetid://138867344936809",
        ["Volume"] = .2,
        [1] = "DEFAULT"
    },
    ["GettingUp"] = {
        ["SoundId"] = "",
        [1] = "DEFAULT"
    },
    ["Jumping"] = {
        ["SoundId"] = "rbxassetid://75118626440680",
        [1] = "DEFAULT"
    },
    ["Landing"] = {
        ["SoundGroup"] = SoundService:WaitForChild("Fall"),
        ["SoundId"] = "rbxassetid://81710345021728",
        ["PlaybackSpeed"] = 1,
        [1] = "DEFAULT"
    },
    ["Splash"] = {
        ["SoundId"] = "rbxassetid://124279162156159",
        [1] = "DEFAULT"
    },
    ["Swimming"] ={
        ["SoundId"] = "",
        [1] = "DEFAULT"
    },
}

local function applyAudioConfiguration(initValue, value, target: Instance)
    if type(value) =="table" then
        for i, v in pairs(value) do
            if i == "DEFAULT" then
                continue
            end
            if type(v) == "table" then
                applyAudioConfiguration(initValue, v, target:WaitForChild(i))
                continue
            end
            if v == "DEFAULT" then
                local default = initValue["DEFAULT"];
                if type(i) == "number" then
                    applyAudioConfiguration(initValue, Logical.difference(value, default), target)
                    continue
                end
                if default[i] ~= nil then
                    target[i] = default[i]
                    continue;
                end
                applyAudioConfiguration(default, default, target:WaitForChild(i))
                continue
            end
            target[i] = v
        end
    end
end

local function characterSetCustomSounds(humanoid: Humanoid)
    applyAudioConfiguration(AUDIO_DICTIONARY, AUDIO_DICTIONARY, humanoid.Parent:WaitForChild("HumanoidRootPart"))
end

local function characterSetTycoonRays(humanoid: Humanoid)
    if StateManager.get(Players.LocalPlayer, "owner") == nil or StateManager.get(Players.LocalPlayer, "owner") == false then
        local attachment = humanoid.Parent:FindFirstChild("Attachment");
        for _, v in TriggerManager.getRemoteFunction("tycoon_rays"):InvokeServer() do
            if not v.Ownered then
                v.Ray.Attachment1 = attachment
            end
        end
    end
end

local function characterClearTycoonRays()
    for _, v in TriggerManager.getRemoteFunction("tycoon_rays"):InvokeServer() do
        v.Ray.Attachment1 = nil
    end
end

local function removeNotUsedHUD()
    for i, v in pairs(HUD_PROPERTIES) do
        StarterGui:SetCoreGuiEnabled(i, v)
    end
end

function PlayerLoaderOperation.start()
    removeNotUsedHUD()
    Me.CharacterAdded:Connect(function(character: Model)
        local humanoid = character:WaitForChild("Humanoid")
        characterSetCustomSounds(humanoid)
        characterSetTycoonRays(humanoid)
    end)

    TriggerManager.getRemoteEvent("tycoon_owner").OnClientEvent:Connect(function()
        StateManager.set(Players.LocalPlayer, "owner", true)
        characterClearTycoonRays()
    end)

    TriggerManager.getRemoteEvent("tycoon_unowner").OnClientEvent:Connect(function()
        StateManager.set(Players.LocalPlayer, "owner", false)
        characterSetTycoonRays(Players.LocalPlayer.Character:WaitForChild("Humanoid"))
    end)

end

return PlayerLoaderOperation