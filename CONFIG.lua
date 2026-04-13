-- Core Configuration for MainV3 Mobile Delta
-- TOUCH-BASED CONTROLS ONLY - NO KEYBOARD

local Config = {
    -- Aimbot Settings
    Aimbot = {
        Enabled = true,
        FOV = 120,
        Smoothness = 0.05,
        LockPart = "Head",
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        TriggerMode = "Hold", -- "Hold" or "Toggle"
        TouchTriggerArea = "TopRight", -- TopRight, TopLeft, BottomRight, BottomLeft, Center
    },
    
    -- ESP Settings
    ESP = {
        Enabled = true,
        BoxESP = true,
        NameESP = true,
        HealthESP = true,
        DistanceESP = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
    },
    
    -- Visual Settings
    Visuals = {
        Crosshair = true,
        CrosshairSize = 12,
        CrosshairThickness = 1,
        CrosshairColor = Color3.fromRGB(0, 255, 0),
        FPS = 60,
        FieldOfView = 70,
    },
    
    -- Protection Settings
    Protection = {
        AntiCheatDetection = true,
        AntiHookDetection = true,
        SpeedHackDetection = true,
        AntiWallhackDetection = true,
        RandomDelays = true,
        MinDelay = 0.05,
        MaxDelay = 0.15,
        StealthMode = true,
    },
    
    -- Mobile Optimization
    Mobile = {
        EnableMobileOptimization = true,
        MaxFPS = 60,
        LowGraphicsMode = true,
        DisableAnimations = true,
        CompressedNetworking = true,
        TouchSensitivity = 1.5, -- Multiplier for touch speed
    },
}

return Config
