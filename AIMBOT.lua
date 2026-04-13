local Config = require(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = require(game.ReplicatedStorage:WaitForChild("Utils"))
local Protection = require(game.ReplicatedStorage:WaitForChild("Protection"))

local Aimbot = {
    Enabled = Config.Aimbot.Enabled,
    Locked = nil,
    IsAiming = false
}

function Aimbot.GetTargetInFOV()
    local camera = Utils.Services.Camera
    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X/2, viewport.Y/2)

    local closest, dist = nil, Config.Aimbot.FOV

    for _, player in pairs(Utils.Services.Players:GetPlayers()) do
        if player ~= Utils.LocalPlayer and Utils.IsPlayerAlive(player) then

            if Config.Aimbot.TeamCheck and player.Team == Utils.LocalPlayer.Team then
                continue
            end

            local char = player.Character
            local part = char and char:FindFirstChild(Config.Aimbot.LockPart)

            if part then
                local pos = camera:WorldToViewportPoint(part.Position)
                local vec = Vector2.new(pos.X, pos.Y)
                local mag = (vec - center).Magnitude

                if mag < dist then
                    dist = mag
                    closest = player
                end
            end
        end
    end

    return closest
end

function Aimbot.LockTarget(target)
    if not target or not target.Character then return end

    local part = target.Character:FindFirstChild(Config.Aimbot.LockPart)
    if not part then return end

    local cam = Utils.Services.Camera

    task.wait(Protection.GetStealthDelay())

    local cf = CFrame.new(cam.CFrame.Position, part.Position)
    cam.CFrame = cam.CFrame:Lerp(cf, Config.Aimbot.Smoothness)

    Aimbot.Locked = target
    Aimbot.IsAiming = true
end

function Aimbot.UnlockTarget()
    Aimbot.Locked = nil
    Aimbot.IsAiming = false
end

function Aimbot.Start()
    Utils.Services.RunService.RenderStepped:Connect(function()

        if not Aimbot.Enabled then
            Aimbot.UnlockTarget()
            return
        end

        if Aimbot.IsAiming and Aimbot.Locked then
            Aimbot.LockTarget(Aimbot.Locked)
        else
            local target = Aimbot.GetTargetInFOV()
            if target then
                Aimbot.LockTarget(target)
            end
        end

    end)
end

Aimbot.Start()

return Aimbot
