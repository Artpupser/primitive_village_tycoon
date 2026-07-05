local HttpService = game:GetService("HttpService")
local UI = {}
UI.__className = "UI"
UI.__index = UI

 function UI.exceptHandler(list, id)
    local cache = {}
    for _, v in pairs(list) do
        if v.id == id then
            continue
        end
        table.insert(cache, v)
    end
    return cache
end

function UI.createChildren(list, args) 
    local cache = table.clone(list)
    local put = {
        id = HttpService:GenerateGUID(false),
    }
    for i, v in pairs(args) do
        put[i] = v
    end
    table.insert(cache, put)
    return cache
end

function UI.removeMeParent(v:GuiBase)
    v.Parent:Destroy()
end

function UI.removeMe(v:GuiBase)
    v:Destroy()
end



return UI