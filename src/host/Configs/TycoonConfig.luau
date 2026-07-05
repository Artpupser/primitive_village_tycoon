local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SimpleInstance = require(ReplicatedStorage.Shared.Utils.SimpleInstance)

local TycoonServiceModule : {
    TycoonPrefab : Model,
    Amount : number,
} = {
    TycoonPrefab = ServerStorage.Prefabs.TycoonPrefab,
    Amount = 4,
    Folder = SimpleInstance.new("Folder"):rename("Tycoons"):parent(workspace):build()
}

return TycoonServiceModule