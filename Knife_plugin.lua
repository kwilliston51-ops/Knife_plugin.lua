-- ODH Plugin: Knife & Glossy RTX
-- Use Path: /kwilliston51-ops/Knife_plugin.lua/main/Knife_plugin.lua

local ODH_Lib = _G.ODH_Library
local PluginTab = ODH_Lib:CreateTab("Plugins") -- This adds it to the existing Plugins section

-- 1. Fake Knife (Stabbable, Non-Killable, Visible)
local function SpawnFakeKnife()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    
    local tool = Instance.new("Tool")
    tool.Name = "Fake Knife"
    tool.Parent = player.Backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.2, 0.5, 2)
    handle.Material = Enum.Material.Glass 
    handle.Color = Color3.fromRGB(200, 0, 0) -- Neon Red tint
    handle.Parent = tool

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://121944801"
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = handle

    -- Visible Lunge (Network Ownership ensures others see the movement)
    tool.Activated:Connect(function()
        for i = 1, 6 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.3)
            task.wait(0.01)
        end
        for i = 1, 6 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, 0.3)
            task.wait(0.01)
        end
    end)
end

-- 2. Glossy RTX Shader (Sunset Red)
local function ToggleRTX(state)
    local light = game:GetService("Lighting")
    if state then
        light.ClockTime = 17.5
        light.Brightness = 3.5
        
        local bloom = Instance.new("BloomEffect", light)
        bloom.Name = "ODH_RTX_Bloom"
        bloom.Intensity = 2.5
        bloom.Size = 30
        
        local cc = Instance.new("ColorCorrectionEffect", light)
        cc.Name = "ODH_RTX_Color"
        cc.TintColor = Color3.fromRGB(255, 210, 210)
        cc.Saturation = 0.6
    else
        if light:FindFirstChild("ODH_RTX_Bloom") then light.ODH_RTX_Bloom:Destroy() end
        if light:FindFirstChild("ODH_RTX_Color") then light.ODH_RTX_Color:Destroy() end
    end
end

-- 3. Creating the UI Buttons in the ODH Tab
PluginTab:CreateSection("Utilities")

PluginTab:CreateButton({
    Name = "Spawn Fake Knife",
    Callback = function()
        SpawnFakeKnife()
        ODH_Lib:Notify({Title = "Success", Content = "Knife added to backpack!"})
    end
})

PluginTab:CreateToggle({
    Name = "Glossy Red RTX",
    CurrentValue = false,
    Callback = function(Value)
        ToggleRTX(Value)
    end
})
