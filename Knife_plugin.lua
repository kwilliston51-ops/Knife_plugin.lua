-- ODH Plugin: Advanced Visuals
-- Save as .lua and upload to your GitHub for the raw link

local Plugin = {}

-- 1. Visible Fake Knife (FE Physical Stab)
function Plugin.SpawnFakeKnife()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local knife = Instance.new("Tool")
    knife.Name = "Fake Knife"
    knife.RequiresHandle = true
    knife.Parent = player.Backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.2, 0.5, 2)
    handle.Color = Color3.fromRGB(80, 80, 80)
    handle.Material = Enum.Material.Glass -- Extra glossy look
    handle.Parent = knife

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://121944801" 
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = handle

    -- Visible Stab Logic (Manual CFrame lerping so others see the movement)
    knife.Activated:Connect(function()
        local arm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightHand")
        if not arm then return end
        
        -- Simple physical lunge (Visible to others because you own the Tool)
        for i = 0, 1, 0.2 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.5) 
            task.wait(0.01)
        end
        for i = 0, 1, 0.2 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, 0.5)
            task.wait(0.01)
        end
    end)
end

-- 2. Glossy Red Sunset Shader
function Plugin.ApplyRedGloss(state)
    local lighting = game:GetService("Lighting")
    
    if state then
        -- Sunset Atmosphere
        lighting.ClockTime = 17.8
        lighting.Brightness = 4
        lighting.ExposureCompensation = 1.5
        
        -- Red Gloss Effects
        local bloom = Instance.new("BloomEffect", lighting)
        bloom.Name = "RedGloss_Bloom"
        bloom.Intensity = 2
        bloom.Size = 30
        bloom.Threshold = 0.5
        
        local colorCorrection = Instance.new("ColorCorrectionEffect", lighting)
        colorCorrection.Name = "RedGloss_Color"
        colorCorrection.TintColor = Color3.fromRGB(255, 200, 200)
        colorCorrection.Saturation = 0.5
        
        -- Force UI Blur for the "Glassy" feel
        local blur = Instance.new("BlurEffect", lighting)
        blur.Name = "RedGloss_Blur"
        blur.Size = 10
    else
        -- Clean up
        if lighting:FindFirstChild("RedGloss_Bloom") then lighting.RedGloss_Bloom:Destroy() end
        if lighting:FindFirstChild("RedGloss_Color") then lighting.RedGloss_Color:Destroy() end
        if lighting:FindFirstChild("RedGloss_Blur") then lighting.RedGloss_Blur:Destroy() end
        lighting.ClockTime = 14
    end
end

-- 3. ODH Integration
-- Using the standard ODH tab creation logic
local CustomTab = _G.ODH_Library:CreateTab("Visuals")

CustomTab:CreateButton({
    Name = "Spawn Visible Knife",
    Callback = function()
        Plugin.SpawnFakeKnife()
    end
})

CustomTab:CreateToggle({
    Name = "Glossy Red Sunset",
    CurrentValue = false,
    Callback = function(Value)
        Plugin.ApplyRedGloss(Value)
    end
})

return Plugin
