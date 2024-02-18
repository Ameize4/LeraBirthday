local module = {}

local TweenService = game:GetService("TweenService")

local buttonsInfo = {}
local objectInfo = {}

local buttonTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint) --NEW_COM отдельный объект, который хранит инфу об анимации (время, стиль, повторы, etc)

function module.initButtonTween(button: MeshPart)
	local offPosition = button.Position
	local onPosition = offPosition - Vector3.new(0, 1, 0)
	if button:GetAttribute("isVertical") then
		onPosition = offPosition + Vector3.new(0, 0, 1)
	end
	
	buttonsInfo[button] = {
		tween=nil,
		offPosition=offPosition,
		onPosition=onPosition,
	}
end

function module.initObjectTween(object: MeshPart)
	objectInfo[object] = {
		tween = nil
	}
end


function module.tweenButton(button: MeshPart, activated: boolean)
	local prevTween: Tween = buttonsInfo[button].tween
	if prevTween then
		prevTween:Pause()
		prevTween:Destroy()
	end
	
	local goal = {}
	if activated then
		goal.Position = buttonsInfo[button].onPosition
	else
		goal.Position = buttonsInfo[button].offPosition
	end
	local tween = TweenService:Create(button, buttonTweenInfo, goal)
	tween:Play()

	buttonsInfo[button].tween = tween
end

function module.tweenObject(object: MeshPart, transparency: number)
	local prevTween = objectInfo[object].tween
	if prevTween then
		prevTween:Pause()
		prevTween:Destroy()
	end
	
	local goal = {Transparency=transparency}
	local tween = TweenService:Create(object, buttonTweenInfo, goal)
	tween:Play()
	
	objectInfo[object].tween = tween
end

return module
