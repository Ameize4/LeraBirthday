--[[NEW_COM Скрипт отвечает за ловушки. Каждая ловушка имеет более одной кнопки, и пока один игрок держит кнопку открытой, 
	второй игрок может пробежать дальше и найти другой способ деактивировать ловушку.
	
	Структура ловушек в workspace следующая:
	workspace
	- Riddles
	- - [RiddleName]
	- - - Triggers
	- - - - Button
	- - - - Platform
	- - - Object
	Объект - это либо дверь, либо мост, которые игрокам надо активировать/деактивировать чтобы пройти.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RiddleTween = require(ReplicatedStorage.RiddleTween)
local Zone = require(ReplicatedStorage.Zone)

local RevealLine = ReplicatedStorage.RemoteEvents.RevealLine

local riddles = workspace:WaitForChild("Riddles")

local onceInteractedRiddleKeys = {}

local function riddleInteracted(key)
	if table.find(onceInteractedRiddleKeys, key) then return end
	table.insert(onceInteractedRiddleKeys, key)
	RevealLine:FireAllClients(#onceInteractedRiddleKeys+1) -- NEW_COM За взаимодействие с головоломкой открывает строчку стиха
end

local function objectSetEnable(object: MeshPart, value: boolean)
	if value == true then
		RiddleTween.tweenObject(object, 0)
		object.CanCollide = true
	else
		RiddleTween.tweenObject(object, 0.8)
		object.CanCollide = false
	end
end

local function initRiddle(object: MeshPart, buttons: {MeshPart})
	RiddleTween.initObjectTween(object)
	objectSetEnable(object, object:GetAttribute("DefaultState"))
	
	local activeButtonCount = 0
	
	for idx, button in buttons do
		RiddleTween.initButtonTween(button)
		
		local tempButton = button:Clone()
		tempButton.Parent = button.Parent
		tempButton.Name = 'tempButton'
		
		tempButton.Size += Vector3.new(0, 5, 0)
		tempButton.Transparency = 1
		
		local buttonZone = Zone.new(tempButton)
		
		local enteredPlayers = {}
		buttonZone.playerEntered:Connect(function(player)
			table.insert(enteredPlayers, player)
			RiddleTween.tweenButton(button, true)
			
			activeButtonCount += 1
			local objectState = not object:GetAttribute("DefaultState")
			objectSetEnable(object, objectState)
			riddleInteracted(button.Parent.Parent.Parent)
		end)
		buttonZone.playerExited:Connect(function(player)
			table.remove(enteredPlayers, table.find(enteredPlayers, player))
			if #enteredPlayers >= 0 then
				RiddleTween.tweenButton(button, false)
				
				activeButtonCount -= 1
				if activeButtonCount <= 0 then
					local objectState = object:GetAttribute("DefaultState")
					objectSetEnable(object, objectState)
				end
			end
		end)
	end
end

for idx, folder in riddles:GetChildren() do
	local object: MeshPart = folder:WaitForChild("Object")
	
	local buttons = {}
	for idx, trigger in folder:WaitForChild("Triggers"):GetChildren() do
		local button: MeshPart = trigger:WaitForChild("Button")
		button.CanCollide = false
		table.insert(buttons, button)
	end
	
	initRiddle(object, buttons)
end
