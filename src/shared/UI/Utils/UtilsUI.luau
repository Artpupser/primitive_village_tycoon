local UtilsUI = {}
UtilsUI.__className = "UtilsUI"
UtilsUI.__index = UtilsUI

 function UtilsUI.exceptHandler(list, id)
    local cache = {}
    for _, v in pairs(list) do
        if v.id == id then
            continue
        end
        table.insert(cache, v)
    end
    return cache
end

function UtilsUI.createChildren(list, args) 
    local cache = table.clone(list)
    local put = {
        id = tick(),
    }
    for i, v in pairs(args) do
        put[i] = v
    end
    table.insert(cache, put)
    return cache
end

function UtilsUI.removeMeParent(v:GuiBase)
    v.Parent:Destroy()
end

function UtilsUI.removeMe(v:GuiBase)
    v:Destroy()
end



return UtilsUI