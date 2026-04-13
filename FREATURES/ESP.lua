-- ESP Module for Mobile Delta

local Config = require(game.ReplicatedStorage:WaitForChild("Config"))
local Utils = require(game.ReplicatedStorage:WaitForChild("Utils"))

local ESP = {
    Enabled = Config.ESP.Enabled,
    Players = {},
}

function ESP.CreatePlayerESP(player)
    if ESP.Players[player.Name] then return end
    
    ESP.Players[player.Name] = {
        Player = player,
        Drawings = {},
    }
    
    local playerESP = ESP.Players[player.Name]
    
    if Config.ESP.NameESP then
        local nameLabel = Drawing.new("Text")
        nameLabel.Text = player.Name
        nameLabel.Color = Config.ESP.NameColor
        nameLabel.Size = 16
        nameLabel.Center = true
        playerESP.Drawings.nameLabel = nameLabel
    end
    
    if Config.ESP.HealthESP then
        local healthLabel = Drawing.new("Text")
        healthLabel.Color = Color3.fromRGB(0, 255, 0)
        healthLabel.Size = 14
        playerESP.Drawings.healthLabel = healthLabel
    end
    
    if Config.ESP.DistanceESP then
        local distanceLabel = Drawing.new("Text")
        distanceLabel.Color = Color3.fromRGB(255, 255, 255)
        distanceLabel.Size = 12
        playerESP.Drawings.distanceLabel = distanceLabel
    end
    
    if Config.ESP.BoxESP then
        local boxLine = Drawing.new("Line")
        boxLine.Color = Config.ESP.BoxColor
        boxLine.Thickness = 2
        playerESP.Drawings.boxLine = boxLine
    end
end

function ESP.UpdatePlayerESP(player)
    if not ESP.Players[player.Name] then return end
    if not player.Character or not Utils.IsPlayerAlive(player) then return end
    
    local playerESP = ESP.Players[player.Name]
    local camera = Utils.Services.Camera
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local head = player.Character:FindFirstChild("Head")
    
    if not humanoidRootPart or not head then return end
    
    local screenPos = camera:WorldToViewportPoint(head.Position)
    local screenVector = Vector2.new(screenPos.X, screenPos.Y)
    
    if playerESP.Drawings.nameLabel then
        playerESP.Drawings.nameLabel.Position = screenVector
        playerESP.Drawings.nameLabel.Visible = true
    end
    
    if playerESP.Drawings.healthLabel then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            playerESP.Drawings.healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
            playerESP.Drawings.healthLabel.Position = screenVector + Vector2.new(0, 20)
            playerESP.Drawings.healthLabel.Visible = true
        end
    end
    
    if playerESP.Drawings.distanceLabel then
        local distance = Utils.GetDistance(Utils.LocalPlayer.Character.HumanoidRootPart.Position, humanoidRootPart.Position)
        playerESP.Drawings.distanceLabel.Text = math.floor(distance) .. " studs"
        playerESP.Drawings.distanceLabel.Position = screenVector + Vector2.new(0, 40)
        playerESP.Drawings.distanceLabel.Visible = true
    end
    
    if playerESP.Drawings.boxLine then
        local footPos = camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
        playerESP.Drawings.boxLine.From = screenVector
        playerESP.Drawings.boxLine.To = Vector2.new(footPos.X, footPos.Y)
        playerESP.Drawings.boxLine.Visible = true
    end
end

function ESP.RemovePlayerESP(player)
    if not ESP.Players[player.Name] then return end
    
    local playerESP = ESP.Players[player.Name]
    for _, drawing in pairs(playerESP.Drawings) do
        pcall(function() drawing:Remove() end)
    end
    
    ESP.Players[player.Name] = nil
end

function ESP.Start()
    for _, player in pairs(Utils.Services.Players:GetPlayers()) do
        if player ~= Utils.LocalPlayer then
            ESP.CreatePlayerESP(player)
        end
    end
    
    Utils.Services.Players.PlayerAdded:Connect(function(player)
        if player ~= Utils.LocalPlayer then
            ESP.CreatePlayerESP(player)
        end
    end)
    
    Utils.Services.Players.PlayerRemoving:Connect(function(player)
        ESP.RemovePlayerESP(player)
    end)
    
    Utils.Services.RunService.RenderStepped:Connect(function()
        if not ESP.Enabled then return end
        
        for _, player in pairs(Utils.Services.Players:GetPlayers()) do
            if player ~= Utils.LocalPlayer then
                ESP.UpdatePlayerESP(player)
            end
        end
    end)
end

ESP.Start()

return ESP
