--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
blaa1 = getgenv()
blaa1.blaa2 = true
blaa3 = game:GetService("Players")
blaa4 = game:GetService("ReplicatedStorage")
blaa5 = blaa3.LocalPlayer
blaa6 = blaa4:WaitForChild("Events"):FindFirstChild("Character") and blaa4.Events.Character:FindFirstChild("SpeedBoost")
blaa7 = blaa4:WaitForChild("Events"):FindFirstChild("Character") and blaa4.Events.Character:FindFirstChild("MoveSpeed")

blaa8 = getrawmetatable(game)
setreadonly(blaa8, false)
blaa9 = blaa8.__namecall

blaa8.__namecall = function(blaa10, ...)
	blaa11 = {...}
	blaa12 = getnamecallmethod()

	if tostring(blaa10) == "PassCharacterInfoUnreliable" and blaa12 == "FireServer" then
		blaa13 = blaa11[2]
		if typeof(blaa13) == "table" and typeof(blaa13[2]) == "Vector2int16" then
			blaa13[1] = 60
			blaa11[2] = blaa13
		end
		return blaa9(blaa10, unpack(blaa11))
	end

	return blaa9(blaa10, ...)
end

task.spawn(function()
	while blaa1.blaa2 do
		blaa14 = blaa5.Character
		if blaa14 and blaa14:FindFirstChildOfClass("Humanoid") then
			pcall(function()
				blaa14.Humanoid.WalkSpeed = 80
			end)
		end
		task.wait(0.1)
	end
end)

task.spawn(function()
	while blaa1.blaa2 do
		if blaa6 then
			pcall(function()
				blaa6:FireServer(true)
			end)
		end
		task.wait(0.3)
	end
end)

task.spawn(function()
	while blaa1.blaa2 do
		if blaa7 then
			pcall(function()
				blaa7:FireServer(80)
			end)
		end
		task.wait(0.3)
	end
end)

while blaa1.blaa2 do
	blaa15 = blaa5
	blaa16 = blaa15.Character or blaa15.CharacterAdded:Wait()
	blaa17 = blaa16:GetAttribute("Downed")
	if blaa17 == true then
		blaa4.Events.Player.ChangePlayerMode:FireServer(true)
	end
	blaa18 = nil
	blaa19 = math.huge
	blaa20 = blaa15.Character and blaa15.Character:FindFirstChild("HumanoidRootPart")
	if blaa20 then
		for _, blaa21 in ipairs(blaa3:GetPlayers()) do
			if blaa21 ~= blaa15 then
				blaa22 = blaa21.Character
				if blaa22 and blaa22:GetAttribute("Downed") == true then
					blaa23 = blaa22:FindFirstChild("HumanoidRootPart")
					if blaa23 then
						blaa24 = (blaa20.Position - blaa23.Position).Magnitude
						if blaa24 < blaa19 then
							blaa19 = blaa24
							blaa18 = blaa21
						end
					end
				end
			end
		end
	end
	if blaa18 then
		blaa4.Events.Character.Interact:FireServer("Revive", true, blaa18.Name)
	end
	task.wait(0.25)
end
