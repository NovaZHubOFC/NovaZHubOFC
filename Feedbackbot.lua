-- Feedback System com Estrelas | NovaZ Style

local WEBHOOK_URL = "https://discord.com/api/webhooks/1460039380189319274/Hws0rjy62HCCCE7AwqgB6MPty2IUPNlrgPu9voXdlMi59cmDrhu3oD-O-d3D4iL5lS1X"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FeedbackGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.3)
frame.Position = UDim2.fromScale(0.325, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.18)
title.BackgroundTransparency = 1
title.Text = "Envie seu Feedback"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.9, 0.4)
box.Position = UDim2.fromScale(0.05, 0.22)
box.PlaceholderText = "Type your feedback here...."
box.Text = ""
box.ClearTextOnFocus = false
box.TextWrapped = true
box.TextYAlignment = Enum.TextYAlignment.Top
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.Font = Enum.Font.Gotham
box.TextSize = 14

local boxCorner = Instance.new("UICorner", box)
boxCorner.CornerRadius = UDim.new(0, 8)

-- Estrelas
local rating = 0
local stars = {}

for i = 1, 5 do
    local star = Instance.new("TextButton", frame)
    star.Size = UDim2.fromScale(0.1, 0.15)
    star.Position = UDim2.fromScale(0.05 + (i-1)*0.11, 0.65)
    star.Text = "☆"
    star.BackgroundTransparency = 1
    star.TextColor3 = Color3.fromRGB(255, 215, 0)
    star.Font = Enum.Font.GothamBold
    star.TextScaled = true

    star.MouseButton1Click:Connect(function()
        rating = i
        for x = 1, 5 do
            stars[x].Text = (x <= rating) and "★" or "☆"
        end
    end)

    stars[i] = star
end

local send = Instance.new("TextButton", frame)
send.Size = UDim2.fromScale(0.4, 0.16)
send.Position = UDim2.fromScale(0.3, 0.82)
send.Text = "send"
send.BackgroundColor3 = Color3.fromRGB(60,120,255)
send.TextColor3 = Color3.fromRGB(255,255,255)
send.Font = Enum.Font.GothamBold
send.TextScaled = true

local sendCorner = Instance.new("UICorner", send)
sendCorner.CornerRadius = UDim.new(0, 10)

local function sendToDiscord(text)
    local starsText = rating > 0 and string.rep("★", rating) or "Sem avaliação"

    local data = {
        username = "Feedback Bot",
        embeds = {{
            title = "Novo Feedback",
            description = text,
            color = 5793266,
            fields = {
                {name = "Player", value = player.Name, inline = true},
                {name = "UserId", value = tostring(player.UserId), inline = true},
                {name = "Avaliação", value = starsText, inline = false}
            }
        }}
    }

    local json = HttpService:JSONEncode(data)

    pcall(function()
        if syn and syn.request then
            syn.request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = json
            })
        elseif request then
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = json
            })
        end
    end)
end

send.MouseButton1Click:Connect(function()
    if box.Text ~= "" then
        sendToDiscord(box.Text)
        box.Text = ""
        rating = 0
        for i = 1, 5 do
            stars[i].Text = "☆"
        end
        send.Text = "Enviado!"
        task.wait(1)
        send.Text = "Enviar"
    end
end)
