local LoadingManager = {}
LoadingManager.services = {}

function LoadingManager.go(operations: Folder)
    local modules = operations:GetDescendants()
    table.sort(modules, function(a: Instance,b: Instance)
        return a:GetAttribute("priority") < b:GetAttribute("priority")
    end)
    for _, value:Instance in ipairs(modules) do
        LoadingManager.services[value] = value:GetAttribute("include");
        local module = require(value)
        if LoadingManager.services[value] == true then
            print("Starting <"..value.Name.."> module.")
            module.start()
        end
    end
end

return LoadingManager