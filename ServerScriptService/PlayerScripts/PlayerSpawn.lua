local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[NEW_COM
	Определяем, куда спавнить игрока. Основных игроков располагаем на мейне, остальных прячем.
	Основной игрок или нет проверяется по аттрибуту сцены `MainPlayer`.
--]]
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local mainSpawn = workspace.Spawns.Main
local cageSpawn = workspace.Spawns.Hiding


local function isMainPlayer(userId): boolean
	local mainPlayers = tostring(workspace:GetAttribute("MainPlayer"))
	if table.find(string.split(mainPlayers, ","), tostring(userId)) then
		return true
	end
	return false
end


local function onCharacterAdded(player : Player, character : Model)
	task.wait(1) -- NEW_COM не всегда персонаж подгружен в тот же тик, когда и был послан сигнал о его добавлении. Роблокс не надежен в этом плане

	if isMainPlayer(player.UserId) then
		character:PivotTo(mainSpawn.CFrame) -- NEW_COM. CFrame - аналог transform из Юнити
		-- NEW_COM PivotTo используется когда расположение объекта задается не напрямую через CFrame 
	else
		character:PivotTo(cageSpawn.CFrame)
	end
end

local function onPlayerAdded(player : Player)
	local character = player.Character or player.CharacterAdded:Wait()

	player.CharacterAdded:Connect(function(character : Model)
		onCharacterAdded(player, character)
	end)

	onCharacterAdded(player, character)
end

--[[NEW_COM Common practice - коннектим обработку новых игроков к событию
но если игроки уже были на сервере, то мы также обрабатываем уже присутствующих игроков
Тоже самое делаем и с подключением персонажа внутри onPlayerAdded
--]]
Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end