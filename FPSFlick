-- WIND UI BASE
local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
    end
end

-- Pop-up inicial opcional
WindUI:Popup({
    Title = "NovaZHub",
    Icon = "bird",
    Content = "Carregado com sucesso!",
    Buttons = {
        { Title = "OK", Icon = "bird" }
    }
})

-- JANELA
local Window = WindUI:CreateWindow({
    Title = "NovaZHub  |  WindUI",
    Author = "by NovaZHub",
    Folder = "NovaZHub",
    Icon = "sfsymbols:gamecontroller",
    IconSize = 50,
    HideSearchBar = true,

    OpenButton = {
        Title = "Open NovaZHub🤑",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
    }
})

-----------------------------------------------------
-- //////////////////// TAB COMBAT ////////////////////
-----------------------------------------------------

local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "sword"
})

-- HITBOX EXTENDER
CombatTab:Toggle({
    Title = "Hitbox Extender 35x35x35 (Azul)",
    Callback = function(state)
        _G.ExtendHitbox = state
        if state then
            task.spawn(function()
                while _G.ExtendHitbox do
                    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
                        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(35,35,35)
                            hrp.Transparency = 0.7
                            hrp.Color = Color3.fromRGB(0,150,255)
                            hrp.Material = Enum.Material.Neon
                            hrp.CanCollide = false
                        end
                    end
                    task.wait(0.2)
                end
            end)
        else
            for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                    v.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
})

-- WALKSPEED SLIDER
CombatTab:Slider({
    Title = "Walkspeed",
    Step = 1,
    Value = { Min = 16, Max = 70, Default = 16 },
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
})

-- INFINITE JUMP
CombatTab:Toggle({
    Title = "Infinite Jump",
    Callback = function(state)
        _G.InfJump = state
        local UIS = game:GetService("UserInputService")
        UIS.JumpRequest:Connect(function()
            if _G.InfJump then
                local p = game.Players.LocalPlayer
                if p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid:ChangeState("Jumping")
                end
            end
        end)
    end
})

CombatTab:Button({
    Title = "Coming soon...",
    Locked = true
})

-----------------------------------------------------
-- //////////////////// TAB FPS //////////////////////
-----------------------------------------------------

local FPSTab = Window:Tab({
    Title = "FPS",
    Icon = "gauge"
})

-- FPS BOOST
FPSTab:Button({
    Title = "FPS Boost",
    Color = Color3.fromHex("#00ff00"),
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") then v.Transparency = 1 end
            if v:IsA("Texture") then v.Transparency = 1 end
        end
        setfpscap(240)
    end
})

FPSTab:Button({ Title = "Coming soon...", Locked = true })
FPSTab:Button({ Title = "Coming soon...", Locked = true })

-----------------------------------------------------
-- //////////////////// TAB MISC /////////////////////
-----------------------------------------------------

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "boxes"
})

MiscTab:Button({
    Title = "Infinite Yield",
    Color = Color3.fromHex("#305dff"),
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})
