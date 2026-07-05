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
local TycoonConfig = require(ServerStorage.Host.Configs.TycoonConfig)


local TycoonService : ServerTypes.TycoonService = {
    TycoonProviders = {},
    Folder = nil
} 
TycoonService.__index = TycoonService
TycoonService.__className = "TycoonService"

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
    
    TriggerManager.getPrivateEvent("player_removed").Event:Connect(function(player:Player)
        local tycoonId = StateManager.get(player, "tycoon")
        if tycoonId ~= nil and TycoonService.TycoonProviders[tycoonId] ~= nil then
            local tycoonProvider : ServerTypes.TycoonProvider = TycoonService.TycoonProviders[tycoonId]
            tycoonProvider:unown(player)
        end
    end)

    for i = TycoonConfig.Amount, 1, -1 do
        local tycoonProvider = TycoonProvider.new(i)
        tycoonProvider:start()
        TycoonService.TycoonProviders[tycoonProvider.Index] = tycoonProvider
    end
end

return TycoonService