local PlayerHandler = {}

local Players = game:GetService("Players")
local firework = game.ServerStorage:WaitForChild("Фейерверк")

function PlayerHandler.IsTarget(player: Player): boolean
	if player.UserId == workspace:GetAttribute("TargetUserId") then
		return true
	end
	return false
end

local function TeleportTo(player: Player, position: Part)
	player.Character:PivotTo(position.CFrame)
end


function PlayerHandler.TeleportToCFrame(player: Player, InputCFrame: CFrame)
	player.Character:PivotTo(InputCFrame)
end


local function equipFirework(player)
	local fireworkCopy = firework:Clone()
	fireworkCopy.Parent = player.Backpack
	player.Character:WaitForChild("Humanoid"):EquipTool(fireworkCopy)
end


function PlayerHandler.TeleportAllNontargerPlayer(cframe: CFrame)
	for idx, player in Players:GetPlayers() do
		equipFirework(player)
		if PlayerHandler.IsTarget(player) then continue end
		
		PlayerHandler.TeleportToCFrame(player, cframe)
		wait(0.5)
	end
end


return PlayerHandler
