-- MainV3.lua - Mobile Hub (Reworked)

print("=== MainV3 Mobile Loading ===")

local function SafeRequire(module)
    local success, result = pcall(function()
        return require(module)
    end)

    if not success then
        warn("[MainV3] Failed to load:", module.Name, result)
        return nil
    end

    return result
end

-- Core
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = SafeRequire(ReplicatedStorage:WaitForChild("Config"))
local Utils = SafeRequire(ReplicatedStorage:WaitForChild("Utils"))
local Protection = SafeRequire(ReplicatedStorage:WaitForChild("Protection"))

-- Features
local Aimbot = SafeRequire(ReplicatedStorage:WaitForChild("Aimbot"))
local ESP = SafeRequire(ReplicatedStorage:WaitForChild("ESP"))
local Visuals = SafeRequire(ReplicatedStorage:WaitForChild("Visuals"))
local Menu = SafeRequire(ReplicatedStorage:WaitForChild("Menu"))

local MainV3 = {
    Version = "3.1 Mobile Rework",
    Loaded = false
}

function MainV3.Initialize()
    print("[MainV3] Initializing...")

    if not (Config and Utils and Protection) then
        warn("[MainV3] Core modules failed!")
        return false
    end

    if not (Aimbot and ESP and Visuals and Menu) then
        warn("[MainV3] Feature modules failed!")
        return false
    end

    MainV3.Loaded = true

    print("[MainV3] Loaded successfully!")
    print("[MainV3] Version:", MainV3.Version)

    return true
end

function MainV3.Cleanup()
    print("[MainV3] Cleaning up...")

    if Aimbot and Aimbot.UnlockTarget then
        Aimbot.UnlockTarget()
    end

    MainV3.Loaded = false
end

-- Start
if MainV3.Initialize() then
    print("[MainV3] ✔ READY ✔")
else
    warn("[MainV3] Failed to start!")
end

return MainV3
