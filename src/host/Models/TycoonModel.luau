local ServerStorage = game:GetService("ServerStorage")
local ServerTypes = require(ServerStorage.Host.ServerTypes)

local TycoonModel = {}
TycoonModel.__index = TycoonModel
TycoonModel.__className = "TycoonModel"

function TycoonModel:destroy()
    if self.Instance then
        self.Instance:Destroy()
    end
    self.Decorations = nil
    self.NPC = nil
    self.Intreact = nil
    setmetatable(self, nil)
end

function TycoonModel.new(model) : ServerTypes.TycoonModel
    local self = setmetatable({}, TycoonModel)
    self.Instance = model
    self.Decorations = model.Decorations
    self.NPC = model.NPC
    self.Intreact = model.Interact
    return self
end

return TycoonModel