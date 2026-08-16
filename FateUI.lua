local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Library = {}

local Theme = {
	Background = Color3.fromRGB(18, 18, 22),
	TopBar = Color3.fromRGB(24, 24, 30),
	Sidebar = Color3.fromRGB(21, 21, 26),
	Section = Color3.fromRGB(28, 28, 34),
	Element = Color3.fromRGB(35, 35, 42),
	ElementHover = Color3.fromRGB(43, 43, 52),
	Accent = Color3.fromRGB(190, 35, 35),
	Text = Color3.fromRGB(240, 240, 240),
	MutedText = Color3.fromRGB(170, 170, 175),
}

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = parent

	return corner
end

local function createPadding(parent, amount)
	local padding = Instance.new("UIPadding")

	padding.PaddingTop = UDim.new(0, amount)
	padding.PaddingBottom = UDim.new(0, amount)
	padding.PaddingLeft = UDim.new(0, amount)
	padding.PaddingRight = UDim.new(0, amount)

	padding.Parent = parent

	return padding
end

local function makeDraggable(frame, dragHandle)
	local dragging = false
	local dragStart
	local startPosition

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = frame.Position
		end
	end)

	dragHandle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then

			return
		end

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

function Library:CreateWindow(options)
	options = options or {}

	local titleText = options.Title or "Fate UI"
	local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local oldGui = playerGui:FindFirstChild("FateUI")

	if oldGui then
		oldGui:Destroy()
	end

	-- =========================
	-- Screen GUI
	-- =========================

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FateUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	-- =========================
	-- Main Window
	-- =========================

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.fromOffset(680, 440)
	mainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
	mainFrame.BackgroundColor3 = Theme.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	createCorner(mainFrame, 9)

	-- =========================
	-- Top Bar
	-- =========================

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 42)
	topBar.BackgroundColor3 = Theme.TopBar
	topBar.BorderSizePixel = 0
	topBar.Active = true
	topBar.Parent = mainFrame

	createCorner(topBar, 9)

	local topBarCover = Instance.new("Frame")
	topBarCover.Size = UDim2.new(1, 0, 0, 10)
	topBarCover.Position = UDim2.new(0, 0, 1, -10)
	topBarCover.BackgroundColor3 = Theme.TopBar
	topBarCover.BorderSizePixel = 0
	topBarCover.Parent = topBar

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.fromOffset(14, 0)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Theme.Text
	title.TextSize = 17
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topBar

	-- =========================
	-- Minimize
	-- =========================

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.fromOffset(38, 30)
	minimizeButton.Position = UDim2.new(1, -80, 0, 6)
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Text = "—"
	minimizeButton.TextColor3 = Theme.MutedText
	minimizeButton.TextSize = 18
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Parent = topBar

	-- =========================
	-- Close
	-- =========================

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.fromOffset(38, 30)
	closeButton.Position = UDim2.new(1, -42, 0, 6)
	closeButton.BackgroundTransparency = 1
	closeButton.Text = "×"
	closeButton.TextColor3 = Theme.MutedText
	closeButton.TextSize = 23
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = topBar

	-- =========================
	-- Sidebar
	-- =========================

	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 150, 1, -42)
	sidebar.Position = UDim2.fromOffset(0, 42)
	sidebar.BackgroundColor3 = Theme.Sidebar
	sidebar.BorderSizePixel = 0
	sidebar.ScrollBarThickness = 3
	sidebar.ScrollBarImageColor3 = Theme.Accent
	sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.CanvasSize = UDim2.new()
	sidebar.Parent = mainFrame

	local tabList = Instance.new("UIListLayout")
	tabList.Padding = UDim.new(0, 6)
	tabList.SortOrder = Enum.SortOrder.LayoutOrder
	tabList.Parent = sidebar

	createPadding(sidebar, 10)

	-- =========================
	-- Page Container
	-- =========================

	local pageContainer = Instance.new("Frame")
	pageContainer.Name = "PageContainer"
	pageContainer.Size = UDim2.new(1, -150, 1, -42)
	pageContainer.Position = UDim2.fromOffset(150, 42)
	pageContainer.BackgroundTransparency = 1
	pageContainer.ClipsDescendants = true
	pageContainer.Parent = mainFrame

	-- =========================
	-- Window Object
	-- =========================

	local Window = {}

	Window.ScreenGui = screenGui
	Window.MainFrame = mainFrame
	Window.Sidebar = sidebar
	Window.PageContainer = pageContainer

	local pages = {}
	local tabButtons = {}
	local firstTab = true
	local minimized = false

	-- =========================
	-- Page Switching
	-- =========================

	local function showPage(selectedPage, selectedButton)
		for _, page in ipairs(pages) do
			page.Visible = page == selectedPage
		end

		for _, button in ipairs(tabButtons) do
			if button == selectedButton then
				button.BackgroundColor3 = Theme.Accent
			else
				button.BackgroundColor3 = Theme.Element
			end
		end
	end

	-- =========================
	-- Create Tab
	-- =========================

	function Window:CreateTab(tabName)
		local tabButton = Instance.new("TextButton")
		tabButton.Name = tabName .. "TabButton"
		tabButton.Size = UDim2.new(1, 0, 0, 38)
		tabButton.BackgroundColor3 = Theme.Element
		tabButton.BorderSizePixel = 0
		tabButton.Text = tabName
		tabButton.TextColor3 = Theme.Text
		tabButton.TextSize = 14
		tabButton.Font = Enum.Font.GothamMedium
		tabButton.AutoButtonColor = false
		tabButton.Parent = sidebar

		createCorner(tabButton, 6)

		tabButton.MouseEnter:Connect(function()
			if tabButton.BackgroundColor3 ~= Theme.Accent then
				tabButton.BackgroundColor3 = Theme.ElementHover
			end
		end)

		tabButton.MouseLeave:Connect(function()
			local selected = false

			for _, pageButton in ipairs(tabButtons) do
				if pageButton == tabButton then
					for index, button in ipairs(tabButtons) do
						if button == tabButton and pages[index].Visible then
							selected = true
							break
						end
					end
				end
			end

			if selected then
				tabButton.BackgroundColor3 = Theme.Accent
			else
				tabButton.BackgroundColor3 = Theme.Element
			end
		end)

		local page = Instance.new("ScrollingFrame")
		page.Name = tabName .. "Page"
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 3
		page.ScrollBarImageColor3 = Theme.Accent
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new()
		page.Visible = false
		page.Parent = pageContainer

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 10)
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Parent = page

		createPadding(page, 12)

		table.insert(pages, page)
		table.insert(tabButtons, tabButton)

		tabButton.MouseButton1Click:Connect(function()
			showPage(page, tabButton)
		end)

		if firstTab then
			firstTab = false
			showPage(page, tabButton)
		end

		-- =========================
		-- Tab Object
		-- =========================

		local Tab = {}

		Tab.Page = page
		Tab.Button = tabButton

		-- =========================
		-- Create Section
		-- =========================

		function Tab:CreateSection(sectionName)
			local section = Instance.new("Frame")
			section.Name = sectionName .. "Section"
			section.Size = UDim2.new(1, -4, 0, 0)
			section.AutomaticSize = Enum.AutomaticSize.Y
			section.BackgroundColor3 = Theme.Section
			section.BorderSizePixel = 0
			section.Parent = page

			createCorner(section, 7)
			createPadding(section, 10)

			local sectionLayout = Instance.new("UIListLayout")
			sectionLayout.Padding = UDim.new(0, 8)
			sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
			sectionLayout.Parent = section

			local sectionTitle = Instance.new("TextLabel")
			sectionTitle.Name = "SectionTitle"
			sectionTitle.Size = UDim2.new(1, 0, 0, 24)
			sectionTitle.BackgroundTransparency = 1
			sectionTitle.Text = sectionName
			sectionTitle.TextColor3 = Theme.Text
			sectionTitle.TextSize = 14
			sectionTitle.Font = Enum.Font.GothamBold
			sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			sectionTitle.Parent = section

			-- =========================
			-- Section Object
			-- =========================

			local Section = {}

			Section.Frame = section

			-- =========================
			-- Button
			-- =========================

			function Section:CreateButton(buttonOptions)
				buttonOptions = buttonOptions or {}

				local callback =
					buttonOptions.Callback or function()
					end

				local button = Instance.new("TextButton")
				button.Name = buttonOptions.Name or "Button"
				button.Size = UDim2.new(1, 0, 0, 38)
				button.BackgroundColor3 = Theme.Element
				button.BorderSizePixel = 0
				button.Text = buttonOptions.Name or "Button"
				button.TextColor3 = Theme.Text
				button.TextSize = 14
				button.Font = Enum.Font.GothamMedium
				button.AutoButtonColor = false
				button.Parent = section

				createCorner(button, 6)

				button.MouseEnter:Connect(function()
					button.BackgroundColor3 = Theme.ElementHover
				end)

				button.MouseLeave:Connect(function()
					button.BackgroundColor3 = Theme.Element
				end)

				button.MouseButton1Click:Connect(function()
					local success, err = pcall(callback)

					if not success then
						warn("[FateUI Button Error]", err)
					end
				end)

				local Button = {}

				function Button:SetText(text)
					button.Text = tostring(text)
				end

				function Button:SetVisible(visible)
					button.Visible = visible
				end

				Button.Instance = button

				return Button
			end

			-- =========================
			-- Toggle
			-- =========================

			function Section:CreateToggle(toggleOptions)
				toggleOptions = toggleOptions or {}

				local callback =
					toggleOptions.Callback or function()
					end

				local enabled = toggleOptions.Default == true

				local toggleButton = Instance.new("TextButton")
				toggleButton.Name = toggleOptions.Name or "Toggle"
				toggleButton.Size = UDim2.new(1, 0, 0, 38)
				toggleButton.BackgroundColor3 = Theme.Element
				toggleButton.BorderSizePixel = 0
				toggleButton.Text = ""
				toggleButton.AutoButtonColor = false
				toggleButton.Parent = section

				createCorner(toggleButton, 6)

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -58, 1, 0)
				label.Position = UDim2.fromOffset(12, 0)
				label.BackgroundTransparency = 1
				label.Text = toggleOptions.Name or "Toggle"
				label.TextColor3 = Theme.Text
				label.TextSize = 14
				label.Font = Enum.Font.GothamMedium
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = toggleButton

				local indicator = Instance.new("Frame")
				indicator.Size = UDim2.fromOffset(34, 18)
				indicator.Position = UDim2.new(1, -44, 0.5, -9)
				indicator.BorderSizePixel = 0
				indicator.Parent = toggleButton

				createCorner(indicator, 9)

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(14, 14)
				knob.Position = UDim2.fromOffset(2, 2)
				knob.BackgroundColor3 = Theme.Text
				knob.BorderSizePixel = 0
				knob.Parent = indicator

				createCorner(knob, 7)

				local function update()
					if enabled then
						indicator.BackgroundColor3 = Theme.Accent
						knob.Position = UDim2.fromOffset(18, 2)
					else
						indicator.BackgroundColor3 =
							Color3.fromRGB(70, 70, 78)

						knob.Position = UDim2.fromOffset(2, 2)
					end
				end

				local function setValue(value, fireCallback)
					enabled = value == true

					update()

					if fireCallback then
						local success, err =
							pcall(callback, enabled)

						if not success then
							warn(
								"[FateUI Toggle Error]",
								err
							)
						end
					end
				end

				toggleButton.MouseButton1Click:Connect(function()
					setValue(not enabled, true)
				end)

				update()

				local Toggle = {}

				function Toggle:Set(value)
					setValue(value, true)
				end

				function Toggle:Get()
					return enabled
				end

				function Toggle:SetText(text)
					label.Text = tostring(text)
				end

				Toggle.Instance = toggleButton

				return Toggle
			end

			-- =========================
			-- Dropdown
			-- =========================

function Section:CreateDropdown(dropdownOptions)
	dropdownOptions = dropdownOptions or {}

	local name = dropdownOptions.Name or "Dropdown"
	local options = dropdownOptions.Options or {}
	local multi = dropdownOptions.Multi == true
	local callback = dropdownOptions.Callback or function() end

	local selected = {}
	local open = false
	local optionButtons = {}

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = name .. "Dropdown"
	dropdownFrame.Size = UDim2.new(1, 0, 0, 38)
	dropdownFrame.BackgroundColor3 = Theme.Element
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = section

	createCorner(dropdownFrame, 6)

	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(1, 0, 0, 38)
	dropdownButton.Position = UDim2.fromOffset(0, 0)
	dropdownButton.BackgroundTransparency = 1
	dropdownButton.Text = name .. " ▼"
	dropdownButton.TextColor3 = Theme.Text
	dropdownButton.TextSize = 14
	dropdownButton.Font = Enum.Font.GothamMedium
	dropdownButton.Parent = dropdownFrame

	local optionsFrame = Instance.new("Frame")
	optionsFrame.Name = "Options"
	optionsFrame.Position = UDim2.fromOffset(0, 42)
	optionsFrame.Size = UDim2.new(1, 0, 0, #options * 36)
	optionsFrame.BackgroundTransparency = 1
	optionsFrame.Visible = false
	optionsFrame.Parent = dropdownFrame

	local optionsLayout = Instance.new("UIListLayout")
	optionsLayout.Padding = UDim.new(0, 4)
	optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	optionsLayout.Parent = optionsFrame

	local function updateTitle()
		if #selected == 0 then
			dropdownButton.Text =
				name .. (open and " ▲" or " ▼")

		elseif multi then
			dropdownButton.Text =
				name .. " (" .. #selected .. ")"
				.. (open and " ▲" or " ▼")

		else
			dropdownButton.Text =
				name .. ": " .. selected[1]
				.. (open and " ▲" or " ▼")
		end
	end

	local function fireCallback()
		local copy = {}

		for index, value in ipairs(selected) do
			copy[index] = value
		end

		local success, err = pcall(callback, copy)

		if not success then
			warn("[FateUI Dropdown Error]", err)
		end
	end

	local function updateSize()
		if open then
			dropdownFrame.Size = UDim2.new(
				1,
				0,
				0,
				42 + (#options * 36)
			)

			optionsFrame.Visible = true
		else
			dropdownFrame.Size = UDim2.new(
				1,
				0,
				0,
				38
			)

			optionsFrame.Visible = false
		end

		updateTitle()
	end

	for _, optionName in ipairs(options) do
		local optionButton = Instance.new("TextButton")

		optionButton.Name = tostring(optionName) .. "Option"
		optionButton.Size = UDim2.new(1, 0, 0, 32)
		optionButton.BackgroundColor3 = Theme.ElementHover
		optionButton.BorderSizePixel = 0
		optionButton.Text = tostring(optionName)
		optionButton.TextColor3 = Theme.Text
		optionButton.TextSize = 13
		optionButton.Font = Enum.Font.GothamMedium
		optionButton.Parent = optionsFrame

		createCorner(optionButton, 5)

		optionButtons[optionName] = optionButton

		optionButton.MouseButton1Click:Connect(function()
			if multi then
				local foundIndex

				for index, value in ipairs(selected) do
					if value == optionName then
						foundIndex = index
						break
					end
				end

				if foundIndex then
					table.remove(selected, foundIndex)

					optionButton.BackgroundColor3 =
						Theme.ElementHover
				else
					table.insert(selected, optionName)

					optionButton.BackgroundColor3 =
						Theme.Accent
				end

			else
				selected = {optionName}

				for _, button in pairs(optionButtons) do
					button.BackgroundColor3 =
						Theme.ElementHover
				end

				optionButton.BackgroundColor3 =
					Theme.Accent

				open = false
				updateSize()
			end

			updateTitle()
			fireCallback()
		end)
	end

	dropdownButton.MouseButton1Click:Connect(function()
		open = not open
		updateSize()
	end)

	updateSize()

	local Dropdown = {}

	function Dropdown:Get()
		local copy = {}

		for index, value in ipairs(selected) do
			copy[index] = value
		end

		return copy
	end

	function Dropdown:Set(values)
		selected = {}

		for _, button in pairs(optionButtons) do
			button.BackgroundColor3 =
				Theme.ElementHover
		end

		if multi and typeof(values) == "table" then

			for _, value in ipairs(values) do
				if optionButtons[value] then

					table.insert(selected, value)

					optionButtons[value]
						.BackgroundColor3 =
						Theme.Accent
				end
			end
		end

		updateTitle()
		fireCallback()
	end

	Dropdown.Instance = dropdownFrame

	return Dropdown
end
			-- =========================
			-- Slider
			-- =========================

			function Section:CreateSlider(sliderOptions)
				sliderOptions = sliderOptions or {}

				local name = sliderOptions.Name or "Slider"
				local min = sliderOptions.Min or 0
				local max = sliderOptions.Max or 100
				local increment =
					sliderOptions.Increment or 1

				local value =
					sliderOptions.Default ~= nil
						and sliderOptions.Default
						or min

				local callback =
					sliderOptions.Callback or function()
					end

				if max <= min then
					max = min + 1
				end

				if increment <= 0 then
					increment = 1
				end

				value = math.clamp(value, min, max)

				local sliderFrame = Instance.new("Frame")
				sliderFrame.Name = name .. "Slider"
				sliderFrame.Size = UDim2.new(1, 0, 0, 56)
				sliderFrame.BackgroundColor3 = Theme.Element
				sliderFrame.BorderSizePixel = 0
				sliderFrame.Parent = section

				createCorner(sliderFrame, 6)

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -70, 0, 26)
				label.Position = UDim2.fromOffset(10, 2)
				label.BackgroundTransparency = 1
				label.Text = name
				label.TextColor3 = Theme.Text
				label.TextSize = 14
				label.Font = Enum.Font.GothamMedium
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = sliderFrame

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Size = UDim2.fromOffset(60, 26)
				valueLabel.Position =
					UDim2.new(1, -70, 0, 2)

				valueLabel.BackgroundTransparency = 1
				valueLabel.TextColor3 = Theme.Text
				valueLabel.TextSize = 13
				valueLabel.Font = Enum.Font.GothamMedium
				valueLabel.TextXAlignment =
					Enum.TextXAlignment.Right

				valueLabel.Parent = sliderFrame

				local track = Instance.new("Frame")
				track.Name = "Track"
				track.Size = UDim2.new(1, -20, 0, 8)
				track.Position = UDim2.new(0, 10, 0, 38)
				track.BackgroundColor3 =
					Color3.fromRGB(60, 60, 68)

				track.BorderSizePixel = 0
				track.Active = true
				track.Parent = sliderFrame

				createCorner(track, 4)

				local fill = Instance.new("Frame")
				fill.Name = "Fill"
				fill.Size = UDim2.new(0, 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.BorderSizePixel = 0
				fill.Parent = track

				createCorner(fill, 4)

				local knob = Instance.new("Frame")
				knob.Name = "Knob"
				knob.Size = UDim2.fromOffset(14, 14)
				knob.AnchorPoint = Vector2.new(0.5, 0.5)
				knob.Position = UDim2.new(0, 0, 0.5, 0)
				knob.BackgroundColor3 = Theme.Text
				knob.BorderSizePixel = 0
				knob.Parent = track

				createCorner(knob, 7)

				local dragging = false

				local function roundToIncrement(number)
					local steps =
						math.floor(
							((number - min) / increment)
								+ 0.5
						)

					return min + steps * increment
				end

				local function cleanNumber(number)
					local decimals = 0
					local incrementText =
						tostring(increment)

					local decimalPosition =
						string.find(
							incrementText,
							"%."
						)

					if decimalPosition then
						decimals =
							#incrementText
							- decimalPosition
					end

					if decimals > 0 then
						return tonumber(
							string.format(
								"%."
									.. decimals
									.. "f",
								number
							)
						)
					end

					return math.floor(number + 0.5)
				end

				local function updateVisual()
					local percent =
						(value - min) / (max - min)

					fill.Size =
						UDim2.new(percent, 0, 1, 0)

					knob.Position =
						UDim2.new(
							percent,
							0,
							0.5,
							0
						)

					valueLabel.Text = tostring(value)
				end

				local function setValue(
					newValue,
					fireCallback
				)
					newValue =
						math.clamp(newValue, min, max)

					newValue =
						roundToIncrement(newValue)

					newValue =
						math.clamp(newValue, min, max)

					newValue =
						cleanNumber(newValue)

					value = newValue

					updateVisual()

					if fireCallback then
						local success, err =
							pcall(callback, value)

						if not success then
							warn(
								"[FateUI Slider Error]",
								err
							)
						end
					end
				end

				local function updateFromInput(input)
					if track.AbsoluteSize.X <= 0 then
						return
					end

					local mouseX = input.Position.X
					local startX =
						track.AbsolutePosition.X

					local width =
						track.AbsoluteSize.X

					local percent =
						math.clamp(
							(mouseX - startX)
								/ width,
							0,
							1
						)

					local newValue =
						min
						+ ((max - min) * percent)

					setValue(newValue, true)
				end

				track.InputBegan:Connect(function(input)
					if input.UserInputType
							== Enum.UserInputType.MouseButton1
						or input.UserInputType
							== Enum.UserInputType.Touch then

						dragging = true
						updateFromInput(input)
					end
				end)

				UserInputService.InputChanged:Connect(
					function(input)

						if not dragging then
							return
						end

						if input.UserInputType
								== Enum.UserInputType.MouseMovement
							or input.UserInputType
								== Enum.UserInputType.Touch then

							updateFromInput(input)
						end
					end
				)

				UserInputService.InputEnded:Connect(
					function(input)

						if input.UserInputType
								== Enum.UserInputType.MouseButton1
							or input.UserInputType
								== Enum.UserInputType.Touch then

							dragging = false
						end
					end
				)

				setValue(value, false)

				local Slider = {}

				function Slider:Set(newValue)
					setValue(newValue, true)
				end

				function Slider:Get()
					return value
				end

				function Slider:SetText(text)
					label.Text = tostring(text)
				end

				Slider.Instance = sliderFrame

				return Slider
			end

			-- =========================
			-- End Section
			-- =========================

			return Section
		end

		return Tab
	end

	-- =========================
	-- Window Methods
	-- =========================

	function Window:Show()
		mainFrame.Visible = true
	end

	function Window:Hide()
		mainFrame.Visible = false
	end

	function Window:Toggle()
		mainFrame.Visible = not mainFrame.Visible
	end

	function Window:Destroy()
		screenGui:Destroy()
	end

	function Window:SetTitle(newTitle)
		title.Text = tostring(newTitle)
	end

	-- =========================
	-- Minimize
	-- =========================

	minimizeButton.MouseButton1Click:Connect(function()
		minimized = not minimized

		sidebar.Visible = not minimized
		pageContainer.Visible = not minimized

		if minimized then
			mainFrame.Size = UDim2.fromOffset(680, 42)
			minimizeButton.Text = "+"
		else
			mainFrame.Size = UDim2.fromOffset(680, 440)
			minimizeButton.Text = "—"
		end
	end)

	-- =========================
	-- Close
	-- =========================

	closeButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
	end)

	-- =========================
	-- Toggle Key
	-- =========================

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end

		if input.KeyCode == toggleKey then
			mainFrame.Visible = not mainFrame.Visible
		end
	end)

	-- =========================
	-- Dragging
	-- =========================

	makeDraggable(mainFrame, topBar)

	return Window
end

return Library
