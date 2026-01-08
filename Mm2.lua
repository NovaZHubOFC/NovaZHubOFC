-- =====================================================
-- NOVAZHUB | WEBHOOK LOGGER + ANTISPAM
-- =====================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local WEBHOOK_URL = "https://discord.com/api/webhooks/1458946443845828940/zk_JNvFFKfELVqGZxGTvIXtJJ_VYF4n_ygoL1NhWZ_YvV4NCl6t5870kQ5XMEIikJuVD"

-- ===== ANTISPAM =====
local spamKey = "NovaZHub_Logged_" .. LocalPlayer.UserId .. "_" .. game.JobId
if getgenv()[spamKey] then return end
getgenv()[spamKey] = true
-- ====================

local executor = "Unknown"
pcall(function()
	executor = identifyexecutor()
end)

pcall(function()
	(request or http_request or syn.request)({
		Url = WEBHOOK_URL,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({
			username = "NovaZHub Logger",
			embeds = {{
				title = "🚀 Script Executado",
				color = 0x00ff88,
				fields = {
					{ name = "👤 Player", value = LocalPlayer.Name, inline = true },
					{ name = "🆔 UserId", value = tostring(LocalPlayer.UserId), inline = true },
					{ name = "✨ Display", value = LocalPlayer.DisplayName, inline = true },
					{ name = "🎮 PlaceId", value = tostring(game.PlaceId), inline = true },
					{ name = "🌍 JobId", value = game.JobId, inline = false },
					{ name = "🛠 Executor", value = executor, inline = true },
					{ name = "⏰ Horário", value = os.date("%d/%m/%Y %H:%M:%S"), inline = false }
				},
				footer = { text = "NovaZHub • AntiSpam Logger" }
			}}
		})
	})
end)

-- =====================================================
-- UI LIB
-- =====================================================

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
	Title = "NovaZHub Beta Script",
	Footer = "Linoria / Obsidian",
	Icon = 95816097006870,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
	Info = Window:AddTab("Info", "info"),
	Combat = Window:AddTab("Combat", "swords"),
	Visual = Window:AddTab("Visual", "eye"),
	Local = Window:AddTab("Local Player", "user"),
	Music = Window:AddTab("Music", "music"),
	UI = Window:AddTab("UI Settings", "settings"),
}

-- =====================================================
-- INFO TAB
-- =====================================================

local InfoBox = Tabs.Info:AddLeftGroupbox("Player Info")
local joinTime = tick()

InfoBox:AddLabel("Name: "..LocalPlayer.Name)
InfoBox:AddLabel("UserId: "..LocalPlayer.UserId)
InfoBox:AddLabel("Account Age: "..LocalPlayer.AccountAge.." days")
InfoBox:AddLabel("Executor: "..executor)
InfoBox:AddLabel("Time In Server: 0s")

task.spawn(function()
	while true do
		task.wait(1)
		InfoBox:SetText(5, "Time In Server: "..math.floor(tick() - joinTime).."s")
	end
end)

InfoBox:AddButton("Server Hop", function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- =====================================================
-- COMBAT (KILL ALL LOOP BRING)
-- =====================================================

local CombatBox = Tabs.Combat:AddLeftGroupbox("Combat")
local loopBring = false

CombatBox:AddToggle("KillAll", {
	Text = "Kill All (Loop Bring)",
	Default = false,
	Callback = function(state)
		loopBring = state
		task.spawn(function()
			while loopBring do
				task.wait(0.3)
				if not LocalPlayer.Character
				or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					continue
				end

				local hrp = LocalPlayer.Character.HumanoidRootPart

				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer
					and plr.Character
					and plr.Character:FindFirstChild("HumanoidRootPart")
					and plr.Character:FindFirstChild("Humanoid")
					and plr.Character.Humanoid.Health > 0 then
						pcall(function()
							plr.Character.HumanoidRootPart.CFrame =
								hrp.CFrame * CFrame.new(0, 0, -2)
						end)
					end
				end
			end
		end)
	end
})

-- =====================================================
-- VISUAL (ESP MM2)
-- =====================================================

local VisualBox = Tabs.Visual:AddLeftGroupbox("ESP")
local espEnabled = false
local espCache = {}

local function getRole(player)
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		if backpack:FindFirstChild("Knife") then
			return "Murderer"
		elseif backpack:FindFirstChild("Gun") then
			return "Sheriff"
		end
	end
	return "Innocent"
end

local function getColor(role)
	if role == "Murderer" then
		return Color3.fromRGB(255,50,50)
	elseif role == "Sheriff" then
		return Color3.fromRGB(50,120,255)
	else
		return Color3.fromRGB(60,255,120)
	end
end

local function applyESP(player)
	if player == LocalPlayer or not player.Character then return end
	if espCache[player] then espCache[player]:Destroy() end

	local hl = Instance.new("Highlight")
	hl.Adornee = player.Character
	hl.FillTransparency = 1
	hl.OutlineTransparency = 0
	hl.OutlineColor = getColor(getRole(player))
	hl.Parent = player.Character

	espCache[player] = hl
end

local function clearESP()
	for _,h in pairs(espCache) do
		if h then h:Destroy() end
	end
	table.clear(espCache)
end

VisualBox:AddToggle("ESP", {
	Text = "ESP Roles (MM2)",
	Default = false,
	Callback = function(state)
		espEnabled = state
		if not state then clearESP() return end
		for _,plr in pairs(Players:GetPlayers()) do
			applyESP(plr)
		end
	end
})

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then applyESP(plr) end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if espCache[plr] then
		espCache[plr]:Destroy()
		espCache[plr] = nil
	end
end)

-- =====================================================
-- LOCAL PLAYER
-- =====================================================

local LocalBox = Tabs.Local:AddLeftGroupbox("Movement")

LocalBox:AddSlider("WalkSpeed", {
	Text = "WalkSpeed",
	Default = 18,
	Min = 18,
	Max = 90,
	Callback = function(v)
		if LocalPlayer.Character then
			LocalPlayer.Character.Humanoid.WalkSpeed = v
		end
	end
})

local noclip = false
LocalBox:AddToggle("Noclip", {
	Text = "Noclip",
	Default = false,
	Callback = function(v)
		noclip = v
	end
})

RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CanCollide = false
			end
		end
	end
end)

-- =====================================================
-- MUSIC
-- =====================================================

local MusicBox = Tabs.Music:AddLeftGroupbox("Music Player")
local sound = Instance.new("Sound", SoundService)
sound.Volume = 2

MusicBox:AddInput("MusicID", {
	Text = "Music ID",
	Placeholder = "rbxassetid://ID",
	Callback = function(v)
		sound.SoundId = v
	end
})

MusicBox:AddButton("Play", function() sound:Play() end)
MusicBox:AddButton("Stop", function() sound:Stop() end)

MusicBox:AddToggle("Loop", {
	Text = "Loop",
	Default = false,
	Callback = function(v)
		sound.Looped = v
	end
})

MusicBox:AddSlider("Speed", {
	Text = "Speed / Slowed",
	Default = 1,
	Min = 0.5,
	Max = 2,
	Callback = function(v)
		sound.PlaybackSpeed = v
	end
})

-- =====================================================
-- UI SETTINGS
-- =====================================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("MM2Hub")
SaveManager:SetFolder("MM2Hub/configs")

ThemeManager:ApplyToTab(Tabs.UI)
SaveManager:ApplyToTab(Tabs.UI)
