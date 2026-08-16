local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local function HumanDelay(minDelay, maxDelay)
	minDelay = minDelay or 0.4
	maxDelay = maxDelay or 1

	local delay = minDelay + math.random() * (maxDelay - minDelay)

	task.wait(delay)

	return delay
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseHydraUpgrade =
	ReplicatedStorage.RemoteEvents.PurchaseHydraUpgrade

local Window = Library:CreateWindow({
	Title = "FatE Hub"
})

local World6 = Window:CreateTab("World 6")
local TitanSection = World6:CreateSection("Titan")

-- Starts disabled
local AutoTitanEnabled = false

TitanSection:CreateToggle({
	Name = "Auto Titan",
	Default = false,

	Callback = function(enabled)
		AutoTitanEnabled = enabled
		print("Auto Titan:", enabled)
	end
})

task.spawn(function()
	while true do
		if AutoTitanEnabled then

			local args = {
				[1] = "HydraTianYield",
				[2] = false
			}

			local success, result = pcall(function()
				return PurchaseHydraUpgrade:InvokeServer(
					unpack(args)
				)
			end)

			if success then
				print("HydraTianYield invoked:", result)
			else
				warn("Hydra upgrade failed:", result)
			end

			HumanDelay(0.4, 1)
		else
			task.wait(0.1)
		end
	end
end)
