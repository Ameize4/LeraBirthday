--[[NEW_COM
Позволяет стать основным игроком тому, кто пропишет команду в чат. У чата на команды autocomplete
Появилась для того чтобы можно было не перенастраивать игру если хочется поиграть снова
--]]

local TextChatService: TextChatCommand = game:GetService("TextChatService")
local Players = game:GetService("Players")

local command = Instance.new("TextChatCommand")
command.Parent = TextChatService
command.Name = "SetMainPlayerCommand"
command.PrimaryAlias = "/setMainPlayer"

command.Triggered:Connect(function(textSource: TextSource, unfilteredText: string) 
	local player = Players:GetPlayerByUserId(textSource.UserId)
	print(player)
	
	local currMainPlayer = workspace:GetAttribute("MainPlayer")
	
	if not currMainPlayer then
		workspace:SetAttribute("MainPlayer", tostring(player.UserId))
	else
		workspace:SetAttribute("MainPlayer", currMainPlayer .. "," .. player.UserId)
	end
end)