local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)
local Players = game:GetService("Players")
local TriggerManager = {}
TriggerManager.__index = TriggerManager
TriggerManager.__className = "EventManager"

TriggerManager.isServer = RunService:IsServer()
TriggerManager.Folders = {}
TriggerManager.Folders.Main = nil
TriggerManager.Folders.Public = nil
TriggerManager.Folders.Private = nil

TriggerManager.Triggers = {}
TriggerManager.Triggers.Public = {}
TriggerManager.Triggers.Private = {}

function TriggerManager.init()
    print("Event manager initializing...")
    if TriggerManager.isServer then
        TriggerManager.Folders.Main = SimpleInstance.new("Folder")
            :rename("Triggers")
            :parent(ReplicatedStorage)
            :build()
        TriggerManager.Folders.Public = SimpleInstance.new("Folder")
            :rename("Public")
            :parent(TriggerManager.Folders.Main)
            :build()
        TriggerManager.Folders.Private = SimpleInstance.new("Folder")
            :rename("Private")
            :parent(TriggerManager.Folders.Main)
            :build()
    else
        TriggerManager.Folders.Main = ReplicatedStorage:WaitForChild("Triggers")
        TriggerManager.Folders.Public = TriggerManager.Folders.Main:WaitForChild("Public")
        TriggerManager.Folders.Private = TriggerManager.Folders.Main:WaitForChild("Private")
    end
    if TriggerManager.Folders.Main == nil then
        error("Triggers folder not undfined.")
    end
end

-- public triggers

local function createRemote(id:string, className: string) : Instance
     if TriggerManager.isServer then
        local remote : RemoteEvent = SimpleInstance.new(className)
            :rename(id):parent(TriggerManager.Folders.Public):build()
        TriggerManager.Triggers.Public[id] = remote
        return remote
    end
    warn("Client not can create public trigger")
end

local function getRemote(id:string) : Instance
    if TriggerManager.isServer then
        return TriggerManager.Triggers.Public[id]
    else
        return TriggerManager.Folders.Public:FindFirstChild(id)
    end
end

function TriggerManager.createRemoteEvent(id: string) : RemoteEvent
    return createRemote(id, "RemoteEvent")
end

function TriggerManager.getRemoteEvent(id: string) : RemoteEvent
    return getRemote(id)
end

function TriggerManager.createRemoteFunction(id:string) : RemoteFunction
    return createRemote(id, "RemoteFunction")
end

function TriggerManager.getRemoteFunction(id: string) : RemoteFunction
    return getRemote(id)
end

function TriggerManager.invokeRemoteFunction(id:string, ...)
    local remoteFunction = TriggerManager.getRemoteFunction(id)
    if TriggerManager.isServer then
        remoteFunction:InvokeClient(Players.LocalPlayer, ...)
    else
        remoteFunction:InvokeServer(...)
    end
end


function TriggerManager.fireRemoteEvent(id:string, player:Player?, ...)
    local remoteEvent = TriggerManager.getRemoteEvent(id)
    if TriggerManager.isServer then
        remoteEvent:FireClient(player, ...)
    else
        remoteEvent:FireServer(...)
    end
end

function TriggerManager.fireAllClientsEvent(id:string, ...)
    local remoteEvent = TriggerManager.getRemoteEvent(id)
    if TriggerManager.isServer then
        remoteEvent:FireAllClients(...)
        return
    end
    warn("Client not can fire event to all clients.")
end

-- private triggers

function TriggerManager.createPrivateEvent(id: string) : BindableEvent
    local bindableEvent : BindableEvent = SimpleInstance.new("BindableEvent")
        :rename(id)
        :parent(TriggerManager.Folders.Private)
        :build()
    TriggerManager.Triggers.Private[id] = bindableEvent
    print("Created: "..id)
    return bindableEvent
end

function TriggerManager.getPrivateEvent(id: string) : BindableEvent
    return TriggerManager.Triggers.Private[id];
end

function TriggerManager.createPrivateFunction(id: string) : BindableFunction
    local bindableFunction : BindableFunction = SimpleInstance.new("BindableFunction")
        :rename(id)
        :parent(TriggerManager.Folders.Private)
        :build()
    TriggerManager.Triggers.Private[id] = bindableFunction
    return bindableFunction
end

function TriggerManager.getPrivateFunction(id: string) : BindableFunction
    return TriggerManager.Triggers.Private[id];
end

function TriggerManager.firePrivateEvent(id: string, ...)
    local bindableEvent = TriggerManager.getPrivateEvent(id)
    bindableEvent:Fire(...)
end

function TriggerManager.invokePrivateFunction(id: string, ...)
    TriggerManager.getPrivateFunction(id):Invoke(...)
end

return TriggerManager
