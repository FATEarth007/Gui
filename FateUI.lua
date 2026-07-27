local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("AutomationGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutomationGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(620, 390)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui



-- Top bar

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "FatE Hub"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(45, 45)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(220, 220, 225)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.fromOffset(45, 45)
minimizeButton.Position = UDim2.new(1, -90, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 225)
minimizeButton.TextSize = 22
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = topBar


local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

screenGui.Enabled = true
mainFrame.Visible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Left navigation

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 170, 1, -45)
sidebar.Position = UDim2.fromOffset(0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(29, 29, 35)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local navigation = Instance.new("ScrollingFrame")
navigation.Name = "Navigation"
navigation.Size = UDim2.new(1, 0, 1, 0)
navigation.BackgroundTransparency = 1
navigation.BorderSizePixel = 0
navigation.ScrollBarThickness = 4
navigation.ScrollBarImageColor3 = Color3.fromRGB(105, 105, 120)
navigation.CanvasSize = UDim2.fromOffset(0, 0)
navigation.AutomaticCanvasSize = Enum.AutomaticSize.Y
navigation.ScrollingDirection = Enum.ScrollingDirection.Y
navigation.Parent = sidebar

local navigationPadding = Instance.new("UIPadding")
navigationPadding.PaddingTop = UDim.new(0, 10)
navigationPadding.PaddingBottom = UDim.new(0, 10)
navigationPadding.PaddingLeft = UDim.new(0, 10)
navigationPadding.PaddingRight = UDim.new(0, 10)
navigationPadding.Parent = navigation

local navigationLayout = Instance.new("UIListLayout")
navigationLayout.Padding = UDim.new(0, 8)
navigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
navigationLayout.Parent = navigation

-- Right content container

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -170, 1, -45)
contentContainer.Position = UDim2.fromOffset(170, 45)
contentContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame

local minimized = false
local expandedSize = UDim2.fromOffset(620, 390)
local minimizedSize = UDim2.fromOffset(620, 45)

local function setMinimized(shouldMinimize)
	minimized = shouldMinimize

	if minimized then
		sidebar.Visible = false
		contentContainer.Visible = false
		mainFrame.Size = minimizedSize
		minimizeButton.Text = "+"
	else
		sidebar.Visible = true
		contentContainer.Visible = true
		mainFrame.Size = expandedSize
		minimizeButton.Text = "−"
	end
end

minimizeButton.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)




local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 18)
contentPadding.PaddingBottom = UDim.new(0, 18)
contentPadding.PaddingLeft = UDim.new(0, 20)
contentPadding.PaddingRight = UDim.new(0, 20)
contentPadding.Parent = contentContainer

local pages = {}
local navigationButtons = {}
local currentPage = nil

local normalButtonColor = Color3.fromRGB(40, 40, 48)
local selectedButtonColor = Color3.fromRGB(75, 95, 180)

local function createPage(pageName, headingText)
	local page = Instance.new("ScrollingFrame")
	page.Name = pageName
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Color3.fromRGB(105, 105, 120)
	page.CanvasSize = UDim2.fromOffset(0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = contentContainer

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Padding = UDim.new(0, 12)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Parent = page

	local heading = Instance.new("TextLabel")
	heading.Name = "Heading"
	heading.Size = UDim2.new(1, -10, 0, 35)
	heading.BackgroundTransparency = 1
	heading.Text = headingText
	heading.TextColor3 = Color3.fromRGB(245, 245, 250)
	heading.TextSize = 23
	heading.Font = Enum.Font.GothamBold
	heading.TextXAlignment = Enum.TextXAlignment.Left
	heading.Parent = page

	pages[pageName] = page

	return page
end

local function showPage(pageName)
	for name, page in pairs(pages) do
		page.Visible = name == pageName
	end

	for name, button in pairs(navigationButtons) do
		if name == pageName then
			button.BackgroundColor3 = selectedButtonColor
		else
			button.BackgroundColor3 = normalButtonColor
		end
	end

	currentPage = pageName
end

local function createNavigationButton(pageName, buttonText)
	local button = Instance.new("TextButton")
	button.Name = pageName .. "Button"
	button.Size = UDim2.new(1, 0, 0, 42)
	button.BackgroundColor3 = normalButtonColor
	button.BorderSizePixel = 0
	button.Text = buttonText
	button.TextColor3 = Color3.fromRGB(230, 230, 235)
	button.TextSize = 15
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = false
	button.Parent = navigation

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 7)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		showPage(pageName)
	end)

	button.MouseEnter:Connect(function()
		if currentPage ~= pageName then
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		end
	end)

	button.MouseLeave:Connect(function()
		if currentPage ~= pageName then
			button.BackgroundColor3 = normalButtonColor
		end
	end)

	navigationButtons[pageName] = button

	return button
end

local function createSection(parent, sectionTitle)
	local section = Instance.new("Frame")
	section.Name = sectionTitle:gsub("%s+", "") .. "Section"
	section.Size = UDim2.new(1, -10, 0, 0)
	section.AutomaticSize = Enum.AutomaticSize.Y
	section.BackgroundColor3 = Color3.fromRGB(32, 32, 39)
	section.BorderSizePixel = 0
	section.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = section

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = section

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = section

	local label = Instance.new("TextLabel")
	label.Name = "SectionTitle"
	label.Size = UDim2.new(1, 0, 0, 26)
	label.BackgroundTransparency = 1
	label.Text = sectionTitle
	label.TextColor3 = Color3.fromRGB(235, 235, 240)
	label.TextSize = 17
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = section

	return section
end

local function createActionButton(parent, buttonText, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(55, 55, 66)
	button.BorderSizePixel = 0
	button.Text = buttonText
	button.TextColor3 = Color3.fromRGB(240, 240, 245)
	button.TextSize = 15
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = true
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = button

	button.MouseButton1Click:Connect(callback)

	return button
end

local function createToggle(parent, toggleText, defaultValue, callback)
	local enabled = defaultValue

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 42)
	button.BackgroundColor3 = Color3.fromRGB(55, 55, 66)
	button.BorderSizePixel = 0
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = button

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -65, 1, 0)
	label.Position = UDim2.fromOffset(12, 0)
	label.BackgroundTransparency = 1
	label.Text = toggleText
	label.TextColor3 = Color3.fromRGB(235, 235, 240)
	label.TextSize = 15
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = button

	local stateLabel = Instance.new("TextLabel")
	stateLabel.Size = UDim2.fromOffset(48, 26)
	stateLabel.Position = UDim2.new(1, -56, 0.5, -13)
	stateLabel.BorderSizePixel = 0
	stateLabel.TextSize = 12
	stateLabel.Font = Enum.Font.GothamBold
	stateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	stateLabel.Parent = button

	local stateCorner = Instance.new("UICorner")
	stateCorner.CornerRadius = UDim.new(1, 0)
	stateCorner.Parent = stateLabel

	local function updateAppearance()
		if enabled then
			stateLabel.Text = "ON"
			stateLabel.BackgroundColor3 = Color3.fromRGB(70, 150, 90)
		else
			stateLabel.Text = "OFF"
			stateLabel.BackgroundColor3 = Color3.fromRGB(130, 65, 65)
		end
	end

	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		updateAppearance()
		callback(enabled)
	end)

	updateAppearance()

	return button
end

-- Create pages

local homePage = createPage("Home", "Home")
local farmingPage = createPage("Farming", "Farming")
local upgradesPage = createPage("Upgrades", "Upgrades")
local movementPage = createPage("Movement", "Movement")
local settingsPage = createPage("Settings", "Settings")

-- Navigation buttons

createNavigationButton("Home", "Home")
createNavigationButton("Farming", "Farming")
createNavigationButton("Upgrades", "Upgrades")
createNavigationButton("Movement", "Movement")
createNavigationButton("Settings", "Settings")

-- Home content

local statusSection = createSection(homePage, "Status")

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 50)
statusText.BackgroundTransparency = 1
statusText.Text = "Select a section from the menu."
statusText.TextWrapped = true
statusText.TextColor3 = Color3.fromRGB(190, 190, 200)
statusText.TextSize = 15
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusSection

local actionsSection = createSection(homePage, "Actions")

createActionButton(actionsSection, "Start All", function()
	statusText.Text = "All automation started."
end)

createActionButton(actionsSection, "Stop All", function()
	statusText.Text = "All automation stopped."
end)

-- Farming content

local farmingSection = createSection(farmingPage, "Farming Options")

createToggle(farmingSection, "Auto Collect", false, function(enabled)
	print("Auto Collect:", enabled)
end)

createToggle(farmingSection, "Auto Sell", false, function(enabled)
	print("Auto Sell:", enabled)
end)

createToggle(farmingSection, "Auto Rebirth", false, function(enabled)
	print("Auto Rebirth:", enabled)
end)

-- Upgrades content

local upgradesSection = createSection(upgradesPage, "Upgrade Options")

createToggle(upgradesSection, "Auto Buy Upgrades", false, function(enabled)
	print("Auto Buy Upgrades:", enabled)
end)

createToggle(upgradesSection, "Buy Cheapest First", false, function(enabled)
	print("Buy Cheapest First:", enabled)
end)

createActionButton(upgradesSection, "Buy Available Upgrades", function()
	print("Buying available upgrades")
end)

-- Movement content

local movementSection = createSection(movementPage, "Movement Options")

createActionButton(movementSection, "Return to Spawn", function()
	print("Return to spawn")
end)

createActionButton(movementSection, "Go to Shop", function()
	print("Go to shop")
end)

createActionButton(movementSection, "Go to Upgrade Area", function()
	print("Go to upgrade area")
end)

-- Settings content

local settingsSection = createSection(settingsPage, "Interface")

createToggle(settingsSection, "Show Status Messages", true, function(enabled)
	print("Status messages:", enabled)
end)

createActionButton(settingsSection, "Hide Interface", function()
	mainFrame.Visible = false
end)

-- Draggable top bar

local dragging = false
local dragStart
local startingPosition
local dragInput

local function updateDrag(input)
	if not dragStart or not startingPosition then
		return
	end

	local delta = input.Position - dragStart

	mainFrame.Position = UDim2.new(
		startingPosition.X.Scale,
		startingPosition.X.Offset + delta.X,
		startingPosition.Y.Scale,
		startingPosition.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startingPosition = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateDrag(input)
	end
end)

showPage("Home")