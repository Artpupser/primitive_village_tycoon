local Enumerate = {}
Enumerate.__index = Enumerate
Enumerate.__className = "Enumerate"

function Enumerate.any<T>(target: Instance, className: string, callback: (T) -> ())
    for _, v:Instance in pairs(target:GetDescendants()) do
        if v:IsA(className) then
            callback(v)
        end
    end
end

function Enumerate.characterParts(humanoid: Humanoid, callback: (BasePart) -> ())
    for _, v:Instance in pairs(humanoid.Parent:GetDescendants()) do
        if v:IsA("BasePart") then
            callback(v)
        end
    end
end

function Enumerate.waitChain(target, array: { string }, index: number)
    local nextIndex = index + 1
    local current = target:WaitForChild(array[index])
    if nextIndex < #array then
        Enumerate.waitChain(current, array[index+1])
    end
    return current
end

function Enumerate.chain(target, array: { string }, index: number)
    local nextIndex = index + 1
    local current = target[array[index]]
    if nextIndex < #array then
        Enumerate.chain(current, array[index+1])
    end
    return current
end


return Enumerate