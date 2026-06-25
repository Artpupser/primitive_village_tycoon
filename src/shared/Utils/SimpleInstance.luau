local SimpleInstance = {}
SimpleInstance.__index = SimpleInstance
SimpleInstance.__className = "SimpleInstance"



function SimpleInstance.new(className: string) 
    local self = setmetatable({}, SimpleInstance);
    self.value = Instance.new(className)
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