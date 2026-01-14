--// Configurações
local WebhookURL = "https://discord.com/api/webhooks/1460039395297071268/wUHlme2804xwRjJ-BleAFJGtIrrsTPGLvnxFzW6SDBxmw1Z7GKRy24pGPvydREwelgCm"

--// Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--// Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaZHubDiscordPrompt"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Position = UDim2.new(0.5, -160, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -20, 0, 60)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.TextWrapped = true
Title.Text = "Do you want the OFFICIAL NovaZHub Discord server?"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

local Yes = Instance.new("TextButton", Frame)
Yes.Size = UDim2.new(0.45, 0, 0, 36)
Yes.Position = UDim2.new(0.05, 0, 1, -50)
Yes.Text = "Yes"
Yes.Font = Enum.Font.GothamBold
Yes.TextSize = 14
Yes.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Yes)

local Nah = Instance.new("TextButton", Frame)
Nah.Size = UDim2.new(0.45, 0, 0, 36)
Nah.Position = UDim2.new(0.5, 0, 1, -50)
Nah.Text = "Nah"
Nah.Font = Enum.Font.GothamBold
Nah.TextSize = 14
Nah.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
Nah.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Nah)

--// Envio compatível com executores + animação
local function Send(op)
    local data = {
        username = "NovaZHub Feedback",
        embeds = {{
            title = "Discord Server Opinion",
            color = 7506394,
            fields = {
                {name = "Player", value = LocalPlayer.Name, inline = true},
                {name = "UserId", value = tostring(LocalPlayer.UserId), inline = true},
                {name = "Choice", value = op, inline = false}
            }
        }}
    }

    local req = (syn and syn.request)
        or (http and http.request)
        or http_request
        or request

    if req then
        pcall(function()
            req({
                Url = WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end)
    end

    -- Fade out
    local tween = TweenService:Create(
        Frame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )

    for _, v in ipairs(Frame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            TweenService:Create(v, TweenInfo.new(0.25), {
                TextTransparency = 1,
                BackgroundTransparency = 1
            }):Play()
        end
    end

    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end

Yes.MouseButton1Click:Connect(function()
    Send("Yes")
end)

Nah.MouseButton1Click:Connect(function()
    Send("Nah")
end)
