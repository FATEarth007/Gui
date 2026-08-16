-- ==========================================
-- FatE Hub - Noob Incremental
-- ==========================================

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local HttpService = game:GetService("HttpService")

local ConfigFile = "FatE_NoobInc_Config.json"

local Config = {
	AutoTitan = false,
	AutoFlora = false,

	TitanUpgrades = {},
	FloraUpgrades = {}
}

local function SaveConfig()
	if not writefile then
		return
	end

	local success, encoded = pcall(function()
		return HttpService:JSONEncode(Config)
	end)

	if success then
		writefile(ConfigFile, encoded)
	end
end

local function LoadConfig()
	if not readfile or not isfile then
		return
	end

	if not isfile(ConfigFile) then
		return
	end

	local success, decoded = pcall(function()
		return HttpService:JSONDecode(
			readfile(ConfigFile)
		)
	end)

	if success and typeof(decoded) == "table" then
		Config = decoded
	end
end

LoadConfig()

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

local SelectedTitanUpgrades =
	Config.TitanUpgrades or {}

local SelectedFloraUpgrades =
	Config.FloraUpgrades or {}

-- ==========================================
-- Auto Toggles
-- ==========================================

local AutoTitanToggle = TitanSection:CreateToggle({
	Name = "Auto Titan",
	Default = false,

	Callback = function(enabled)
		AutoTitanEnabled = enabled
	end
})

local AutoFloraToggle = FloraSection:CreateToggle({
	Name = "Auto Flora",
	Default = false,

	Callback = function(enabled)
		AutoFloraEnabled = enabled
	end
})

-- ==========================================
-- Upgrade Selections
-- ==========================================

local TitanDropdown = TitanSection:CreateDropdown({
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
		Config.TitanUpgrades = selected
		SaveConfig()
end
})

local FloraDropdown = FloraSection:CreateDropdown({
	Name = "Auto Flora Upgrades",

	Options = {
		"FloraMoreQiII",
		"FloraMoreFloraII"
	},

	Multi = true,

	Callback = function(selected)
		SelectedFloraUpgrades = selected
		Config.FloraUpgrades = selected
		SaveConfig()
end
})

TitanDropdown:Set(
	SelectedTitanUpgrades
)

FloraDropdown:Set(
	SelectedFloraUpgrades
)

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
		PurchaseUpgrade:FireServer(
			unpack(args)
		)
	end)

	if not success then
		warn(
			"[Auto Flora] Failed:", upgradeName, result)
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
