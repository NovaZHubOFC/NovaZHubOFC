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
local HitboxColor = BrickColor.new("Really red")
local HitboxTransparency = 0.6

local SelectedTeams = {} -- Teams marcados
local OriginalSizes = {} -- Usando HRP como chave (sem memory leak)

--// Função segura para checar Team selecionado
local function IsEnemy(player)
    if not player.Team then
        return false
    end

    return SelectedTeams[player.Team.Name] == true
end

--// Expandir Hitbox
local function ExpandHitbox(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not OriginalSizes[hrp] then
        OriginalSizes[hrp] = hrp.Size
    end

    hrp.Size = HitboxSize
    hrp.Transparency = HitboxTransparency
    hrp.BrickColor = HitboxColor
    hrp.Material = Enum.Material.Neon
    hrp.CanCollide = false
end

--// Resetar Hitbox
local function ResetHitbox(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if OriginalSizes[hrp] then
        hrp.Size = OriginalSizes[hrp]
    else
        hrp.Size = Vector3.new(2,2,1)
    end

    hrp.Transparency = 1
    hrp.CanCollide = false
    OriginalSizes[hrp] = nil
end

--// Aplicar Hitbox nos inimigos corretos
local function ApplyHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and player.Character then
            ExpandHitbox(player.Character)
        end
    end
end

--// Resetar Hitboxes quando Team muda
local function ResetAllNonSelectedTeams()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not IsEnemy(player) then
                ResetHitbox(player.Character)
            end
        end
    end
end

--// Eventos Player/Character
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if HitboxEnabled then
            char:WaitForChild("HumanoidRootPart", 5)
            if IsEnemy(player) then
                ExpandHitbox(char)
            end
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(char)
        if HitboxEnabled then
            char:WaitForChild("HumanoidRootPart", 5)
            if IsEnemy(player) then
                ExpandHitbox(char)
            end
        end
    end)
end

--// Loop otimizado
RunService.Heartbeat:Connect(function()
    if not HitboxEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsEnemy(player) and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Size ~= HitboxSize then
                ExpandHitbox(player.Character)
            end
        end
    end
end)

--// UI
local Window = Rayfield:CreateWindow({
    Name = "NovaZHub | UPDATE ",
    LoadingTitle = "NovaZHub",
    LoadingSubtitle = "by Carlos",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main", 4483362458)

--// DROPDOWN DE TEAMS (MULTI-SELEÇÃO)
local function GetTeamList()
    local list = {}
    for _, team in pairs(TeamsService:GetTeams()) do
        table.insert(list, team.Name)
    end
    return list
end

local TeamDropdown = MainTab:CreateDropdown({
    Name = "Selecionar Teams",
    Options = GetTeamList(),
    MultipleOptions = true,
    CurrentOption = {},
    Flag = "TeamDropdown",
    Callback = function(options)
        SelectedTeams = {}
        
        -- Normalizar formato independente da versão do Rayfield
        for _, teamName in pairs(options) do
            SelectedTeams[teamName] = true
        end

        if HitboxEnabled then
            ResetAllNonSelectedTeams()
            ApplyHitboxes()
        end
    end,
})

-- Atualiza dropdown quando novos times aparecem
TeamsService.ChildAdded:Connect(function()
    TeamDropdown:Refresh(GetTeamList(), true)
end)

--// Toggle Hitbox
MainTab:CreateToggle({
    Name = "Enable Hitbox Expander",
    CurrentValue = false,
    Flag = "HitboxToggle",
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

--// Slider para tamanho
MainTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 90},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 15,
    Flag = "HitboxSizeSlider",
    Callback = function(Value)
        HitboxSize = Vector3.new(Value, Value, Value)
    end,
})

--// Cor
MainTab:CreateDropdown({
    Name = "Hitbox Color",
    Options = {"Really red","Lime green","Bright blue","New Yeller","Hot pink","White"},
    CurrentOption = "Really red",
    Flag = "HitboxColorDropdown",
    Callback = function(Option)
        HitboxColor = BrickColor.new(Option)
    end,
})
