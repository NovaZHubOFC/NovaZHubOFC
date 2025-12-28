local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.45, 0.35)
frame.Position = UDim2.fromScale(0.275, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.9, 0.4)
box.Position = UDim2.fromScale(0.05, 0.15)
box.PlaceholderText = "Paste the RAW URL of the script here."
box.TextWrapped = true
box.ClearTextOnFocus = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.TextColor3 = Color3.new(1,1,1)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.fromScale(0.6, 0.2)
btn.Position = UDim2.fromScale(0.2, 0.65)
btn.Text = "Gerar Loadstring"
btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
    local url = box.Text
    if url == "" then return end

    local load = [[
local Source = game:HttpGet("]] .. url .. [[")
local Run = loadstring(Source)
if Run then
    Run()
end
]]

    setclipboard(load)
    warn("Loadstring copied!")
end)
