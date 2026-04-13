-- Advanced Protection Module for 2026 Anticheat Detection
-- Mobile Delta Protection

local Config = require(script.Parent:WaitForChild("Config"))
local Utils = require(script.Parent:WaitForChild("Utils"))

local Protection = {
    Active = Config.Protection.AntiCheatDetection,
    DetectedThreats = {},
    StealthMode = Config.Protection.StealthMode,
}

-- Anti-Hook Detection
function Protection.DetectHooks()
    local suspiciousFunctions = {
        "GetPropertyChangedSignal",
        "Changed",
        "ChildAdded",
        "ChildRemoved",
    }
    
    for _, func in pairs(suspiciousFunctions) do
        if not rawget(game, func) then
            table.insert(Protection.DetectedThreats, "Hook detected on: " .. func)
        end
    end
end

-- Anti-Speedhack Detection
local lastCheck = tick()
function Protection.DetectSpeedhack()
    local currentTick = tick()
    local deltaTime = currentTick - lastCheck
    
    if deltaTime < 0.01 then
        table.insert(Protection.DetectedThreats, "Possible speedhack detected")
    end
    
    lastCheck = currentTick
end

-- Anti-Memory Tampering
function Protection.ProtectMemory()
    local originalSetmetatable = setmetatable
    
    setmetatable = function(...)
        if Config.Protection.AntiCheatDetection then
            warn("Metatable modification detected - possible tampering")
        end
        return originalSetmetatable(...)
    end
end

-- Stealth Movement - Add random human-like delays
function Protection.GetStealthDelay()
    if Config.Protection.RandomDelays then
        return Utils.GetRandomDelay(Config.Protection.MinDelay, Config.Protection.MaxDelay)
    end
    return 0
end

-- Network Traffic Obfuscation
function Protection.ObfuscateNetworkCall(functionName, args)
    if Config.Mobile.CompressedNetworking then
        local randomPrefix = math.random(1000, 9999)
        return {
            prefix = randomPrefix,
            function = functionName,
            args = args,
            timestamp = tick(),
        }
    end
    return { function = functionName, args = args }
end

-- Delta-specific Anti-Detection
function Protection.DeltaProtection()
    if Config.Protection.StealthMode then
        getgenv().script = nil
        getgenv()._G = {}
        wait(math.random(1, 3))
    end
end

-- Initialize Protection
function Protection.Init()
    Protection.DetectHooks()
    Protection.ProtectMemory()
    Protection.DeltaProtection()
    
    Utils.Services.RunService.RenderStepped:Connect(function()
        Protection.DetectSpeedhack()
    end)
    
    print("[Protection] Module initialized with stealth mode:", Protection.StealthMode)
end

Protection.Init()

return Protection
