-- ==========================================
-- FatE Hub - Noob Incremental
-- ==========================================

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/FATEarth007/Gui/refs/heads/main/FateUI.lua"
))()

local HttpService = game:GetService("HttpService")

local ConfigFile = "FatE_NoobInc_Config.json"

local Config = {
	TitanUpgrades = {},
	FloraUpgrades = {},
	MasteryUpgrades = {}
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

local PurchaseHydraUpgrade = ReplicatedStorage.RemoteEvents.PurchaseHydraUpgrade

local PurchaseUpgrade = ReplicatedStorage.RemoteEvents.PurchaseUpgrade

local PurchaseHydraMastery = ReplicatedStorage.RemoteEvents.PurchaseHydraMastery


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
local MasterySection = World6:CreateSection("Mastery")
local SoulSection = World6:CreateSection("Souls")

-- ==========================================
-- Titan Variables
-- ==========================================

local AutoTitanEnabled = false
local AutoFloraEnabled = false
local AutoMasteryEnabled = false
local AutoSoulEnabled = false



local SelectedTitanUpgrades =
	Config.TitanUpgrades or {}

local SelectedFloraUpgrades =
	Config.FloraUpgrades or {}

local SelectedMasteryUpgrades =
	Config.MasteryUpgrades or {} 


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

local AutoMasteryToggle = MasterySection:CreateToggle({
	Name = "Auto Mastery",
	Default = false,

	Callback = function(enabled)
		AutoMasteryEnabled = enabled
	end
})

SoulSection:CreateToggle({
	Name = "Auto Collect Souls",
	Default = false,

	Callback = function(enabled)
		AutoSoulEnabled = enabled
	end
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SoulsRuntime = workspace:WaitForChild("SoulsRuntime")

local function GetClosestSoul()
	local character = player.Character
	if not character then
		return nil
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end

	local closestBody = nil
	local closestDistance = math.huge

	for _, soul in ipairs(SoulsRuntime:GetChildren()) do
		local body = soul:FindFirstChild("Body")

		if body and body:IsA("BasePart") then
			local distance =
				(root.Position - body.Position).Magnitude

			if distance < closestDistance then
				closestDistance = distance
				closestBody = body
			end
		end
	end

	return closestBody
end

local function TeleportToSoul(body)
	local character = player.Character
	if not character then
		return
	end

	local position = GetPosition(body)
	if not position then
		return
	end

	character:PivotTo(
		CFrame.new(position + Vector3.new(0, 2, 0))
	)
end

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

local MasteryDropdown = MasterySection:CreateDropdown({
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

TitanDropdown:Set(
	SelectedTitanUpgrades
)

FloraDropdown:Set(
	SelectedFloraUpgrades
)

MasteryDropdown:Set(
	SelectedMasteryUpgrades
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

local function PurchaseMasteryUpgrade(upgradeName)
	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result = pcall(function()
		PurchaseHydraMastery:InvokeServer(
			unpack(args)
		)
	end)

	if not success then
		warn(
			"[Auto Mastery] Failed:", upgradeName, result)
	end
end

-- ==========================================
-- functions
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
		for _, upgradeName in ipairs(SelectedTitanUpgrades) do
			if not AutoTitanEnabled then
				break
			end

			PurchaseTitanUpgrade(upgradeName)
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
		for _, upgradeName in ipairs(SelectedFloraUpgrades) do 
			if not AutoFloraEnabled then
				break
			end

			PurchaseFloraUpgrade(upgradeName)
			HumanDelay()
		end
	end
end)

task.spawn(function()
	while true do

		-- Toggle OFF = do nothing
		if not AutoMasteryEnabled then
			task.wait(0.1)
			continue
		end

		-- Toggle ON, but nothing selected = do nothing
		if #SelectedMasteryUpgrades == 0 then
			task.wait(0.1)
			continue
		end

		-- Toggle ON + selected items = run them
		for _, upgradeName in ipairs(SelectedMasteryUpgrades) do
			if not AutoMasteryEnabled then
				break
			end

			PurchaseMasteryUpgrade(upgradeName)
			HumanDelay()
		end
	end
end)



local TianMarkPress =
	ReplicatedStorage.RemoteEvents:FindFirstChild("TianMarkPress")

if TianMarkPress then
	TianMarkPress.OnClientEvent:Connect(function(...)
		print("[TianMarkPress]", ...)
	end)
end


task.spawn(function()
	while true do
		if not AutoSoulEnabled then
			task.wait(0.2)
			continue
		end

		local soul = GetClosestSoul()

		if soul then
			TeleportToSoul(soul)

			-- Give the game's collection logic time to register
			task.wait(0.25)
		else
			task.wait(0.5)
		end
	end
end)
