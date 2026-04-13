print("=== MainV3 Mobile Loading ===")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function SafeRequire(module)
    local ok, result = pcall(function()
        return require(module)
    end)

    if not ok then
        warn("[MainV3] Failed:", module.Name)
        return nil
    end

    return result
end

local Config = SafeRequire(ReplicatedStorage:WaitForChild("Config"))
local Utils = SafeRequire(ReplicatedStorage:WaitForChild("Utils"))
local Protection = SafeRequire(ReplicatedStorage:WaitForChild("Protection"))

local Aimbot = SafeRequire(ReplicatedStorage:WaitForChild("Aimbot"))
local ESP = SafeRequire(ReplicatedStorage:WaitForChild("ESP"))
local Visuals = SafeRequire(ReplicatedStorage:WaitForChild("Visuals"))
local Menu = SafeRequire(ReplicatedStorage:WaitForChild("Menu"))

if Config and Utils and Protection and Aimbot and ESP and Visuals and Menu then
    print("[MainV3] ✔ READY ✔")
else
    warn("[MainV3] ERROR LOADING")
end

return {}
