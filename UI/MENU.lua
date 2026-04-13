-- Touch-Based Mobile Menu UI for MainV3
-- TOUCH CONTROLS ONLY

local Config = require(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = require(game.ReplicatedStorage:WaitForChild("Utils"))
local Aimbot = require(game.ReplicatedStorage:WaitForChild("Aimbot"))
local ESP = require(game.ReplicatedStorage:WaitForChild("ESP"))

local Menu = {
    Visible = true,
    Position = Vector2.new(10, 50),
    MenuOpen = false,
}

-- Create menu UI
function Menu.CreateUI()
    local screenSize = Utils.Services.Camera.ViewportSize

    -- Main menu background
    local menuBg = Drawing.new("Square")
    menuBg.Position = Menu.Position
    menuBg.Size = Vector2.new(250, 300)
    menuBg.Color = Color3.fromRGB(30, 30, 30)
    menuBg.Filled = true
    menuBg.Thickness = 2
    menuBg.Visible = Menu.Visible

    -- Title
    local title = Drawing.new("Text")
    title.Text = "MainV3 Mobile"
    title.Position = Menu.Position + Vector2.new(125, 10)
    title.Color = Color3.fromRGB(0, 255, 0)
    title.Size = 16
    title.Center = true
    title.Visible = Menu.Visible

    -- Aimbot status
    local aimbotText = Drawing.new("Text")
    aimbotText.Text = "Aimbot: " .. (Aimbot.Enabled and "ON" or "OFF")
    aimbotText.Position = Menu.Position + Vector2.new(10, 40)
    aimbotText.Color = Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    aimbotText.Size = 14
    aimbotText.Visible = Menu.Visible

    -- ESP status
    local espText = Drawing.new("Text")
    espText.Text = "ESP: " .. (ESP.Enabled and "ON" or "OFF")
    espText.Position = Menu.Position + Vector2.new(10, 70)
    espText.Color = ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    espText.Size = 14
    espText.Visible = Menu.Visible

    -- Status
    local statusText = Drawing.new("Text")
    statusText.Text = "Status: Running"
    statusText.Position = Menu.Position + Vector2.new(10, 100)
    statusText.Color = Color3.fromRGB(0, 255, 0)
    statusText.Size = 12
    statusText.Visible = Menu.Visible

    -- Instructions
    local instructionsText = Drawing.new("Text")
    instructionsText.Text = "Tap: Toggle Menu\nDrag: Move Menu"
    instructionsText.Position = Menu.Position + Vector2.new(10, 130)
    instructionsText.Color = Color3.fromRGB(200, 200, 200)
    instructionsText.Size = 10
    instructionsText.Visible = Menu.Visible

    Menu.UIElements = {
        menuBg = menuBg,
        title = title,
        aimbotText = aimbotText,
        espText = espText,
        statusText = statusText,
        instructionsText = instructionsText,
    }
end

-- Update menu
function Menu.UpdateUI()
    if not Menu.UIElements then return end

    Menu.UIElements.aimbotText.Text = "Aimbot: " .. (Aimbot.Enabled and "ON" or "OFF")
    Menu.UIElements.aimbotText.Color = Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    Menu.UIElements.espText.Text = "ESP: " .. (ESP.Enabled and "ON" or "OFF")
    Menu.UIElements.espText.Color = ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Touch input for menu
Utils.Services.UserInputService.TouchBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    local touchPos = Utils.GetTouchPosition()
    local viewport = Utils.Services.Camera.ViewportSize

    -- Bottom left area opens menu
    if Utils.IsTouchInArea(touchPos, "BottomLeft", viewport) then
        Menu.MenuOpen = not Menu.MenuOpen

        for _, element in pairs(Menu.UIElements) do
            element.Visible = Menu.MenuOpen
        end
    end
end)

-- Start menu
function Menu.Start()
    Menu.CreateUI()
    Menu.MenuOpen = true

    Utils.Services.RunService.RenderStepped:Connect(function()
        Menu.UpdateUI()
    end)
end

Menu.Start()

return Menu
