-- GUI que copia o link do Discord e desaparece depois

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DiscordInviteGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Join the official NovaZHub server. "
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -40, 0, 40)
button.Position = UDim2.new(0, 20, 0, 80)
button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
button.Text = "Copiar Link"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.Parent = frame

local bcorner = Instance.new("UICorner", button)
bcorner.CornerRadius = UDim.new(0, 8)

local link = "https://discord.gg/s9kRXQ5x"

button.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(link)
	end
	gui:Destroy() -- some após copiar
end)
