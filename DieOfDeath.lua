-- Die of Death | Orion UI
-- ESP Highlight + HealthBar + Infinite Stamina
-- All Executors

-- =========================
-- ORION LIB
-- =========================
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua"
))()

local Window = OrionLib:MakeWindow({
    Name = "Die of Death | NovaZ",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DieOfDeathOrion"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OrionLib:MakeNotification({
    Name = "Loaded",
    Content = "Die of Death script carregado com sucesso",
    Time = 5
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- ESP + HEALTHBAR
-- =========================
local ESP_ENABLED = false
local Highlights = {}
local HealthBars = {}

local function IsKiller(player)
    if player.Character and player.Character:FindFirstChild("Killer") then
        return true
    end
    if player.Team and tostring(player.Team) == "Killers" then
        return true
    end
    return false
end

local function CreateHealthBar(player)
    if HealthBars[player] then return end
    if not player.Character then return end

    local head = player.Character:FindFirstChild("Head")
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.fromScale(4, 0.45)
    gui.StudsOffset = Vector3.new(0, 2.6, 0)
    gui.AlwaysOnTop = true
    gui.Adornee = head

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromScale(1, 1)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.BorderSizePixel = 0
    bar.Parent = bg

    gui.Parent = head
    HealthBars[player] = {Gui = gui, Bar = bar, Humanoid = hum}
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    if Highlights[player] then return end

    local hl = Instance.new("Highlight")
    hl.Adornee = player.Character
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.OutlineColor = IsKiller(player)
        and Color3.fromRGB(255,0,0)
        or Color3.fromRGB(0,255,0)

    hl.Parent = player.Character
    Highlights[player] = hl

    CreateHealthBar(player)
end

local function RemoveESP(player)
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end
    if HealthBars[player] then
        HealthBars[player].Gui:Destroy()
        HealthBars[player] = nil
    end
end

local function UpdateESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if ESP_ENABLED then
            CreateESP(plr)
        else
            RemoveESP(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if ESP_ENABLED then
            CreateESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP)

-- Loop de atualização
task.spawn(function()
    while true do
        if ESP_ENABLED then
            for plr,data in pairs(HealthBars) do
                local hum = data.Humanoid
                if hum and hum.Health > 0 then
                    local p = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    data.Bar.Size = UDim2.fromScale(p, 1)

                    if p > 0.5 then
                        data.Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    elseif p > 0.25 then
                        data.Bar.BackgroundColor3 = Color3.fromRGB(255,255,0)
                    else
                        data.Bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
                    end
                end
            end

            for plr,hl in pairs(Highlights) do
                if plr.Character then
                    hl.OutlineColor = IsKiller(plr)
                        and Color3.fromRGB(255,0,0)
                        or Color3.fromRGB(0,255,0)
                end
            end
        end
        task.wait(0.05)
    end
end)

-- Toggle ESP (VISUAL TAB)
VisualTab:AddToggle({
    Name = "ESP + HealthBar",
    Default = false,
    Callback = function(v)
        ESP_ENABLED = v
        UpdateESP()
    end
})

-- =========================
-- INFINITE STAMINA
-- =========================
local InfStamina = false
local staminaM

pcall(function()
    staminaM = require(
        LocalPlayer.PlayerGui.MainGui.Client.Modules.Movement
    )
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if InfStamina and staminaM then
            staminaM.Stamina = staminaM.MaxStamina
        end
    end
end)

MainTab:AddToggle({
    Name = "Infinite Stamina",
    Default = false,
    Callback = function(v)
        InfStamina = v
    end
})

OrionLib:Init()

-- =========================
-- BOTÃO FLUTUANTE (TOGGLE UI)
-- =========================
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "ToggleUI"
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0,50,0,50)
Toggle.Position = UDim2.new(0,0,0.45,0)
Toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
Toggle.BackgroundTransparency = 0.5
Toggle.Text = ""
Toggle.Draggable = true

local Corner = Instance.new("UICorner", Toggle)
Corner.CornerRadius = UDim.new(0.2,0)

local Icon = Instance.new("ImageLabel", Toggle)
Icon.Size = UDim2.new(1,0,1,0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://110114875701700"

local Corner2 = Instance.new("UICorner", Icon)
Corner2.CornerRadius = UDim.new(0.2,0)

Toggle.MouseButton1Click:Connect(function()
    OrionLib:ToggleUi()
end)
