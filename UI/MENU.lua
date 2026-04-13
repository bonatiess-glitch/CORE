local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Aimbot = require(game.ReplicatedStorage:WaitForChild("Aimbot"))
local ESP = require(game.ReplicatedStorage:WaitForChild("ESP"))

local Menu = {}

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "MainV3_UI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "MainV3 Mobile"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,0)

local aimbotBtn = Instance.new("TextButton", frame)
aimbotBtn.Size = UDim2.new(1,-20,0,40)
aimbotBtn.Position = UDim2.new(0,10,0,40)

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1,-20,0,40)
espBtn.Position = UDim2.new(0,10,0,90)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,0)
closeBtn.Text = "X"

local function update()
    aimbotBtn.Text = "Aimbot: " .. (Aimbot.Enabled and "ON" or "OFF")
    espBtn.Text = "ESP: " .. (ESP.Enabled and "ON" or "OFF")
end

aimbotBtn.MouseButton1Click:Connect(function()
    Aimbot.Enabled = not Aimbot.Enabled
    update()
end)

espBtn.MouseButton1Click:Connect(function()
    ESP.Enabled = not ESP.Enabled
    update()
end)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- DRAG
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

update()

return Menu
