local Logical = {}
Logical.__index = Logical
Logical.__className = "Logical"

function Logical.AND(t1:{}, t2:{})
    local result = {}
    for i, value in pairs(t2) do
        if t1[i] ~= nil then
            result[i] = value
        end
    end
    return result
end

function Logical.mergeRecursion(old, new)
 if type(new) ~= "table" then
        return
    end
    for i, v in pairs(new) do
        if type(v) == "table"  then
            if old[i] == nil then
                old[i] = v
                continue
            end
            Logical.merge(old[i], v)
            continue
        end
        if old[i] == nil or type(old[i]) ~= type(v) then
            old[i] = v
        end
    end
end

function Logical.merge(old, new) : {}
   local result = table.clone(old)
   Logical.mergeRecursion(result, new)
   return result
end


function Logical.difference(t1:{}, t2:{})
    local result = {}
    for i, value in pairs(t2) do
        if t1[i] == nil then
            result[i] = value
        end
    end
    return result
end

return Logical