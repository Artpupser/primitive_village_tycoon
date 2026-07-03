local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerTypes = require(ServerStorage.Host.ServerTypes)
local Types = require(ReplicatedStorage.Shared.Types)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)

local TycoonProvider : ServerTypes.TycoonProvider = {}
TycoonProvider.__index = TycoonProvider
TycoonProvider.__className = "TycoonProvider"

function TycoonProvider:isOwner()
    return self.Owner ~= nil
end

local function loadTycoon(self:ServerTypes.TycoonProvider, player:Player)
    
end

local function clearTycoon(self:ServerTypes.TycoonProvider, player:Player)
    
end

function TycoonProvider:unown(player: Player) : boolean
    if self:isOwner() and StateManager.get(player, "tycoon") == self.Id then
        StateManager.set(player, "tycoon", nil)
        TriggerManager.fireRemoteEvent("notification", player, "Player "..player.DisplayName..", unowner self tycoon!")
        TriggerManager.fireRemoteEvent("tycoon_unowner", player, self)
        self.Owner = nil
        self.TycoonModel.Enter.Enabled = true
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
        self.TycoonModel.Enter.Enabled = false
        self.Owner = player
        return true
    end
    TriggerManager.fireRemoteEvent("notification", player, self.Id.." is owned, or you already owner")
    return false
end

function TycoonProvider.new(model: ServerTypes.TycoonModel) : ServerTypes.TycoonProvider
    local self = setmetatable({}, TycoonProvider)
    self.Id = model.Instance.Name
    self.TycoonModel = model
    self.Owner = nil
    self.TycoonModel.Enter.Triggered:Connect(function(player)
        self:own(player)
    end)
    return self
end


return TycoonProvider