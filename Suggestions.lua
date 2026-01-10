-- CONFIG
local WEBHOOK = "https://discord.com/api/webhooks/1459660023939731758/wtzhkA8xnL_Q2WLYiu5zBi0gqi1IOOc6HzysUJwM36kYK7cOe-jqpiRZ0xR-wz2mBO0T"

-- SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SuggestionGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.22)
frame.Position = UDim2.fromScale(0.325, 0.39)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.25)
title.BackgroundTransparency = 1
title.Text = "Sugestão"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local close = Instance.new("TextButton", frame)
close.Size = UDim2.fromScale(0.12, 0.25)
close.Position = UDim2.fromScale(0.88, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Font = Enum.Font.GothamBold
close.TextScaled = true

local closeCorner = Instance.new("UICorner", close)
closeCorner.CornerRadius = UDim.new(0, 8)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.9, 0.35)
box.Position = UDim2.fromScale(0.05, 0.3)
box.PlaceholderText = "Digite sua sugestão..."
box.Text = ""
box.TextWrapped = true
box.ClearTextOnFocus = false
box.Font = Enum.Font.Gotham
box.TextColor3 = Color3.fromRGB(255,255,255)
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextScaled = true

local boxCorner = Instance.new("UICorner", box)
boxCorner.CornerRadius = UDim.new(0, 8)

local send = Instance.new("TextButton", frame)
send.Size = UDim2.fromScale(0.9, 0.22)
send.Position = UDim2.fromScale(0.05, 0.7)
send.Text = "Enviar"
send.Font = Enum.Font.GothamBold
send.TextScaled = true
send.TextColor3 = Color3.fromRGB(255,255,255)
send.BackgroundColor3 = Color3.fromRGB(70,130,255)

local sendCorner = Instance.new("UICorner", send)
sendCorner.CornerRadius = UDim.new(0, 8)

-- FUNÇÕES
local function sendToDiscord(text)
	if text == "" then return end

	local data = {
		username = "Suggestion Bot",
		embeds = {{
			title = "NovaZHub suggestions bot",
			description = text,
			color = 5814783,
			fields = {
				{name = "Player", value = player.Name, inline = true},
				{name = "UserId", value = tostring(player.UserId), inline = true}
			}
		}}
	}

	local json = HttpService:JSONEncode(data)
	pcall(function()
		HttpService:PostAsync(WEBHOOK, json, Enum.HttpContentType.ApplicationJson)
	end)
end

-- EVENTOS
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

send.MouseButton1Click:Connect(function()
	sendToDiscord(box.Text)
	box.Text = ""
	send.Text = "Enviado!"
	task.wait(1)
	send.Text = "Enviar"
end)
