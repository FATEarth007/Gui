local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseHydraUpgrade =
	ReplicatedStorage.RemoteEvents.PurchaseHydraUpgrade

-- =========================
-- Human Delay
-- =========================

local function HumanDelay(minDelay, maxDelay)
	minDelay = minDelay or 0.4
	maxDelay = maxDelay or 1

	local delay = minDelay + math.random() * (maxDelay - minDelay)

	task.wait(delay)
end

-- =========================
-- UI
-- =========================

local Window = Library:CreateWindow({
	Title = "FatE Hub"
})

local World6 = Window:CreateTab("World 6")
local TitanSection = World6:CreateSection("Titan")

-- =========================
-- Auto Titan
-- =========================

local AutoTitanEnabled = false

local TitanUpgrades = {
	"HydraTianYield",
	"HydraAttackInterval",
	"HydraDamage"
}

TitanSection:CreateToggle({
	Name = "Auto Titan",
	Default = false,

	Callback = function(enabled)
		AutoTitanEnabled = enabled
		print("Auto Titan:", enabled)
	end
})

-- =========================
-- Purchase Function
-- =========================

local function PurchaseUpgrade(upgradeName)
	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()
		return PurchaseHydraUpgrade:InvokeServer(
			unpack(args)
		)
	end)

	if success then
		print("Invoked:", upgradeName)
	else
		warn("Failed:", upgradeName, result)
	end
end

-- =========================
-- Auto Titan Loop
-- =========================

task.spawn(function()
	while true do
		if AutoTitanEnabled then

			for _, upgradeName in ipairs(TitanUpgrades) do
				if not AutoTitanEnabled then
					break
				end

				PurchaseUpgrade(upgradeName)

				HumanDelay(0.4, 1)
			end

		else
			task.wait(0.1)
		end
	end
end)
