-- ==========================================
-- FatE Hub - Noob Incremental
-- ==========================================

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseHydraUpgrade =
	ReplicatedStorage.RemoteEvents.PurchaseHydraUpgrade

local PurchaseUpgrade =
	ReplicatedStorage.RemoteEvents.PurchaseUpgrade


-- ==========================================
-- Human Delay
-- ==========================================

local function HumanDelay()
	local delayTime = 0.4 + math.random() * 0.6
	task.wait(delayTime)
end


-- ==========================================
-- Window
-- ==========================================

local Window = Library:CreateWindow({
	Title = "FatE Hub"
})


-- ==========================================
-- World 6
-- ==========================================

local World6 = Window:CreateTab("World 6")


-- ==========================================
-- Titan Section
-- ==========================================

local TitanSection = World6:CreateSection("Titan")
local FloraSection = World6:CreateSection("Flora")

-- ==========================================
-- Titan Variables
-- ==========================================

local AutoTitanEnabled = false
local AutoFloraEnabled = false

local SelectedTitanUpgrades = {}
local SelectedFloraUpgrades = {}

-- ==========================================
-- Auto Toggles
-- ==========================================

TitanSection:CreateToggle({
	Name = "Auto Titan",
	Default = false,

	Callback = function(enabled)
		AutoTitanEnabled = enabled

		print(
			"[Auto Titan]",
			enabled and "Enabled" or "Disabled"
		)
	end
})

FloraSection:CreateToggle({
	Name = "Auto Flora",
	Default = false,

	Callback = function(enabled)
		AutoFloraEnabled = enabled

		print(
			"[Auto Flora]",
			enabled and "Enabled" or "Disabled"
		)
	end
})

-- ==========================================
-- Upgrade Selections
-- ==========================================

TitanSection:CreateDropdown({
	Name = "Auto Titan Upgrades",

	Options = {
		"HydraTianYield",
		"HydraAttackInterval",
		"HydraDamage",
		"HydraQiBoost"
	},

	Multi = true,

	Callback = function(selected)
		SelectedTitanUpgrades = selected
	end
})

FloraSection:CreateDropdown({
	Name = "Auto Flora Upgrades",

	Options = {
		"FloraMoreQiII",
		"FloraMoreFloraII"
	},

	Multi = true,

	Callback = function(selected)
		SelectedFloraUpgrades = selected
	end
})


-- ==========================================
-- Purchase Titan Upgrade
-- ==========================================

local function PurchaseTitanUpgrade(upgradeName)
	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()
		return PurchaseHydraUpgrade:InvokeServer(
			unpack(args)
		)

	end)

	if not success then
		warn(
			"[Auto Titan] Failed:", upgradeName, result)

	end
end

local function PurchaseFloraUpgrade(upgradeName)
	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()
		return PurchaseUpgrade:InvokeServer(
			unpack(args)
		)
	end)

	if not success then
		warn("Flora upgrade failed:", upgradeName, result)
	end
end

-- ==========================================
-- Auto Titan Loop
-- ==========================================

task.spawn(function()

	while true do

		-- Auto Titan is OFF
		if not AutoTitanEnabled then
			task.wait(0.1)
			continue
		end

		-- Nothing selected
		if #SelectedTitanUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		-- Process selected upgrades
		for _, upgradeName
			in ipairs(SelectedTitanUpgrades) do

			-- Check toggle again
			if not AutoTitanEnabled then
				break
			end

			PurchaseTitanUpgrade(
				upgradeName
			)

			-- Random 0.4 - 1.0 second delay
			HumanDelay()
		end
	end
end)

task.spawn(function()

	while true do

		-- Auto Titan is OFF
		if not AutoFloraEnabled then
			task.wait(0.1)
			continue
		end

		-- Nothing selected
		if #SelectedFloraUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		-- Process selected upgrades
		for _, upgradeName
			in ipairs(SelectedFloraUpgrades) do

			-- Check toggle again
			if not AutoFloraEnabled then
				break
			end

			PurchaseFloraUpgrade(
				upgradeName
			)

			-- Random 0.4 - 1.0 second delay
			HumanDelay()
		end
	end
end)
