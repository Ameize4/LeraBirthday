local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RevealLine = ReplicatedStorage.RemoteEvents.RevealLine
local RiddleTween = require(ReplicatedStorage.RiddleTween)
local Zone = require(ReplicatedStorage.Zone)

local FunHandler = require(script.FunHandler)
local PlayerHandler = require(script.PlayerHandler)

local targetColor = Color3.fromHex("55aaff")

local zoneTrigger = workspace:WaitForChild("FinalZoneEnteredTrigger")

local Colors = {
	BrickColor.Black().Color,
	BrickColor.Red().Color,
	targetColor,
	Color3.fromHex("6e6c6a"),
	Color3.new(0.498039, 0.223529, 0), -- Brown
	BrickColor.Yellow().Color,
	Color3.fromHex("02cd02"),
	BrickColor.White().Color,
	BrickColor.new("Royal purple").Color,
	Color3.fromHex("f72d93"), -- Pink
	Color3.fromRGB(253, 118, 1), -- Orange
	BrickColor.new("Dark blue").Color,
}

local tickModels = {}
local finished = false

local function checkValid()
	for button, info in tickModels do
		if info.pressed ~= true then return end
		if info.color ~= targetColor then return end
	end
	finished = true
	FunHandler.start()
	PlayerHandler.TeleportAllNontargerPlayer(workspace.Spawns.TortSpawn.CFrame)
end

for idx, model: Model in workspace:WaitForChild("TickingColor"):GetChildren() do
	local button = model:FindFirstChild("Button")
	button.CanCollide = false
	RiddleTween.initButtonTween(button)
	
	tickModels[button] = {model=model, idx=1, pressed=false, color=Color3.new(1,1,1)}
	
	
	local tempButton = button:Clone()
	tempButton.Parent = button.Parent
	tempButton.Name = 'tempButton'

	tempButton.Size += Vector3.new(0, 10, 0)
	tempButton.Transparency = 1

	local buttonZone = Zone.new(tempButton)

	local enteredPlayers = {}
	buttonZone.playerEntered:Connect(function(player)
		table.insert(enteredPlayers, player)
		RiddleTween.tweenButton(button, true)
		tickModels[button].pressed = true
		checkValid()
	end)
	buttonZone.playerExited:Connect(function(player)
		table.remove(enteredPlayers, table.find(enteredPlayers, player))
		if #enteredPlayers >= 0 then
			RiddleTween.tweenButton(button, false)
			tickModels[button].pressed = false
		end
	end)
	
end

task.spawn(function()
	while true do
		if finished then return end
		
		for _, modelInfo in tickModels do
			if modelInfo.pressed == true then
				continue
			end
			
			local model = modelInfo.model
			
			for _, meshPart in model:GetChildren() do
				meshPart.Color = Colors[modelInfo.idx]
			end
			modelInfo.color = Colors[modelInfo.idx]
			modelInfo.idx += 1
			if modelInfo.idx > #Colors then
				modelInfo.idx = 1
			end
		end
		wait(2)
	end
end)

-- Enable blue light hint 30 seconds after players entered zone
local playerEnteredOnce = false
workspace.Decor.Blue_light.Blue_light_SurfaceLight.Enabled = false
Zone.new(zoneTrigger).playerEntered:Connect(function()
	print('player')
	if playerEnteredOnce then return end
	playerEnteredOnce = true
	print('player2')
	wait(30)
	print('player3')
	workspace.Decor.Blue_light.Blue_light_SurfaceLight.Enabled = true
end)