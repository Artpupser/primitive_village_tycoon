local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
-- local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)
-- local CollectionService = game:GetService("CollectionService")
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)
local TycoonModel = require(ServerStorage.Host.Models.TycoonModel)
local TycoonProvider = require(ServerStorage.Host.Providers.TycoonProvider)
local ServerTypes = require(ServerStorage.Host.ServerTypes)
local StateManager = require(ReplicatedStorage.Shared.Core.StateManager)
local TriggerManager = require(ReplicatedStorage.Shared.Core.TriggerManager)


local TycoonService : ServerTypes.TycoonService = {
    TycoonProviders = {},
    Folder = nil
} 
TycoonService.__index = TycoonService
TycoonService.__className = "TycoonService"

local TYCOON_PREFAB : Model = ServerStorage.Prefabs.TycoonPrefab
local AMOUNT = 4

function TycoonService.getRays()
    local attachments = {}
    for _,v in pairs(TycoonService.TycoonProviders) do
        attachments[v.Id] = {
            Ownered = v.Owner ~= nil,
            Ray = v.TycoonModel.Instance.Enter.Ray
        }
    end
    return attachments
end

function TycoonService.init()
    TriggerManager.createRemoteFunction("tycoon_rays").OnServerInvoke = TycoonService.getRays
    TriggerManager.createRemoteEvent("tycoon_owner")
    TriggerManager.createRemoteEvent("tycoon_unowner")

    TycoonService.Folder = SimpleInstance.new("Folder"):rename("Tycoons"):parent(workspace):build()
    for i = AMOUNT, 1, -1 do
        local tycoonClone : Model = TYCOON_PREFAB:Clone();
        tycoonClone.Parent = TycoonService.Folder
        tycoonClone.Name = "Tycoon "..i
        local rotate = 2*math.pi/AMOUNT*(i-1)
        tycoonClone.WorldPivot = CFrame.new(0,20,50)
        tycoonClone:PivotTo(tycoonClone.WorldPivot * CFrame.new(0,0,-tycoonClone.WorldPivot.Z))
        tycoonClone:PivotTo(tycoonClone.WorldPivot * CFrame.fromEulerAnglesXYZ(0,rotate,0))
        local tycoonProvider = TycoonProvider.new(TycoonModel.new(tycoonClone))
        TycoonService.TycoonProviders[tycoonClone.Name] = tycoonProvider
    end

    TriggerManager.getPrivateEvent("player_removed").Event:Connect(function(player:Player)
        local tycoonId = StateManager.get(player, "tycoon")
        if tycoonId ~= nil and TycoonService.TycoonProviders[tycoonId] ~= nil then
            local tycoonProvider : ServerTypes.TycoonProvider = TycoonService.TycoonProviders[tycoonId]
            tycoonProvider:unown(player)
        end
    end)
end

return TycoonService