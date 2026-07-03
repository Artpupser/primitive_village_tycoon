local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)

local StateManager = {}
StateManager.__index = StateManager
StateManager.__className = "StateManager"

local isServer = RunService:IsServer()

StateManager.Shared = {}
StateManager.Local = {}


function StateManager.set(player:Player, id:string, value:any)
    if isServer then
        local state = StateManager.Shared[player]
        if state then
            state[id] = value
        end
    else
        StateManager.Local[id] = value
    end
end

function StateManager.get(player:Player, id:string) : any
    if isServer then
        local state = StateManager.Shared[player]
        if state then
            return state[id]
        end
        return nil
    else
        return StateManager.Local[id]
    end
end

function StateManager.getReadOnly(id:string) : any
    if not isServer then
        return StateManager.GetServerStateRemoteFunction:InvokeServer(id)
    end
    return nil
end

function StateManager.create(player: Players)
    if isServer then
        StateManager.Shared[player] = {}
    else
        if StateManager.Local == nil then
            StateManager.Local = {}
        end
    end
end

function StateManager.clear(player:Player)
    if isServer then
        StateManager.Shared[player] = nil
    else
        StateManager.Local = {}
    end
end

function StateManager.init() 
    if isServer then
        TriggerManager.createRemoteFunction("get_server_state").OnServerInvoke = StateManager.get
        StateManager.Shared = {}
        StateManager.Local = nil
    else
        StateManager.GetServerStateRemoteFunction = TriggerManager.getRemoteFunction("get_server_state")
        StateManager.Shared = nil
        StateManager.Local = {}
    end
end

return StateManager