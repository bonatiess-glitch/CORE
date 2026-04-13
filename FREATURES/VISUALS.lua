-- Visuals Module for Mobile Delta

local Config = require(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = require(game.ReplicatedStorage:WaitForChild("Utils"))

local Visuals = {
    Enabled = Config.Visuals.Crosshair,
    CrosshairParts = {},
}

function Visuals.CreateCrosshair()
    local camera = Utils.Services.Camera
    local viewport = camera.ViewportSize
    local centerX = viewport.X / 2
    local centerY = viewport.Y / 2
    
    local hLine = Drawing.new("Line")
    hLine.From = Vector2.new(centerX - Config.Visuals.CrosshairSize, centerY)
    hLine.To = Vector2.new(centerX + Config.Visuals.CrosshairSize, centerY)
    hLine.Color = Config.Visuals.CrosshairColor
    hLine.Thickness = Config.Visuals.CrosshairThickness
    hLine.Visible = Config.Visuals.Crosshair
    
    local vLine = Drawing.new("Line")
    vLine.From = Vector2.new(centerX, centerY - Config.Visuals.CrosshairSize)
    vLine.To = Vector2.new(centerX, centerY + Config.Visuals.CrosshairSize)
    vLine.Color = Config.Visuals.CrosshairColor
    vLine.Thickness = Config.Visuals.CrosshairThickness
    vLine.Visible = Config.Visuals.Crosshair
    
    local dot = Drawing.new("Circle")
    dot.Position = Vector2.new(centerX, centerY)
    dot.Radius = 2
    dot.Color = Config.Visuals.CrosshairColor
    dot.Filled = true
    dot.Visible = Config.Visuals.Crosshair
    
    Visuals.CrosshairParts = {
        hLine = hLine,
        vLine = vLine,
        dot = dot,
    }
end

function Visuals.UpdateCrosshair()
    if not Config.Visuals.Crosshair then return end
    
    local camera = Utils.Services.Camera
    local viewport = camera.ViewportSize
    local centerX = viewport.X / 2
    local centerY = viewport.Y / 2
    
    if Visuals.CrosshairParts.hLine then
        Visuals.CrosshairParts.hLine.From = Vector2.new(centerX - Config.Visuals.CrosshairSize, centerY)
        Visuals.CrosshairParts.hLine.To = Vector2.new(centerX + Config.Visuals.CrosshairSize, centerY)
    end
    
    if Visuals.CrosshairParts.vLine then
        Visuals.CrosshairParts.vLine.From = Vector2.new(centerX, centerY - Config.Visuals.CrosshairSize)
        Visuals.CrosshairParts.vLine.To = Vector2.new(centerX, centerY + Config.Visuals.CrosshairSize)
    end
    
    if Visuals.CrosshairParts.dot then
        Visuals.CrosshairParts.dot.Position = Vector2.new(centerX, centerY)
    end
end

function Visuals.Start()
    Visuals.CreateCrosshair()
    
    Utils.Services.RunService.RenderStepped:Connect(function()
        Visuals.UpdateCrosshair()
    end)
end

Visuals.Start()

return Visuals
