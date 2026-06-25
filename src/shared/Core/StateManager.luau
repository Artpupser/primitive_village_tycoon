local StateManager = {}
StateManager.__index = StateManager
StateManager.__className = "StateManager"

function StateManager.new()
    local self = setmetatable({}, StateManager)
    self.states = table.create(0,{})
    return self
end

function StateManager:setState(value: any, state: string)
    self.states[value] = state
end

function StateManager:tradeState(value: any, state: string) : string?
    local cache = self:getState(value)
    self:setState(value, state)
    return cache
end

function StateManager:deleteState(value: any)
   self:getStateCallback(value, function(_)
        table.remove(self.states, value)
   end)
end

function StateManager:getStateCallback(value: any, callback: (state:string) -> {})
    local state = self.states[value]
    if  state ~= nil then
       callback(state)
    end
end

function StateManager:getState(value: any)
    local state = self.states[value]
    if  state ~= nil then
       return state
    end
    return nil
end

function StateManager:all()
    return self.states
end

return StateManager