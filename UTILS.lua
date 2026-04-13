-- Utility Functions for MainV3 Mobile
-- Touch-based input handling

local Utils = {}

-- Cache common services
Utils.Services = {
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Players = game:GetService("Players"),
    Workspace = workspace,
    Camera = workspace.CurrentCamera,
}

Utils.LocalPlayer = Utils.Services.Players.LocalPlayer
Utils.Mouse = Utils.LocalPlayer:GetMouse()

-- Vector utilities
function Utils.GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utils.GetClosestPlayer(maxDistance)
    local closest = nil
    local closestDistance = maxDistance or math.huge
    
    for _, player in pairs(Utils.Services.Players:GetPlayers()) do
        if player ~= Utils.LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = Utils.GetDistance(Utils.LocalPlayer.Character.HumanoidRootPart.Position, humanoidRootPart.Position)
                if distance < closestDistance then
                    closest = player
                    closestDistance = distance
                end
            end
        end
    end
    
    return closest, closestDistance
end

-- Touch utilities for mobile
function Utils.GetTouchPosition()
    return Vector2.new(Utils.Mouse.X, Utils.Mouse.Y)
end

function Utils.IsTouchInArea(touchPos, areaName, viewportSize)
    local quarterX = viewportSize.X / 4
    local quarterY = viewportSize.Y / 4
    
    if areaName == "TopRight" then
        return touchPos.X > viewportSize.X * 0.75 and touchPos.Y < viewportSize.Y * 0.25
    elseif areaName == "TopLeft" then
        return touchPos.X < viewportSize.X * 0.25 and touchPos.Y < viewportSize.Y * 0.25
    elseif areaName == "BottomRight" then
        return touchPos.X > viewportSize.X * 0.75 and touchPos.Y > viewportSize.Y * 0.75
    elseif areaName == "BottomLeft" then
        return touchPos.X < viewportSize.X * 0.25 and touchPos.Y > viewportSize.Y * 0.75
    elseif areaName == "Center" then
        return touchPos.X > viewportSize.X * 0.4 and touchPos.X < viewportSize.X * 0.6 and 
               touchPos.Y > viewportSize.Y * 0.4 and touchPos.Y < viewportSize.Y * 0.6
    end
    
    return false
end

-- Character utilities
function Utils.IsPlayerAlive(player)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

function Utils.GetCharacterPart(player, partName)
    if not player.Character then return nil end
    return player.Character:FindFirstChild(partName)
end

-- Raycast utilities
function Utils.RaycastBetween(from, to)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Utils.LocalPlayer.Character}
    
    local direction = (to - from).Unit * 1000
    local rayResult = workspace:Raycast(from, direction, raycastParams)
    
    return rayResult
end

-- Performance utilities
function Utils.Throttle(fn, delay)
    local last = 0
    return function(...)
        local now = tick()
        if now - last >= delay then
            last = now
            return fn(...)
        end
    end
end

-- Random delay for stealth
function Utils.GetRandomDelay(minDelay, maxDelay)
    return math.random(minDelay * 1000, maxDelay * 1000) / 1000
end

return Utils
