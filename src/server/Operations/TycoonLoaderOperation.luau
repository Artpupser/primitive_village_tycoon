local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TycoonLoaderOperation = {}
TycoonLoaderOperation.__index = TycoonLoaderOperation
TycoonLoaderOperation.__className = "TycoonLoaderOperation"

local TycoonService = require(ServerStorage.Host.Services.TycoonService)

function TycoonLoaderOperation.start()
    TycoonService.init()
end

return TycoonLoaderOperation;