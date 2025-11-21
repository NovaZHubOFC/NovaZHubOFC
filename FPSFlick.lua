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

WindUI:Popup({
    Title = "NovaZHub",
    Icon = "bird",
    Content = "Carregado com sucesso!",
    Buttons = {
        { Title = "OK", Icon = "bird" }
    }
})

local Window = WindUI:CreateWindow({
    Title = "NovaZHub  | FpsFlick",
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

-- HITBOX SLIDER
local HitboxSize = 35

CombatTab:Slider({
    Title = "Hitbox Size",
    Step = 1,
    Value = { Min = 10, Max = 35, Default = 35 },
    Callback = function(v)
        HitboxSize = v
    end
})

-- HITBOX EXTENDER
CombatTab:Toggle({
    Title = "Hitbox Extender Azul",
    Callback = function(state)
        _G.ExtendHitbox = state
        if state then
            task.spawn(function()
                while _G.ExtendHitbox do
                    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
                        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                            hrp.Transparency = 0.7
                            hrp.Material = Enum.Material.Neon
                            hrp.Color = Color3.fromRGB(0,150,255)
                            hrp.CanCollide = false
                        end
                    end
                    task.wait(0.15)
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

-- ESP AZUL CONTORNO
CombatTab:Toggle({
    Title = "ESP Azul (Contorno)",
    Callback = function(state)
        _G.ESPOutline = state

        if state then
            task.spawn(function()
                while _G.ESPOutline do
                    for _, plr in pairs(game.Players:GetPlayers()) do
                        if plr ~= game.Players.LocalPlayer and plr.Character then
                            if not plr.Character:FindFirstChild("NovaZ_Outline") then
                                local h = Instance.new("Highlight")
                                h.Name = "NovaZ_Outline"
                                h.FillTransparency = 1
                                h.OutlineTransparency = 0
                                h.OutlineColor = Color3.fromRGB(0, 150, 255)
                                h.Adornee = plr.Character
                                h.Parent = plr.Character
                            end
                        end
                    end
                    task.wait(0.25)
                end
            end)
        else
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("NovaZ_Outline") then
                    plr.Character.NovaZ_Outline:Destroy()
                end
            end
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

FPSTab:Button({
    Title = "FPS Boost",
    Color = Color3.fromHex("#00ff00"),
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
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

-----------------------------------------------------
-- //////////////////// TAB UPDATE ///////////////////
-----------------------------------------------------

local UpdateTab = Window:Tab({
    Title = "Update",
    Icon = "Update"
})

UpdateTab:Button({
    Title = "shows update ",
    Icon = "doc.text",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHubOFC/NovaZHubOFC/refs/heads/main/info.lua"))()
    end
})
