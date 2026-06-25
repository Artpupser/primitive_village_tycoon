local Pessimistic = {}
Pessimistic.__index = Pessimistic
Pessimistic.__className = "Pessimistic"

function Pessimistic.kickAllPlayers(message:string)
    for _, v:Player in pairs(game:GetService("Players")) do
        v:Kick(message or "Server execute operation: shutdown")
    end
end

function Pessimistic.pcallAttemptsTimer(attempts: number, timer: number, action: () -> any, bad: () -> ()?)
     while attempts > 0 do
        local success, value = pcall(function()
            return action()
        end)
        if success then
            return value
        end
        error("[Pessimistic.pcallAttempts] Bad operation, attempts remaning: "..attempts)
        attempts = attempts - 1;
        task.wait(timer)
    end
    error("[Pessimistic.pcallAttempts] [BAD] last operation...")
    if bad then
        print("[Pessimistic.pcallAttempts] Execute bad function")
        return bad()
    end
end

function Pessimistic.pcallAttempts(attempts: number, action: () -> any, bad: () -> ()?)
     while attempts > 0 do
        local success, value = pcall(function()
            return action()
        end)
        if success then
            return value
        end
        error("[Pessimistic.pcallAttempts] Bad operation, attempts remaning: "..attempts)
        attempts = attempts - 1;
    end
    error("[Pessimistic.pcallAttempts] [BAD] last operation...")
    if bad then
        print("[Pessimistic.pcallAttempts] Execute bad function")
        return bad()
    end
end

return Pessimistic