local SimpleInstance = {}
SimpleInstance.__index = SimpleInstance
SimpleInstance.__className = "SimpleInstance"



function SimpleInstance.new(className: string) 
    local self = setmetatable({}, SimpleInstance);
    self.value = Instance.new(className)
    return self
end

function SimpleInstance:transparency(value: number)
    self.value.Transparency = value
    return self
end

function SimpleInstance:color(value: Color3)
    self.value.Color = value
    return self
end

function SimpleInstance:canCollide(value:boolean)
    self.value.CanCollide = value
    return self
end

function SimpleInstance:cframe(value:CFrame)
    self.value.CFrame = value
    return self
end

function SimpleInstance:canQeury(value:boolean)
    self.value.CanQuery = value
    return self
end

function SimpleInstance:canTouch(value:boolean)
    self.value.CanTouch = value
    return self
end

function SimpleInstance:anchored(value:boolean)
    self.value.Anchored = value
    return self
end

function SimpleInstance:size(value:Vector3)
    self.value.Size = value
    return self
end

function SimpleInstance:audioCanCollide(value:boolean)
    self.value.AudioCanCollide = value
    return self
end

function SimpleInstance:rename(value:string)
    self.value.Name = value
    return self
end

function SimpleInstance:parent(value:Instance)
    self.value.Parent = value
    return self
end

function SimpleInstance:set(param:string, value: any)
    self.value[param] = value
    return self
end

function SimpleInstance:build() : Instance
    return self.value
end

return SimpleInstance;