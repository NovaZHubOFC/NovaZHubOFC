
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

local Window = OrionLib:MakeWindow({
	Name = "NovaZHub Box",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "NovaZHubBox"
})

-- Tabs
local UniversalTab = Window:MakeTab({
	Name = "Universal",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local GameTab = Window:MakeTab({
	Name = "Game",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local UpdateTab = Window:MakeTab({
	Name = "Updates",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

OrionLib:MakeNotification({
	Name = "NovaZHub Box",
	Content = "Central de Scripts carregada!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

-- Universal
UniversalTab:AddButton({
	Name = "MM2",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHubOFC/NovaZHubOFC/main/Mm2.lua", true))()
	end
})

UniversalTab:AddButton({
	Name = "Hitbox Expand",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHub/Yield/main/Hitboxexpand.lua"))()
	end
})

-- Game
GameTab:AddButton({
	Name = "TBB Healthbar ESP",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHubOFC/NovaZHubOFC/main/TBBHeathbarEsp.lua"))()
	end
})

GameTab:AddButton({
	Name = "Lucky Block Battlegrounds",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHub/Yield/main/Luckyblockbattlegrounds.lua"))()
	end
})

GameTab:AddButton({
	Name = "Raise a Cool Kid",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHub/Yield/main/raiseaco0lkid.lua"))()
	end
})

GameTab:AddButton({
	Name = "☭ Script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHubOFC/NovaZHubOFC/main/%E2%98%AD.lua"))()
	end
})

GameTab:AddButton({
	Name = "Build a Plane",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NovaZHub/Yield/main/buildaplane.lua"))()
	end
})

-- Updates
UpdateTab:AddParagraph(
	"NovaZHub Box",
	"Launcher oficial da NovaZHub.\n\nAbas:\n- Universal: scripts globais\n- Game: scripts por jogo\n- Updates: novidades\n\nIncluídos:\nMM2\nHitbox Expand\nTBB Healthbar ESP\nLucky Block Battlegrounds\nRaise a Cool Kid\n☭ Script\nBuild a Plane"
)

OrionLib:Init()

-- Botão flutuante para abrir/fechar
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Toggleui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Toggle.BackgroundTransparency = 0.5
Toggle.Position = UDim2.new(0, 0, 0.45, 0)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Draggable = true
Toggle.Text = ""

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = Toggle

local Image = Instance.new("ImageLabel")
Image.Name = "Icon"
Image.Parent = Toggle
Image.Size = UDim2.new(1, 0, 1, 0)
Image.BackgroundTransparency = 1
Image.Image = "rbxassetid://117239677500065"

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0.2, 0)
Corner2.Parent = Image

Toggle.MouseButton1Click:Connect(function()
	OrionLib:ToggleUi()
end)
