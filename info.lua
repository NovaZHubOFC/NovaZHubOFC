--// GUI de Informações - NovaZHub Style

local CoreGui = game:GetService("CoreGui")

-- Remove se já existir
if CoreGui:FindFirstChild("NovaZInfoGui") then
    CoreGui.NovaZInfoGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "NovaZInfoGui"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Janela principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 330, 0, 200)
frame.Position = UDim2.new(0.5, -165, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Updates6️⃣7️⃣"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Botão X
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -35, 0, 0)
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Text = "X"
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255, 90, 90)
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Texto das informações
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 1, -50)
info.Position = UDim2.new(0, 10, 0, 40)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.Text = [[
• Added Hitbox Extender with adjustable slider (10 to 35).
• Added Blue Outline ESP (Outline only, no fill).
• Hitbox optimized to update in real time.
• ESP optimized for performance and compatibility.
• General stability improvements.
]]
info.TextWrapped = true
info.TextSize = 15
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = frame
