local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerTypes = require(ServerStorage.Host.ServerTypes)
local TycoonModel = require(ServerStorage.Host.Models.TycoonModel)
local TycoonConfig = require(ServerStorage.Host.Configs.TycoonConfig)
local Types = require(ReplicatedStorage.Shared.Types)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)

local TycoonProvider : ServerTypes.TycoonProvider = {}
TycoonProvider.__index = TycoonProvider
TycoonProvider.__className = "TycoonProvider"

function TycoonProvider:isOwner()
    return self.Owner ~= nil
end

function TycoonProvider:isNil()
    return self.Id == nil and self.TycoonModel == nil
end

function TycoonProvider:unown(player: Player) : boolean
    if self:isOwner() and StateManager.get(player, "tycoon") == self.Id then
        StateManager.set(player, "tycoon", nil)
        TriggerManager.fireRemoteEvent("notification", player, "Player "..player.DisplayName..", unowner self tycoon!")
        TriggerManager.fireRemoteEvent("tycoon_unowner", player, self)
        self.Owner = nil
        task.spawn(function()
            self:start()
        end)
        -- self.TycoonModel.Instance.Enter.Trigger.ProximityPrompt.Enabled = true
        return true
    end
    TriggerManager.fireRemoteEvent("notification", player, "You need to owner any tycoon")
    return false
end

function TycoonProvider:own(player: Player) : boolean
    if not self:isOwner() and StateManager.get(player, "tycoon") == nil then
        StateManager.set(player, "tycoon", self.Id)
        TriggerManager.fireRemoteEvent("notification", player, "Player "..player.DisplayName..", is owner!")
        TriggerManager.fireRemoteEvent("tycoon_owner", player, self)
        -- self.TycoonModel.Instance.Enter.Trigger.ProximityPrompt.Enabled = false
        self.Owner = player
        return true
    end
    TriggerManager.fireRemoteEvent("notification", player, self.Id.." is owned, or you already owner")
    return false
end


function TycoonProvider:load(player:Player)
    
end

function TycoonProvider:start()
    if not self:isNil() then
        self:clear()
    end
    
    self.Id = "Tycoon "..self.Index
    
    local tycoonClone = TycoonConfig.TycoonPrefab:Clone()
    tycoonClone.Parent = TycoonConfig.Folder
    tycoonClone.Name = self.Id
    
    local rotate = 2*math.pi/TycoonConfig.Amount*(self.Index-1)
    tycoonClone.WorldPivot = CFrame.new(0,20,50)
    tycoonClone:PivotTo(tycoonClone.WorldPivot * CFrame.new(0,0,-tycoonClone.WorldPivot.Z))
    tycoonClone:PivotTo(tycoonClone.WorldPivot * CFrame.fromEulerAnglesXYZ(0,rotate,0))
    
    self.TycoonModel = TycoonModel.new(tycoonClone)
    
    self.TycoonModel.Instance.Enter.Trigger.ProximityPrompt.Triggered:Connect(function(player)
        if self.Owner == player then
            self:unown(player)
            return
        end
        self:own(player)
    end)
end

function TycoonProvider:clear()
    if self.TycoonModel ~= nil and self.TycoonModel.Instance ~= nil then
        self.TycoonModel:destroy()
    end
    self.Id = nil
    self.TycoonModel = nil
    self.Owner = nil
end

function TycoonProvider.new(i:number) : ServerTypes.TycoonProvider
    local self = setmetatable({}, TycoonProvider)
    self.Index = i
    self.Id = nil
    self.TycoonModel = nil
    self.Owner = nil
    return self
end


return TycoonProvider