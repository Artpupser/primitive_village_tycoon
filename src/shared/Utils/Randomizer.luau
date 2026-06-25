local Randomizer = {}
Randomizer.__index = Randomizer
Randomizer.__className = "Randomizer"
Randomizer.seed = time()
Randomizer.rnd = Random.new(Randomizer.seed)

function Randomizer.integer(min:number,max:number)
    return Randomizer.rnd:NextInteger(min,max)
end

function Randomizer.number(range: {min:number, max:number}?) : number
    if range ~= nil then
        return Randomizer.rnd:NextNumber(range.min,range.max)
    end
    return Randomizer.rnd:NextNumber()
end

function Randomizer.vector() : Vector3
    return Randomizer.rnd:NextUnitVector()
end

function Randomizer.str(length: number) : string
    local bytes = {}
    for _ = 1, length do
        table.insert(bytes, Randomizer.integer(33, 126))
    end
    return string.char(table.unpack(bytes))
end 

return Randomizer