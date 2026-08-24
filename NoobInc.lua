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
		pcall(writefile, ConfigFile, encoded)
	end
end

local function LoadConfig()
	if not readfile or not isfile then
		return
	end

	local okExists, exists = pcall(
		isfile,
		ConfigFile
	)

	if not okExists or not exists then
		return
	end

	local success, decoded = pcall(function()
		return HttpService:JSONDecode(
			readfile(ConfigFile)
		)
	end)

	if success and typeof(decoded) == "table" then

		-- Merge saved values onto defaults.
		for key, value in pairs(decoded) do
			Config[key] = value
		end
	end
end

LoadConfig()


-- ==========================================
-- Remotes
-- ==========================================

local REMOTE_WAIT_TIMEOUT = 10

local RemoteEvents =
	ReplicatedStorage:WaitForChild(
		"RemoteEvents",
		REMOTE_WAIT_TIMEOUT
	)

if not RemoteEvents then
	warn(
		"[FatE Hub] RemoteEvents not found, aborting load."
	)

	return
end


local function safeWaitForChild(parent, name)

	local inst =
		parent:WaitForChild(
			name,
			REMOTE_WAIT_TIMEOUT
		)

	if not inst then
		warn(
			"[FatE Hub] Missing remote:",
			name
		)
	end

	return inst
end


local PurchaseHydraUpgrade =
	safeWaitForChild(
		RemoteEvents,
		"PurchaseHydraUpgrade"
	)

local PurchaseUpgrade =
	safeWaitForChild(
		RemoteEvents,
		"PurchaseUpgrade"
	)

local PurchaseHydraMastery =
	safeWaitForChild(
		RemoteEvents,
		"PurchaseHydraMastery"
	)

local PurchaseSoulUpgrade =
	safeWaitForChild(
		RemoteEvents,
		"purchase_souls_upgrade"
	)


-- ==========================================
-- Human Delay
-- ==========================================

local function HumanDelay()

	local delayTime =
		0.4 + math.random() * 0.6

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

local DungeonTab =
	Window:CreateTab("Dungeon")

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

local DungeonSection =
	DungeonTab:CreateSection("Automation")

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

local AutoDungeonEnabled = false

local WalkSpeed = 16


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

		SelectedTitanUpgrades =
			selected

		Config.TitanUpgrades =
			selected

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

		SelectedFloraUpgrades =
			selected

		Config.FloraUpgrades =
			selected

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

		SelectedMasteryUpgrades =
			selected

		Config.MasteryUpgrades =
			selected

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
		"SoulsQiBoost",
		"SoulsLuckBoost",
		"SoulsGainBoost",
		"SoulsLightDuration",
		"SoulsLightSize",
		"SoulsLightChance",
		"SoulsSpawnCapacity",
		"SoulsSpawnSpeed"
	},

	Multi = true,

	Callback = function(selected)

		SelectedSoulUpgrades =
			selected

		Config.SoulUpgrades =
			selected

		SaveConfig()
	end
})


-- ==========================================
-- Dungeon Controls
-- ==========================================

DungeonSection:CreateToggle({
	Name = "Auto Dungeon",
	Default = false,

	Callback = function(enabled)

		AutoDungeonEnabled = enabled

	end
})


-- ==========================================
-- Settings Controls
-- ==========================================

SettingsSection:CreateSlider({
	Name = "Walk Speed",

	Min = 8,
	Max = 50,
	Default = 16,
	Increment = 1,

	Callback = function(value)

		WalkSpeed = value

		local character =
			player.Character

		if not character then
			return
		end

		local humanoid =
			character:FindFirstChildOfClass(
				"Humanoid"
			)

		if humanoid then
			humanoid.WalkSpeed =
				value
		end
	end
})


-- ==========================================
-- Apply Walk Speed After Respawn
-- ==========================================

player.CharacterAdded:Connect(
	function(character)

		local humanoid =
			character:WaitForChild(
				"Humanoid"
			)

		humanoid.WalkSpeed =
			WalkSpeed

	end
)


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

		ScriptRunning = false

		AutoTitanEnabled = false
		AutoFloraEnabled = false
		AutoMasteryEnabled = false

		AutoSoulEnabled = false
		AutoSoulUpgradesEnabled = false

		AutoDungeonEnabled = false


		-- Stop current movement

		local character =
			player.Character

		if character then

			local humanoid =
				character:FindFirstChildOfClass(
					"Humanoid"
				)

			local root =
				character:FindFirstChild(
					"HumanoidRootPart"
				)

			if humanoid and root then

				humanoid:MoveTo(
					root.Position
				)

			end
		end


		-- Hide/remove UI

		if Window.MainFrame then
			Window.MainFrame.Visible =
				false
		end

		if Window.ScreenGui then
			Window.ScreenGui:Destroy()
		end
	end
})


-- ==========================================
-- Purchase Titan Upgrade
-- ==========================================

local function PurchaseTitanUpgrade(
	upgradeName
)

	if not PurchaseHydraUpgrade then
		return
	end

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result =
		pcall(function()

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

local function PurchaseFloraUpgrade(
	upgradeName
)

	if not PurchaseUpgrade then
		return
	end

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, err =
		pcall(function()

			PurchaseUpgrade:FireServer(
				unpack(args)
			)

		end)

	if not success then

		warn(
			"[Auto Flora] Failed:",
			upgradeName,
			err
		)

	end
end


-- ==========================================
-- Purchase Mastery Upgrade
-- ==========================================

local function PurchaseMasteryUpgrade(
	upgradeName
)

	if not PurchaseHydraMastery then
		return
	end

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result =
		pcall(function()

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

local function PurchaseSoulUpgradeByName(
	upgradeName
)

	if not PurchaseSoulUpgrade then
		return
	end

	local args = {
		[1] = upgradeName,
		[2] = false
	}

	local success, result =
		pcall(function()

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
-- Generic Movement
-- ==========================================

local function MoveToPosition(position)

	local character =
		player.Character

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
		position
	)
end


-- ==========================================
-- Souls Runtime
-- ==========================================

local SoulsRuntime =
	workspace:WaitForChild(
		"SoulsRuntime",
		REMOTE_WAIT_TIMEOUT
	)


-- ==========================================
-- Soul Cache
-- ==========================================

local SoulBodyCache = {}


local function CacheSoulBody(soul)

	task.spawn(function()

		local body =
			soul:WaitForChild(
				"Body",
				5
			)

		if body
			and body:IsA("BasePart")
			and soul.Parent then

			SoulBodyCache[soul] =
				body

		end

	end)
end


if SoulsRuntime then

	for _, soul
		in ipairs(
			SoulsRuntime:GetChildren()
		) do

		CacheSoulBody(soul)
	end


	SoulsRuntime.ChildAdded:Connect(
		CacheSoulBody
	)


	SoulsRuntime.ChildRemoved:Connect(
		function(soul)

			SoulBodyCache[soul] =
				nil

		end
	)
end


local function GetClosestSoul()

	if not SoulsRuntime then
		return nil
	end

	local character =
		player.Character

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
	local closestDistance =
		math.huge


	for soul, body
		in pairs(SoulBodyCache) do

		if soul.Parent
			and body.Parent then

			local distance =
				(
					root.Position
					- body.Position
				).Magnitude

			if distance
				< closestDistance then

				closestDistance =
					distance

				closestBody =
					body

			end

		else

			SoulBodyCache[soul] =
				nil

		end
	end

	return closestBody
end


-- ==========================================
-- Dynamic Dungeon Runtime
-- ==========================================

local function GetRaidRuntime()

	local raidDungeon =
		workspace:FindFirstChild(
			"RaidDungeon"
		)

	if not raidDungeon then
		return nil
	end

	return raidDungeon:FindFirstChild(
		"Runtime"
	)
end


-- ==========================================
-- Dungeon Cache
-- ==========================================

local RoomEnemyCache = {}
local RoomPadCache = {}

local HookedRaidRuntime = nil

local DungeonConnections = {}


-- ==========================================
-- Disconnect Old Dungeon Connections
-- ==========================================

local function ClearDungeonConnections()

	for _, connection
		in ipairs(DungeonConnections) do

		if connection
			and connection.Connected then

			connection:Disconnect()

		end
	end

	table.clear(
		DungeonConnections
	)

end


-- ==========================================
-- Cache Dungeon Room
-- ==========================================

local function CacheRoomParts(room)

	local function CheckDescendant(instance)

		-- =========================
		-- Continue Pad
		-- =========================

		if instance.Name == "ContinuePad"
			and instance:IsA("BasePart") then

			RoomPadCache[room] =
				instance

			return
		end


		-- =========================
		-- Enemy HumanoidRootPart
		-- =========================

		if instance.Name
				== "HumanoidRootPart"
			and instance:IsA("BasePart") then

			local raidEnemy =
				instance:FindFirstAncestor(
					"RaidEnemy"
				)

			if raidEnemy then

				RoomEnemyCache[room] =
					instance

			end
		end
	end


	-- =========================
	-- Existing descendants
	-- =========================

	for _, descendant
		in ipairs(
			room:GetDescendants()
		) do

		CheckDescendant(
			descendant
		)

	end


	-- =========================
	-- Future descendants
	-- =========================

	local connection =
		room.DescendantAdded:Connect(
			function(descendant)

				CheckDescendant(
					descendant
				)

			end
		)

	table.insert(
		DungeonConnections,
		connection
	)

end


-- ==========================================
-- Hook Dungeon Runtime
-- ==========================================

local function EnsureRaidRuntimeHooked()

	local RaidRuntime =
		GetRaidRuntime()

	if RaidRuntime
		== HookedRaidRuntime then

		return RaidRuntime

	end


	-- Runtime changed.
	-- Remove all old room listeners.

	ClearDungeonConnections()

	RoomEnemyCache = {}
	RoomPadCache = {}

	HookedRaidRuntime =
		RaidRuntime


	if not RaidRuntime then
		return nil
	end


	-- =========================
	-- Existing rooms
	-- =========================

	for _, room
		in ipairs(
			RaidRuntime:GetChildren()
		) do

		CacheRoomParts(
			room
		)

	end


	-- =========================
	-- New rooms
	-- =========================

	local addedConnection =
		RaidRuntime.ChildAdded:Connect(
			function(room)

				CacheRoomParts(
					room
				)

			end
		)

	table.insert(
		DungeonConnections,
		addedConnection
	)


	-- =========================
	-- Removed rooms
	-- =========================

	local removedConnection =
		RaidRuntime.ChildRemoved:Connect(
			function(room)

				RoomEnemyCache[room] =
					nil

				RoomPadCache[room] =
					nil

			end
		)

	table.insert(
		DungeonConnections,
		removedConnection
	)


	return RaidRuntime
end


-- ==========================================
-- Get Current Dungeon Enemy
-- ==========================================

local function GetCurrentRaidEnemy()

	local RaidRuntime =
		EnsureRaidRuntimeHooked()

	if not RaidRuntime then
		return nil
	end

	local bestEnemy = nil
	local bestFloor = -1


	for room, enemyRoot
		in pairs(RoomEnemyCache) do

		if room.Parent
			and enemyRoot.Parent then

			local floorNumber =
				tonumber(
					string.match(
						room.Name,
						"_Floor_(%d+)"
					)
				)

			if floorNumber
				and floorNumber
					> bestFloor then

				bestFloor =
					floorNumber

				bestEnemy =
					enemyRoot

			end

		else

			RoomEnemyCache[room] =
				nil

		end
	end


	return bestEnemy
end


-- ==========================================
-- Get Current Continue Pad
-- ==========================================

local function GetCurrentContinuePad()

	local RaidRuntime =
		EnsureRaidRuntimeHooked()

	if not RaidRuntime then
		return nil
	end

	local bestPad = nil
	local bestPrep = -1


	for room, pad
		in pairs(RoomPadCache) do

		if room.Parent
			and pad.Parent then

			local prepNumber =
				tonumber(
					string.match(
						room.Name,
						"_Prep_(%d+)"
					)
				)

			if prepNumber
				and prepNumber
					> bestPrep then

				bestPrep =
					prepNumber

				bestPad =
					pad

			end

		else

			RoomPadCache[room] =
				nil

		end
	end


	return bestPad
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


		if #SelectedTitanUpgrades
			== 0 then

			task.wait(0.1)
			continue

		end


		for _, upgradeName
			in ipairs(
				SelectedTitanUpgrades
			) do

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


		if #SelectedFloraUpgrades
			== 0 then

			task.wait(0.1)
			continue

		end


		for _, upgradeName
			in ipairs(
				SelectedFloraUpgrades
			) do

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


		if #SelectedMasteryUpgrades
			== 0 then

			task.wait(0.1)
			continue

		end


		for _, upgradeName
			in ipairs(
				SelectedMasteryUpgrades
			) do

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


		if #SelectedSoulUpgrades
			== 0 then

			task.wait(0.1)
			continue

		end


		for _, upgradeName
			in ipairs(
				SelectedSoulUpgrades
			) do

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

			MoveToPosition(
				soul.Position
			)

			task.wait(0.25)

		else

			task.wait(0.5)

		end
	end
end)


-- ==========================================
-- Auto Dungeon Loop
-- ==========================================

task.spawn(function()

	local LastPad = nil

	local WaitingForEnemy =
		false

	local PadReachedTime =
		0


	while ScriptRunning do

		-- =========================
		-- Dungeon OFF
		-- =========================

		if not AutoDungeonEnabled then

			LastPad = nil
			WaitingForEnemy = false

			task.wait(0.2)

			continue

		end


		-- =========================
		-- Enemy always has priority
		-- =========================

		local enemyRoot =
			GetCurrentRaidEnemy()


		if enemyRoot then

			WaitingForEnemy =
				false

			LastPad =
				nil


			MoveToPosition(
				enemyRoot.Position
			)

			task.wait(0.2)

			continue

		end


		-- =========================
		-- Waiting after stepping
		-- onto the pad
		-- =========================

		if WaitingForEnemy then

			-- Give the game several
			-- seconds to spawn RaidEnemy.

			if os.clock()
					- PadReachedTime
				< 5 then

				task.wait(0.2)

				continue

			end


			WaitingForEnemy =
				false

		end


		-- =========================
		-- Look for continue pad
		-- =========================

		local continuePad =
			GetCurrentContinuePad()


		if continuePad
			and continuePad
				~= LastPad then


			local character =
				player.Character


			local root =
				character
				and character:FindFirstChild(
					"HumanoidRootPart"
				)


			if root then

				local distance =
					(
						root.Position
						- continuePad.Position
					).Magnitude


				-- =========================
				-- Walk toward pad
				-- =========================

				if distance > 4 then

					MoveToPosition(
						continuePad.Position
					)


				-- =========================
				-- Reached pad
				-- =========================

				else

					LastPad =
						continuePad

					WaitingForEnemy =
						true

					PadReachedTime =
						os.clock()

				end
			end
		end


		task.wait(0.2)
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

			-- Consume incoming event.

		end
	)

end
