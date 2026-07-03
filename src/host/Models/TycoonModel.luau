local ServerStorage = game:GetService("ServerStorage")
local ServerTypes = require(ServerStorage.Host.ServerTypes)

local TycoonModel = {}
TycoonModel.__index = TycoonModel
TycoonModel.__className = "TycoonModel"

function TycoonModel.new(model) : ServerTypes.TycoonModel
    local self = setmetatable({}, TycoonModel)
    self.Instance = model
    self.Decorations = model.Decorations
    self.NPC = model.NPC
    self.Intreact = model.Interact
    self.Enter = model.Enter.Trigger.ProximityPrompt
    return self
end

return TycoonModel