local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Me = Players.LocalPlayer
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)
local isServer = RunService:IsServer()

local TriggerManager : {
    Folders : {
        Replicated : Folder,
        Server: Folder,
        Client: Folder,
    },
    Triggers: {
        Public: { RemoteFunction|RemoteEvent } ,
        Unreliable: { UnreliableRemoteEvent } ,
        Private:  { BindableFunction|BindableEvent }
    }
} = {}
TriggerManager.__index = TriggerManager
TriggerManager.__className = "EventManager"

function TriggerManager.init()
    TriggerManager.Folders = {}
    TriggerManager.Folders.Replicated = nil
    TriggerManager.Folders.Unreliable = nil
    TriggerManager.Folders.Server = nil
    TriggerManager.Folders.Client = nil
    TriggerManager.Triggers = {}
    TriggerManager.Triggers.Private = {}
    if isServer then
        TriggerManager.Triggers.Public = {}
        TriggerManager.Triggers.Unreliable = {}
        TriggerManager.Folders.Replicated = SimpleInstance.new("Folder")
            :rename("Triggers")
            :parent(ReplicatedStorage)
            :build()
        TriggerManager.Folders.Unreliable = SimpleInstance.new("Folder")
            :rename("Unreliable")
            :parent(TriggerManager.Folders.Replicated)
            :build()
        TriggerManager.Folders.Server = SimpleInstance.new("Folder")
            :rename("Triggers")
            :parent(ServerStorage)
            :build()
    else
        TriggerManager.Folders.Client = SimpleInstance.new("Folder")
            :rename("Triggers")
            :parent(Me.PlayerScripts)
            :build()
        TriggerManager.Folders.Replicated = ReplicatedStorage:WaitForChild("Triggers")
        TriggerManager.Folders.Unreliable = TriggerManager.Folders.Replicated:WaitForChild("Unreliable")
        print("Find: ", TriggerManager.Folders.Client)
    end
    if TriggerManager.Folders.Replicated == nil then
        error("ReplicatedTriggers folder not undfined.")
    end
end

-- unreliable public events

function TriggerManager.createUnreliableEvent(id:string) : UnreliableRemoteEvent
       if isServer then
        local trigger : UnreliableRemoteEvent = SimpleInstance.new("UnreliableRemoteEvent")
            :rename(id)
            :parent(TriggerManager.Folders.Unreliable)
            :build()
        TriggerManager.Triggers.Public[id] = trigger
        print("<UnreliableRemoteEvent> created: "..id)
        return trigger
    end
    warn("Client not can create unreliable remote event")
end

function TriggerManager.getUnreliableEvent(id:string) : UnreliableRemoteEvent
    if isServer then
        return TriggerManager.Triggers.Unreliable[id]
    else
        return TriggerManager.Folders.Unreliable:FindFirstChild(id)
    end
end

-- public triggers

local function createRemote(id:string, className: string) : RemoteEvent|RemoteFunction
    if isServer then
        local trigger : RemoteEvent|RemoteFunction = SimpleInstance.new(className)
            :rename(id)
            :parent(TriggerManager.Folders.Replicated)
            :build()
        TriggerManager.Triggers.Public[id] = trigger
        print("<"..className.."> created: "..id)
        return trigger
    end
    warn("Client not can create remote trigger")
end

local function getRemote(id:string) : RemoteEvent|RemoteFunction
    if isServer then
        return TriggerManager.Triggers.Public[id]
    else
        return TriggerManager.Folders.Replicated:FindFirstChild(id)
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
    if isServer then
        remoteFunction:InvokeClient(Players.LocalPlayer, ...)
    else
        remoteFunction:InvokeServer(...)
    end
end

function TriggerManager.fireRemoteEvent(id:string, player:Player?, ...)
    local remoteEvent = TriggerManager.getRemoteEvent(id)
    if isServer then
        remoteEvent:FireClient(player, ...)
    else
        remoteEvent:FireServer(...)
    end
end

function TriggerManager.fireAllClientsEvent(id:string, ...)
    local remoteEvent = TriggerManager.getRemoteEvent(id)
    if isServer then
        remoteEvent:FireAllClients(...)
        return
    end
    warn("Client not can fire event to all clients.")
end

-- private triggers

function TriggerManager.createPrivate(id:string, className:string) : Instance
    local trigger : BindableEvent|BindableFunction = SimpleInstance.new(className)
        :rename(id)
        :parent(if isServer then TriggerManager.Folders.Server else TriggerManager.Folders.Client)
        :build()
    TriggerManager.Triggers.Private[id] = trigger
    print("<"..className.."> created: "..id)
    return trigger
end

function TriggerManager.getPrivate(id:string):Instance
    return TriggerManager.Triggers.Private[id];
end

function TriggerManager.createPrivateEvent(id: string) : BindableEvent
    return TriggerManager.createPrivate(id, "BindableEvent")
end

function TriggerManager.getPrivateEvent(id: string) : BindableEvent
    return TriggerManager.getPrivate(id);
end

function TriggerManager.createPrivateFunction(id: string) : BindableFunction
return TriggerManager.createPrivate(id, "BindableFunction")
end

function TriggerManager.getPrivateFunction(id: string) : BindableFunction
    return TriggerManager.getPrivate(id);
end

function TriggerManager.firePrivateEvent(id: string, ...)
    local bindableEvent = TriggerManager.getPrivateEvent(id)
    bindableEvent:Fire(...)
end

function TriggerManager.invokePrivateFunction(id: string, ...)
    TriggerManager.getPrivateFunction(id):Invoke(...)
end

return TriggerManager
