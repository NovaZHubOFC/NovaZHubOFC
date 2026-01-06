-- =========================
-- SERVIÇOS
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================
local ESP_ATIVO = true
local UnitsFolder = Workspace
local ESPs = {}

-- =========================
-- FUNÇÃO ESP
-- =========================
local function criarESP(model)
	if ESPs[model] then return end
	if not model:IsA("Model") then return end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end

	-- =========================
	-- HIGHLIGHT
	-- =========================
	local hl = Instance.new("Highlight")
	hl.Parent = model
	hl.FillTransparency = 0.85
	hl.OutlineTransparency = 0
	hl.OutlineColor = Color3.fromRGB(0,255,255)

	TweenService:Create(
		hl,
		TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{OutlineTransparency = 0.6}
	):Play()

	-- =========================
	-- BILLBOARD
	-- =========================
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(6,0,2.2,0)
	gui.StudsOffset = Vector3.new(0,5,0)
	gui.AlwaysOnTop = true
	gui.Parent = root

	local container = Instance.new("Frame", gui)
	container.Size = UDim2.new(1,0,1,0)
	container.BackgroundTransparency = 1

	-- INFO TEXTO
	local info = Instance.new("TextLabel", container)
	info.Size = UDim2.new(1,0,0.35,0)
	info.BackgroundTransparency = 1
	info.Font = Enum.Font.GothamBlack
	info.TextScaled = true
	info.TextColor3 = Color3.fromRGB(0,200,255)
	info.TextStrokeTransparency = 0

	-- VIDA TEXTO
	local hpText = Instance.new("TextLabel", container)
	hpText.Size = UDim2.new(1,0,0.25,0)
	hpText.Position = UDim2.new(0,0,0.35,0)
	hpText.BackgroundTransparency = 1
	hpText.Font = Enum.Font.GothamBold
	hpText.TextScaled = true
	hpText.TextColor3 = Color3.new(1,1,1)
	hpText.TextStrokeTransparency = 0

	-- FUNDO BARRA
	local bg = Instance.new("Frame", container)
	bg.Size = UDim2.new(1,0,0.18,0)
	bg.Position = UDim2.new(0,0,0.7,0)
	bg.BackgroundColor3 = Color3.fromRGB(10,10,10)
	bg.BorderSizePixel = 0
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

	-- BARRA
	local bar = Instance.new("Frame", bg)
	bar.Size = UDim2.new(1,0,1,0)
	bar.BorderSizePixel = 0
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

	-- GRADIENT
	local grad = Instance.new("UIGradient", bar)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
	}

	TweenService:Create(
		grad,
		TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
		{Rotation = 360}
	):Play()

	-- =========================
	-- UPDATE
	-- =========================
	RunService.RenderStepped:Connect(function()
		if not ESP_ATIVO then
			gui.Enabled = false
			hl.Enabled = false
			return
		end

		gui.Enabled = true
		hl.Enabled = true

		if humanoid.Health <= 0 then
			gui:Destroy()
			hl:Destroy()
			ESPs[model] = nil
			return
		end

		local char = LocalPlayer.Character
		local distance = char and char:FindFirstChild("HumanoidRootPart")
			and math.floor((char.HumanoidRootPart.Position - root.Position).Magnitude)
			or 0

		local hp = math.floor(humanoid.Health)
		local max = math.floor(humanoid.MaxHealth)
		local percent = math.clamp(hp / max, 0, 1)

		local status = percent < 0.25 and "LOW HP" or "ALIVE"

		info.Text = model.Name.." | "..distance.."m | "..status
		hpText.Text = hp.." / "..max
		bar.Size = UDim2.new(percent,0,1,0)

		if percent > 0.6 then
			bar.BackgroundColor3 = Color3.fromRGB(0,255,120)
		elseif percent > 0.3 then
			bar.BackgroundColor3 = Color3.fromRGB(255,170,0)
		else
			bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
		end
	end)

	ESPs[model] = true
end

-- =========================
-- SCAN
-- =========================
task.spawn(function()
	while true do
		if ESP_ATIVO then
			for _,obj in pairs(UnitsFolder:GetDescendants()) do
				criarESP(obj)
			end
		end
		task.wait(1)
	end
end)

-- =========================
-- TOGGLE
-- =========================
_G.UnitESP = function(v)
	ESP_ATIVO = v
end
