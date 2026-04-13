-- MainV3.lua - Main entry point for Mobile Delta Execution
-- Complete hub with Aimbot, ESP, Protection, and Touch UI

print("=== MainV3 Mobile Hub Loading ===")

-- Create ReplicatedStorage modules if needed
local function SafeRequire(path)
    local success, result = pcall(function()
        return require(path)
    end)

    if not success then
        warn("Failed to load " .. path .. ": " .. tostring(result))
        return nil
    end

    return result
end

-- Load all core modules
local Config = SafeRequire(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = SafeRequire(game.ReplicatedStorage:WaitForChild("Utils"))
local Protection = SafeRequire(game.ReplicatedStorage:WaitForChild("Protection"))

-- Load feature modules
local Aimbot = SafeRequire(game.ReplicatedStorage:WaitForChild("Aimbot"))
local ESP = SafeRequire(game.ReplicatedStorage:WaitForChild("ESP"))
local Visuals = SafeRequire(game.ReplicatedStorage:WaitForChild("Visuals"))
local Menu = SafeRequire(game.ReplicatedStorage:WaitForChild("Menu"))

-- Main initialization
local MainV3 = {
    Version = "3.0 Mobile",
    Platform = "Mobile/Delta (TOUCH ONLY)",
    Loaded = false,
    RunningModules = {}
}

-- Initialize all systems
function MainV3.Initialize()
    print("[MainV3] Initializing Mobile Hub...")

    if not Config or not Utils or not Protection then
        warn("[MainV3] Core modules failed to load!")
        return false
    end

    if not Aimbot or not ESP or not Visuals or not Menu then
        warn("[MainV3] Feature modules failed to load!")
        return false
    end

    MainV3.RunningModules.Config = Config
    MainV3.RunningModules.Utils = Utils
    MainV3.RunningModules.Protection = Protection
    MainV3.RunningModules.Aimbot = Aimbot
    MainV3.RunningModules.ESP = ESP
    MainV3.RunningModules.Visuals = Visuals
    MainV3.RunningModules.Menu = Menu

    MainV3.Loaded = true

    print("[MainV3] All systems initialized!")
    print("[MainV3] Version:", MainV3.Version)
    print("[MainV3] Platform:", MainV3.Platform)
    print("[MainV3] Protection Active:", (Protection.Active and "YES" or "NO"))
    print("[MainV3] Stealth Mode:", (Protection.StealthMode and "ENABLED" or "DISABLED"))
    print("[MainV3] Touch Trigger Area:", Config.Aimbot.TouchTriggerArea)
    print("[MainV3] Ready for mobile execution!")

    return true
end

-- Cleanup function
function MainV3.Cleanup()
    print("[MainV3] Shutting down...")

    for name, module in pairs(MainV3.RunningModules) do
        if module and module.Stop then
            pcall(function()
                module.Stop()
            end)
        end
    end

    MainV3.Loaded = false
    print("[MainV3] Cleanup complete")
end

-- Start everything
if MainV3.Initialize() then
    print("[MainV3] ✔✔ READY FOR MOBILE EXECUTION ✔✔")
    print("[MainV3] Touch Controls:")
    print("[MainV3] - TopRight: Aimbot Hold")
    print("[MainV3] - BottomLeft: Open Menu")
else
    warn("[MainV3] Failed to initialize!")
end

return MainV3
