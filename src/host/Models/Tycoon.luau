local TycoonModel = {}
TycoonModel.__index = TycoonModel
TycoonModel.__className = "TycoonModel"

type TycoonModel = {
    Owner: Player
}

function TycoonModel.new() : TycoonModel
    local self = setmetatable({}, TycoonModel)
    self.Owner = nil
    return self
end 

function TycoonModel:own(player:Player)
    
end


return TycoonModel