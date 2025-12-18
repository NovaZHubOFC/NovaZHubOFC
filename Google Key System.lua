-- ===============================
-- SERVICES
-- ===============================
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ===============================
-- BANCO DE KEYS
-- ===============================
local Keys = {
	"a331877902622410",
	"4e0361f97e1e8ed1",
	"0bdec2b12a4c3353",
	"476807f61e10e8f9",
	"86162e3a5d5d6214",
	"865f73a2e089c8f1",
	"27b10d983b300b42"
}

-- ===============================
-- GUI ROOT
-- ===============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpinKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- ===============================
-- TELA 1: SPIN YOUR KEY
-- ===============================
local SpinFrame = Instance.new("Frame", ScreenGui)
SpinFrame.Size = UDim2.fromScale(0.4, 0.3)
SpinFrame.Position = UDim2.fromScale(0.5, 0.5)
SpinFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SpinFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
SpinFrame.BorderSizePixel = 0
Instance.new("UICorner", SpinFrame).CornerRadius = UDim.new(0, 16)

local SpinTitle = Instance.new("TextLabel", SpinFrame)
SpinTitle.Size = UDim2.fromScale(1, 0.45)
SpinTitle.BackgroundTransparency = 1
SpinTitle.Text = "Spin your Key"
SpinTitle.Font = Enum.Font.GothamBold
SpinTitle.TextSize = 30
SpinTitle.TextColor3 = Color3.fromRGB(0,0,0)

local SpinButton = Instance.new("TextButton", SpinFrame)
SpinButton.Size = UDim2.fromScale(0.4, 0.25)
SpinButton.Position = UDim2.fromScale(0.3, 0.6)
SpinButton.Text = "SPIN"
SpinButton.Font = Enum.Font.GothamBold
SpinButton.TextSize = 18
SpinButton.BackgroundColor3 = Color3.fromRGB(26,115,232)
SpinButton.TextColor3 = Color3.fromRGB(255,255,255)
SpinButton.BorderSizePixel = 0
Instance.new("UICorner", SpinButton).CornerRadius = UDim.new(0, 12)

-- ===============================
-- TELA 2: GOOGLE SIGN IN
-- ===============================
local function OpenGoogleUI(autoKey)
	SpinFrame:Destroy()

	local Card = Instance.new("Frame", ScreenGui)
	Card.Size = UDim2.fromScale(0.75, 0.35)
	Card.Position = UDim2.fromScale(0.5, 0.5)
	Card.AnchorPoint = Vector2.new(0.5, 0.5)
	Card.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Card.BorderSizePixel = 0
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

	local Logo = Instance.new("TextLabel", Card)
	Logo.Position = UDim2.fromScale(0.05, 0.15)
	Logo.Size = UDim2.fromScale(0.05, 0.15)
	Logo.BackgroundTransparency = 1
	Logo.Text = "G"
	Logo.Font = Enum.Font.GothamBold
	Logo.TextSize = 28
	Logo.TextColor3 = Color3.fromRGB(66,133,244)

	local Title = Instance.new("TextLabel", Card)
	Title.Position = UDim2.fromScale(0.05, 0.32)
	Title.Size = UDim2.fromScale(0.35, 0.18)
	Title.BackgroundTransparency = 1
	Title.Text = "Sign in"
	Title.Font = Enum.Font.GothamMedium
	Title.TextSize = 32
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = Color3.fromRGB(0,0,0)

	local Subtitle = Instance.new("TextLabel", Card)
	Subtitle.Position = UDim2.fromScale(0.05, 0.5)
	Subtitle.Size = UDim2.fromScale(0.35, 0.12)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = "Use your Key"
	Subtitle.Font = Enum.Font.Gotham
	Subtitle.TextSize = 14
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left
	Subtitle.TextColor3 = Color3.fromRGB(95,99,104)

	local Input = Instance.new("TextBox", Card)
	Input.Position = UDim2.fromScale(0.45, 0.35)
	Input.Size = UDim2.fromScale(0.45, 0.18)
	Input.Text = autoKey
	Input.Font = Enum.Font.Gotham
	Input.TextSize = 14
	Input.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Input.BorderColor3 = Color3.fromRGB(218,220,224)

	local Next = Instance.new("TextButton", Card)
	Next.Position = UDim2.fromScale(0.78, 0.72)
	Next.Size = UDim2.fromScale(0.12, 0.15)
	Next.Text = "Next"
	Next.Font = Enum.Font.GothamMedium
	Next.TextSize = 14
	Next.BackgroundColor3 = Color3.fromRGB(26,115,232)
	Next.TextColor3 = Color3.fromRGB(255,255,255)
	Next.BorderSizePixel = 0
	Instance.new("UICorner", Next).CornerRadius = UDim.new(0, 18)

	Next.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
		warn("ACCESS GRANTED WITH KEY:", Input.Text)
		-- loadstring(game:HttpGet("your script "))()
	end)
end

-- ===============================
-- SPIN LOGIC
-- ===============================
SpinButton.MouseButton1Click:Connect(function()
	SpinButton.Active = false
	SpinButton.Text = "Spinning..."

	for i = 1, 18 do
		SpinTitle.Text = Keys[math.random(#Keys)]
		task.wait(0.07)
	end

	local finalKey = Keys[math.random(#Keys)]
	SpinTitle.Text = finalKey

	task.wait(0.6)
	OpenGoogleUI(finalKey)
end)
