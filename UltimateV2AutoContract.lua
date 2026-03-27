local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
getgenv().AutoContractEnabled = false

local FLY_HEIGHT = 120
local SPEED = 220
local ARRIVE_DISTANCE = 60

local travelling = false
local lastTarget = nil

local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "DeluxeGodUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,220)
main.Position = UDim2.new(0.5,-160,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(0,255,140)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "✈ Airplane Simulator"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)

local subtitle = Instance.new("TextLabel",main)
subtitle.Size = UDim2.new(1,0,0,25)
subtitle.Position = UDim2.new(0,0,0,35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "DELUXE GOD SCRIPT"
subtitle.Font = Enum.Font.GothamSemibold
subtitle.TextSize = 14
subtitle.TextColor3 = Color3.fromRGB(0,255,140)

local status = Instance.new("TextLabel",main)
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,0,65)
status.BackgroundTransparency = 1
status.Text = "🟢 UNDETECTED  |  ⚡ STABLE  |  👁 SAFE"
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200,200,200)

local warning = Instance.new("TextLabel", main)
warning.Size = UDim2.new(0.9,0,0,45)
warning.Position = UDim2.new(0.05,0,0,90)
warning.BackgroundTransparency = 1
warning.TextWrapped = true
warning.Text = "⚠ START THE AIRPLANE ENGINE before enabling Auto Contract.\nSelect contracts MANUALLY."
warning.Font = Enum.Font.GothamSemibold
warning.TextSize = 13
warning.TextColor3 = Color3.fromRGB(255,180,60)

task.spawn(function()
	while true do
		TweenService:Create(
			warning,
			TweenInfo.new(0.8, Enum.EasingStyle.Sine),
			{TextTransparency = 0.6}
		):Play()
		task.wait(0.8)

		TweenService:Create(
			warning,
			TweenInfo.new(0.8, Enum.EasingStyle.Sine),
			{TextTransparency = 0}
		):Play()
		task.wait(0.8)
	end
end)

local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1,0,0,18)
credit.Position = UDim2.new(0,0,1,-20)
credit.BackgroundTransparency = 1
credit.Text = "made by: tigredabet [DISCORD]"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(150,150,150)
credit.TextXAlignment = Enum.TextXAlignment.Center

task.spawn(function()
	while true do
		TweenService:Create(
			credit,
			TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{
				TextTransparency = 0.4,
				TextColor3 = Color3.fromRGB(0,255,140)
			}
		):Play()

		task.wait(1.5)

		TweenService:Create(
			credit,
			TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{
				TextTransparency = 0,
				TextColor3 = Color3.fromRGB(150,150,150)
			}
		):Play()

		task.wait(1.5)
	end
end)

local clickSound = Instance.new("Sound", main)
clickSound.SoundId = "rbxassetid://6026984224"
clickSound.Volume = 1

local toggle = Instance.new("TextButton",main)
toggle.Size = UDim2.new(0.8,0,0,45)
toggle.Position = UDim2.new(0.1,0,0.68,0)
toggle.Text = "ENABLE"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.BackgroundColor3 = Color3.fromRGB(170,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,10)

toggle.MouseButton1Click:Connect(function()
	clickSound:Play()
	getgenv().AutoContractEnabled = not getgenv().AutoContractEnabled
	if getgenv().AutoContractEnabled then
		toggle.Text = "DISABLE"
		toggle.BackgroundColor3 = Color3.fromRGB(40,170,90)
	else
		toggle.Text = "ENABLE"
		toggle.BackgroundColor3 = Color3.fromRGB(170,40,40)
	end
end)

local function tweenModel(model, targetCF, time)
	if not model or not model.PrimaryPart then return end
	local value = Instance.new("CFrameValue")
	value.Value = model:GetPrimaryPartCFrame()
	local con = value.Changed:Connect(function()
		model:SetPrimaryPartCFrame(value.Value)
	end)
	local tween = TweenService:Create(
		value,
		TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{Value = targetCF}
	)
	tween:Play()
	tween.Completed:Wait()
	con:Disconnect()
	value:Destroy()
end

local function flyTo(model, targetCF)
	if travelling then return end
	travelling = true
	local start = model.PrimaryPart.CFrame
	local distance = (start.Position - targetCF.Position).Magnitude
	local travelTime = math.clamp(distance / SPEED, 2, 10)
	local upStart = start + Vector3.new(0,FLY_HEIGHT,0)
	local upEnd = targetCF + Vector3.new(0,FLY_HEIGHT,0)
	tweenModel(model, upStart, 1.2)
	tweenModel(model, upEnd, travelTime)
	local groundCF = CFrame.new(targetCF.Position.X, targetCF.Position.Y + 5, targetCF.Position.Z)
	tweenModel(model, groundCF, 1.5)
	model.PrimaryPart.Anchored = true
	task.wait(2)
	model.PrimaryPart.Anchored = false
	lastTarget = targetCF.Position
	travelling = false
end

local function getPlane()
	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and hum.SeatPart then
		return hum.SeatPart.Parent.Parent
	end
end

local function findMarker()
	for _,v in ipairs(workspace:GetDescendants()) do
		if v.Name == "LocationMarker" then
			return v
		end
	end
end

task.spawn(function()
	while task.wait(0.7) do
		if not getgenv().AutoContractEnabled then continue end
		local plane = getPlane()
		local marker = findMarker()
		if not plane or not marker then continue end
		if not marker.Parent:FindFirstChild("Highlight") then continue end
		local targetCF = marker.Parent.Highlight.WorldPivot
		local distance = plr:DistanceFromCharacter(targetCF.Position)
		if distance < ARRIVE_DISTANCE then continue end
		if lastTarget and (lastTarget - targetCF.Position).Magnitude < 10 then continue end
		flyTo(plane, targetCF)
	end
end)
