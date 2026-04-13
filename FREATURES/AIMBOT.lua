local Config = require(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = require(game.ReplicatedStorage:WaitForChild("Utils"))
local Protection = require(game.ReplicatedStorage:WaitForChild("Protection"))

local Aimbot = {
    Enabled = Config.Aimbot.Enabled,
    Locked = nil,
    IsAiming = false
}

-- Pegar target mais próximo do FOV
function Aimbot.GetTargetInFOV()
    local camera = Utils.Services.Camera
    local viewport = camera.ViewportSize
    local screenCenter = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local closest = nil
    local closestDistance = Config.Aimbot.FOV

    for _, player in pairs(Utils.Services.Players:GetPlayers()) do
        if player ~= Utils.LocalPlayer and Utils.IsPlayerAlive(player) then
            
            if Config.Aimbot.TeamCheck and player.Team == Utils.LocalPlayer.Team then
                continue
            end

            local character = player.Character
            local targetPart = character and character:FindFirstChild(Config.Aimbot.LockPart)

            if targetPart then
                local screenPos = camera:WorldToViewportPoint(targetPart.Position)
                local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                local distance = (screenVector - screenCenter).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest
end

-- Travar no alvo
function Aimbot.LockTarget(target)
    if not target or not target.Character then return end

    local targetPart = target.Character:FindFirstChild(Config.Aimbot.LockPart)
    if not targetPart then return end

    local camera = Utils.Services.Camera
    local delay = Protection.GetStealthDelay()

    task.wait(delay)

    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
    camera.CFrame = camera.CFrame:Lerp(targetCFrame, Config.Aimbot.Smoothness)

    Aimbot.Locked = target
    Aimbot.IsAiming = true
end

-- Destravar
function Aimbot.UnlockTarget()
    Aimbot.Locked = nil
    Aimbot.IsAiming = false
end

-- Loop principal
function Aimbot.Start()
    Utils.Services.RunService.RenderStepped:Connect(function()
        if not Aimbot.Enabled then return end

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
