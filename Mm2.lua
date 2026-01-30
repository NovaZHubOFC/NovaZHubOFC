-- MM2 ESP LOOP (PC)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local highlights = {}

local function getRole(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local function getColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 150, 255)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end

local function addESP(player)
    if player == LocalPlayer then return end
    if highlights[player] then return end

    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = game.CoreGui

    highlights[player] = hl
end

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addESP(player)

            local hl = highlights[player]
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                hl.Adornee = player.Character
                local role = getRole(player)
                hl.FillColor = getColor(role)
                hl.OutlineColor = getColor(role)
            end
        end
    end
end)
