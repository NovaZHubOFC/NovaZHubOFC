--// Carregar Rayfield (Sirius)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeamsService = game:GetService("Teams")
local LocalPlayer = Players.LocalPlayer

--// Variáveis
local HitboxEnabled = false
local HitboxSize = Vector3.new(15, 15, 15)
local HitboxTransparency = 0.6

local HitboxColor = Color3.fromRGB(255, 0, 0)
local ColorMap = {
    ["Really red"] = Color3.fromRGB(255, 0, 0),
    ["Lime green"] = Color3.fromRGB(0, 255, 0),
    ["Bright blue"] = Color3.fromRGB(0, 140, 255),
    ["New Yeller"] = Color3.fromRGB(255, 255, 0),
    ["Hot pink"] = Color3.fromRGB(255, 0, 180),
    ["White"] = Color3.fromRGB(255, 255, 255),
}

local SelectedTeams = {}
local OriginalSizes = {}
local UseOtherTeamsOnly = false

--// Verifica se deve aplicar o Hitbox
local function IsEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if UseOtherTeamsOnly then
        if not LocalPlayer.Team or not player.Team then
            return false
        end
        return player.Team ~= LocalPlayer.Team
    end

    if not player.Team then
        return false
    end

    return SelectedTeams[player.Team.Name] == true
end

--// Expandir Hitbox
local function ExpandHitbox(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    if not OriginalSizes[hrp] then
        OriginalSizes[hrp] = hrp.Size
    end

    hrp.Size = HitboxSize
    hrp.Transparency = HitboxTransparency
    hrp.Color = HitboxColor
    hrp.Material = Enum.Material.Neon
    hrp.CanCollide = false
end

--// Resetar Hitbox
local function ResetHitbox(char)
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    if OriginalSizes[hrp] then
        hrp.Size = OriginalSizes[hrp]
    else
        hrp.Size = Vector3.new(2,2,1)
    end

    hrp.Transparency = 1
    hrp.Material = Enum.Material.Plastic
    hrp.CanCollide = false

    OriginalSizes[hrp] = nil
end

--// Aplicar Hitboxes
local function ApplyHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and player.Character then
            ExpandHitbox(player.Character)
        end
    end
end

--// Resetar quem não deve mais ter hitbox
local function ResetAllNonSelected()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not IsEnemy(player) then
                ResetHitbox(player.Character)
            end
        end
    end
end

--// Monitorar respawn
local function MonitorCharacter(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 6)
        if HitboxEnabled and IsEnemy(player) then
            ExpandHitbox(char)
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    MonitorCharacter(player)
end
Players.PlayerAdded:Connect(MonitorCharacter)

--// Loop anti-bug (veículos / HRP novo)
RunService.Heartbeat:Connect(function()
    if not HitboxEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChildWhichIsA("BasePart")

            if hrp then
                if not OriginalSizes[hrp] then
                    OriginalSizes[hrp] = hrp.Size
                    ExpandHitbox(char)
                end

                if hrp.Size ~= HitboxSize then
                    ExpandHitbox(char)
                end
            end
        end
    end
end)

--// UI
local Window = Rayfield:CreateWindow({
    Name = "NovaZHub | Hitbox Expander",
    LoadingTitle = "NovaZHub",
    LoadingSubtitle = "by Carlos",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main", 4483362458)

--// Dropdown Teams
local function GetTeamList()
    local list = {}
    for _, t in pairs(TeamsService:GetTeams()) do
        table.insert(list, t.Name)
    end
    return list
end

local TeamDropdown = MainTab:CreateDropdown({
    Name = "select team",
    Options = GetTeamList(),
    MultipleOptions = true,
    CurrentOption = {},
    Callback = function(selected)
        if UseOtherTeamsOnly then return end

        SelectedTeams = {}
        for _, teamName in pairs(selected) do
            SelectedTeams[teamName] = true
        end

        if HitboxEnabled then
            ResetAllNonSelected()
            ApplyHitboxes()
        end
    end,
})

TeamsService.ChildAdded:Connect(function()
    TeamDropdown:Refresh(GetTeamList(), true)
end)

--// Modo automático: outros teams
MainTab:CreateToggle({
    Name = "Hitbox only in other teams",
    CurrentValue = false,
    Callback = function(Value)
        UseOtherTeamsOnly = Value

        if Value then
            SelectedTeams = {}
            TeamDropdown:Set({})
        end

        if HitboxEnabled then
            ResetAllNonSelected()
            ApplyHitboxes()
        end
    end,
})

--// Toggle principal
MainTab:CreateToggle({
    Name = "Enable Hitbox Expander",
    CurrentValue = false,
    Callback = function(Value)
        HitboxEnabled = Value
        if Value then
            ApplyHitboxes()
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    ResetHitbox(player.Character)
                end
            end
        end
    end,
})

--// Slider tamanho
MainTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 90},
    Increment = 1,
    CurrentValue = 15,
    Callback = function(Value)
        HitboxSize = Vector3.new(Value, Value, Value)
    end,
})

--// Cor (agora muda na hora)
MainTab:CreateDropdown({
    Name = "Hitbox Color",
    Options = {"Really red", "Lime green", "Bright blue", "New Yeller", "Hot pink", "White"},
    CurrentOption = "Really red",
    Callback = function(Option)
        HitboxColor = ColorMap[Option]

        if HitboxEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsEnemy(player) and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        or player.Character:FindFirstChildWhichIsA("BasePart")

                    if hrp then
                        hrp.Color = HitboxColor
                        hrp.Material = Enum.Material.Neon
                        hrp.Transparency = HitboxTransparency
                    end
                end
            end
        end
    end,
})
local UpdateTab = Window:CreateTab("Updates", 4483362458)

UpdateTab:CreateParagraph({
    Title = "NovaZHub | Hitbox Expander",
    Content = [[
🆕 v1.4 - FeedBackUpdate


Hitbox color system now updates in real time
• Bug fix when disabling Hitbox on players inside vehicles
• Loop optimization (less resource consumption)
Hitbox color system now updates in real time
• Bug fix when disabling Hitbox on players inside vehicles
• Loop optimization (less resource consumption)
• More reliable enemy detection• More reliable enemy detection 
added Feedback system sent via the developer's Discord server.
• Fixed Suggestion system that wasn't sending suggestions through the developer's Discord server.     

🔧 upcoming improvements:
- Library Exchange (Interface)🟨
- Deploying to the Script: NovaZHub Script Box" 🟨
- Buff to increase Hitbox  🟨
- Update begins on January 11, 2026.
- Update date: January 13, 2026.
- Suggestion system via the developer's Discord server. 
-Suggestions update release date: January 10th at 8:03 PM

INFO
        
🟨Updating 
🟩completed
🟥Cancelled or Discarded 
]]
})
