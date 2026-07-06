local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()

local LoadingManager = {}
LoadingManager.services = {}

function LoadingManager.operations(operations:Folder, callbackProgress: (message:string, progress:number) -> ())
    local modules = operations:GetDescendants()
    table.sort(modules, function(a: Instance,b: Instance)
        return a:GetAttribute("priority") < b:GetAttribute("priority")
    end)
    for n, value:Instance in ipairs(modules) do
        LoadingManager.services[value] = value:GetAttribute("include");
        local module = require(value)
        if LoadingManager.services[value] == true then
            callbackProgress("["..n.."/"..#modules.."] Start module <"..value.Name..">", n/#modules)
            module.start()
        end
    end
end

function LoadingManager.assets(delay:number,callbackProgress: (message:string, progress:number) -> ())
    if not isServer then
        local filter = {
            ["Sound"]=true,
            ["MeshPart"]=true,
            ["Decal"]=true,
            ["ImageLabel"]=true,
            ["ImageButton"]=true,
        }
        
        local contentProvider = game:GetService("ContentProvider")
        local assets = game:GetDescendants()
        local load = {}
        for _, v:Instance in ipairs(assets) do
            if filter[v.ClassName] then
                table.insert(load, v)
            end
        end

        local amountLoadAssets = #load
        for i, v in ipairs(load) do
            contentProvider:PreloadAsync({v})
            callbackProgress("["..i.."/"..amountLoadAssets.."] Asset <"..v.Name.."> loaded", i/amountLoadAssets)
            task.wait(delay)
        end
    end
end

function LoadingManager.go(operations:Folder, callbackProgress: (message:string, progress:number) -> ())
    LoadingManager.operations(operations, callbackProgress)
    LoadingManager.assets(callbackProgress)
end

return LoadingManager