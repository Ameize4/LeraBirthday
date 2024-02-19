local module = {}
local TweenService = game:GetService("TweenService")


local fanBlades = workspace.Decor:WaitForChild("floppa fan"):WaitForChild("Thermoloth"):WaitForChild("arno fan blades replica")

local started = false

local function disableCandles()
	for i, c in workspace:GetDescendants() do 
		if c.ClassName == 'ParticleEmitter' then 
			print(c)
			c.Enabled = false
		end 
	end
end

function module.start()
	if started == true then return end
	started = true
	
	local tinfo = TweenInfo.new(0.33, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 50)
	local goal = {}
	goal.Rotation = fanBlades.Rotation + Vector3.new(0, 0, 359)
	local tween = TweenService:Create(fanBlades, tinfo, goal)
	tween:Play()
	
	wait(2)
	disableCandles()
end

return module
