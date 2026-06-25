local Crypto = {}
Crypto.__index = Crypto
Crypto.__className = "Crypto"

function Crypto.hash(str, length)
    local h = 2166136261
    local prime = 16777619
    for i = 1, #str do
        h = bit32.bxor(h, string.byte(str, i))
        h = (h * prime) % 2^32
    end
    h = bit32.bxor(h, h * 0x27d4eb2d)
    h = bit32.bxor(h, bit32.rrotate(h, 16))
    local hex = string.format("%08x", h)
    if length then
        if #hex > length then
            return string.sub(hex, 1, length)
        else
            return string.rep("0", length - #hex) .. hex
        end
    end

    return hex
end


return Crypto