-- ==========================================
-- FatE Hub - Noob Incremental
-- ==========================================

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer


-- ==========================================
-- Config
-- ==========================================

local ConfigFile = "FatE_NoobInc_Config.json"

local Config = {
	TitanUpgrades = {},
	FloraUpgrades = {},
	MasteryUpgrades = {},
	SoulUpgrades = {}
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


-- ==========================================
-- Remotes
-- ==========================================

local RemoteEvents =
	ReplicatedStorage:WaitForChild("RemoteEvents")

local PurchaseHydraUpgrade =
	RemoteEvents:WaitForChild("PurchaseHydraUpgrade")

local PurchaseUpgrade =
	RemoteEvents:WaitForChild("PurchaseUpgrade")

local PurchaseHydraMastery =
	RemoteEvents:WaitForChild("PurchaseHydraMastery")

local PurchaseSoulUpgrade =
	RemoteEvents:WaitForChild("purchase_souls_upgrade")


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
-- Tabs
-- ==========================================

local World6 =
	Window:CreateTab("World 6")

local SettingsTab =
	Window:CreateTab("Settings")


-- ==========================================
-- Sections
-- ==========================================

local TitanSection =
	World6:CreateSection("Titan")

local FloraSection =
	World6:CreateSection("Flora")

local MasterySection =
	World6:CreateSection("Mastery")

local SoulSection =
	World6:CreateSection("Souls")

local SettingsSection =
	SettingsTab:CreateSection("Script")


-- ==========================================
-- Automation Variables
-- ==========================================

local ScriptRunning = true

local AutoTitanEnabled = false
local AutoFloraEnabled = false
local AutoMasteryEnabled = false
local AutoSoulEnabled = false
local AutoSoulUpgradesEnabled = false

local SelectedTitanUpgrades =
	Config.TitanUpgrades or {}

local SelectedFloraUpgrades =
	Config.FloraUpgrades or {}

local SelectedMasteryUpgrades =
	Config.MasteryUpgrades or {}

local SelectedSoulUpgrades =
	Config.SoulUpgrades or {}


-- ==========================================
-- Titan Controls
-- ==========================================

TitanSection:CreateToggle({
	Name = "Auto Titan",
	Default = false,

	Callback = function(enabled)
		AutoTitanEnabled = enabled
	end
})

local TitanDropdown =
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
		Config.TitanUpgrades = selected
		SaveConfig()
	end
})


-- ==========================================
-- Flora Controls
-- ==========================================

FloraSection:CreateToggle({
	Name = "Auto Flora",
	Default = false,

	Callback = function(enabled)
		AutoFloraEnabled = enabled
	end
})

local FloraDropdown =
	FloraSection:CreateDropdown({

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


-- ==========================================
-- Mastery Controls
-- ==========================================

MasterySection:CreateToggle({
	Name = "Auto Mastery",
	Default = false,

	Callback = function(enabled)
		AutoMasteryEnabled = enabled
	end
})

local MasteryDropdown =
	MasterySection:CreateDropdown({

	Name = "Auto Mastery Upgrades",

	Options = {
		"relic_strength"
	},

	Multi = true,

	Callback = function(selected)
		SelectedMasteryUpgrades = selected
		Config.MasteryUpgrades = selected
		SaveConfig()
	end
})


-- ==========================================
-- Soul Controls
-- ==========================================

SoulSection:CreateToggle({
	Name = "Auto Collect Souls",
	Default = false,

	Callback = function(enabled)
		AutoSoulEnabled = enabled
	end
})

SoulSection:CreateToggle({
	Name = "Auto Soul Upgrades",
	Default = false,

	Callback = function(enabled)
		AutoSoulUpgradesEnabled = enabled
	end
})

local SoulUpgradeDropdown =
	SoulSection:CreateDropdown({

	Name = "Soul Upgrades",

	Options = {
		"SoulsQiBoost"
	},

	Multi = true,

	Callback = function(selected)
		SelectedSoulUpgrades = selected
		Config.SoulUpgrades = selected
		SaveConfig()
	end
})


-- ==========================================
-- Restore Dropdown Selections
-- ==========================================

TitanDropdown:Set(
	SelectedTitanUpgrades
)

FloraDropdown:Set(
	SelectedFloraUpgrades
)

MasteryDropdown:Set(
	SelectedMasteryUpgrades
)

SoulUpgradeDropdown:Set(
	SelectedSoulUpgrades
)


-- ==========================================
-- Kill Script
-- ==========================================

SettingsSection:CreateButton({
	Name = "Kill Script",

	Callback = function()

		-- Stop every automation
		ScriptRunning = false

		AutoTitanEnabled = false
		AutoFloraEnabled = false
		AutoMasteryEnabled = false
		AutoSoulEnabled = false
		AutoSoulUpgradesEnabled = false

		print("[FatE Hub] Killing script")

		-- Hide the window immediately
		if Window.MainFrame then
			Window.MainFrame.Visible = false
		end

		-- Destroy FateUI
		if Window.ScreenGui then
			Window.ScreenGui:Destroy()
		end

		print("[FatE Hub] Script killed")
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
			"[Auto Titan] Failed:",
			upgradeName,
			result
		)
	end
end


-- ==========================================
-- Purchase Flora Upgrade
-- ==========================================

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
			"[Auto Flora] Failed:",
			upgradeName,
			result
		)
	end
end


-- ==========================================
-- Purchase Mastery Upgrade
-- ==========================================

local function PurchaseMasteryUpgrade(upgradeName)

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()

		return PurchaseHydraMastery:InvokeServer(
			unpack(args)
		)

	end)

	if not success then
		warn(
			"[Auto Mastery] Failed:",
			upgradeName,
			result
		)
	end
end


-- ==========================================
-- Purchase Soul Upgrade
-- ==========================================

local function PurchaseSoulUpgradeByName(upgradeName)

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()

		return PurchaseSoulUpgrade:InvokeServer(
			unpack(args)
		)

	end)

	if not success then
		warn(
			"[Auto Soul Upgrades] Failed:",
			upgradeName,
			result
		)
	end
end


-- ==========================================
-- Soul Collection
-- ==========================================

local SoulsRuntime =
	workspace:WaitForChild("SoulsRuntime")

local function GetClosestSoul()

	local character = player.Character

	if not character then
		return nil
	end

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not root then
		return nil
	end

	local closestBody = nil
	local closestDistance = math.huge

	for _, soul
		in ipairs(SoulsRuntime:GetChildren()) do

		local body =
			soul:FindFirstChild(
				"Body",
				true
			)

		if body and body:IsA("BasePart") then

			local distance =
				(
					root.Position
					- body.Position
				).Magnitude

			if distance < closestDistance then
				closestDistance = distance
				closestBody = body
			end
		end
	end

	return closestBody
end


local function MoveToSoul(body)

	if not body then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	if not humanoid then
		return
	end

	humanoid:MoveTo(
		body.Position
	)
end


-- ==========================================
-- Auto Titan Loop
-- ==========================================

task.spawn(function()

	while ScriptRunning do

		if not AutoTitanEnabled then
			task.wait(0.1)
			continue
		end

		if #SelectedTitanUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		for _, upgradeName
			in ipairs(SelectedTitanUpgrades) do

			if not ScriptRunning
				or not AutoTitanEnabled then
				break
			end

			PurchaseTitanUpgrade(
				upgradeName
			)

			HumanDelay()
		end
	end
end)


-- ==========================================
-- Auto Flora Loop
-- ==========================================

task.spawn(function()

	while ScriptRunning do

		if not AutoFloraEnabled then
			task.wait(0.1)
			continue
		end

		if #SelectedFloraUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		for _, upgradeName
			in ipairs(SelectedFloraUpgrades) do

			if not ScriptRunning
				or not AutoFloraEnabled then
				break
			end

			PurchaseFloraUpgrade(
				upgradeName
			)

			HumanDelay()
		end
	end
end)


-- ==========================================
-- Auto Mastery Loop
-- ==========================================

task.spawn(function()

	while ScriptRunning do

		if not AutoMasteryEnabled then
			task.wait(0.1)
			continue
		end

		if #SelectedMasteryUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		for _, upgradeName
			in ipairs(SelectedMasteryUpgrades) do

			if not ScriptRunning
				or not AutoMasteryEnabled then
				break
			end

			PurchaseMasteryUpgrade(
				upgradeName
			)

			HumanDelay()
		end
	end
end)


-- ==========================================
-- Auto Soul Upgrade Loop
-- ==========================================

task.spawn(function()

	while ScriptRunning do

		if not AutoSoulUpgradesEnabled then
			task.wait(0.1)
			continue
		end

		if #SelectedSoulUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		for _, upgradeName
			in ipairs(SelectedSoulUpgrades) do

			if not ScriptRunning
				or not AutoSoulUpgradesEnabled then
				break
			end

			PurchaseSoulUpgradeByName(
				upgradeName
			)

			HumanDelay()
		end
	end
end)


-- ==========================================
-- Auto Soul Collection Loop
-- ==========================================

task.spawn(function()

	while ScriptRunning do

		if not AutoSoulEnabled then
			task.wait(0.2)
			continue
		end

		local soul =
			GetClosestSoul()

		if soul then

			MoveToSoul(soul)

			task.wait(0.25)

		else

			task.wait(0.5)

		end
	end
end)


-- ==========================================
-- TianMarkPress Listener
-- ==========================================

local TianMarkPress =
	RemoteEvents:FindFirstChild(
		"TianMarkPress"
	)

if TianMarkPress then

	TianMarkPress.OnClientEvent:Connect(
		function(...)
			-- Consume incoming event
		end
	)

end
