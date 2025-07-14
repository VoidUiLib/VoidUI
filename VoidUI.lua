-- VoidUI v0.2 (Dark Void Theme)
-- Base UI Lib for Roblox executor scripts
-- GitHub: https://github.com/VoidUiLib/VoidUI

local VoidUI = {}
VoidUI.__index = VoidUI

local UserInputService = game:GetService("UserInputService")

-- Helper function: clamp
local function clamp(n, min, max)
	return math.min(math.max(n, min), max)
end

-- Create main window
function VoidUI:CreateWindow(title)
	local self = setmetatable({}, VoidUI)

	-- Main container
	self.Window = Instance.new("Frame")
	self.Window.Name = "VoidUIWindow"
	self.Window.Size = UDim2.new(0, 520, 0, 360)
	self.Window.Position = UDim2.new(0.5, -260, 0.5, -180)
	self.Window.BackgroundColor3 = Color3.fromRGB(25, 0, 55)
	self.Window.BorderSizePixel = 0
	self.Window.AnchorPoint = Vector2.new(0,0)
	self.Window.Active = true
	self.Window.Draggable = true
	self.Window.Parent = game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	-- Title bar
	self.TitleBar = Instance.new("TextLabel")
	self.TitleBar.Name = "TitleBar"
	self.TitleBar.Size = UDim2.new(1, 0, 0, 28)
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.TextColor3 = Color3.fromRGB(170, 85, 255)
	self.TitleBar.Font = Enum.Font.GothamBold
	self.TitleBar.TextSize = 18
	self.TitleBar.Text = title or "VoidUI"
	self.TitleBar.Parent = self.Window

	-- Side Tab Selector Frame
	self.TabSelector = Instance.new("Frame")
	self.TabSelector.Name = "TabSelector"
	self.TabSelector.Size = UDim2.new(0, 140, 1, -28)
	self.TabSelector.Position = UDim2.new(0, 0, 0, 28)
	self.TabSelector.BackgroundColor3 = Color3.fromRGB(15, 0, 45)
	self.TabSelector.BorderSizePixel = 0
	self.TabSelector.Parent = self.Window

	-- ScrollingFrame for tabs (for future scalability)
	self.TabList = Instance.new("ScrollingFrame")
	self.TabList.Name = "TabList"
	self.TabList.Size = UDim2.new(1, 0, 1, 0)
	self.TabList.BackgroundTransparency = 1
	self.TabList.BorderSizePixel = 0
	self.TabList.ScrollBarThickness = 4
	self.TabList.Parent = self.TabSelector
	self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y

	-- Container for tab content pages
	self.ContentHolder = Instance.new("Frame")
	self.ContentHolder.Name = "ContentHolder"
	self.ContentHolder.Size = UDim2.new(1, -140, 1, -28)
	self.ContentHolder.Position = UDim2.new(0, 140, 0, 28)
	self.ContentHolder.BackgroundColor3 = Color3.fromRGB(20, 0, 55)
	self.ContentHolder.BorderSizePixel = 0
	self.ContentHolder.Parent = self.Window

	-- Made by label (bottom left)
	self.MadeBy = Instance.new("TextLabel")
	self.MadeBy.Name = "MadeBy"
	self.MadeBy.Size = UDim2.new(0, 140, 0, 18)
	self.MadeBy.Position = UDim2.new(0, 0, 1, -18)
	self.MadeBy.BackgroundTransparency = 1
	self.MadeBy.Font = Enum.Font.Gotham
	self.MadeBy.TextSize = 14
	self.MadeBy.TextColor3 = Color3.fromRGB(150, 80, 220)
	self.MadeBy.Text = "Made by VoidUi Dev 🖤💜"
	self.MadeBy.TextXAlignment = Enum.TextXAlignment.Center
	self.MadeBy.Parent = self.Window

	-- Return window button (fixed)
	self.ReturnCenterBtn = Instance.new("TextButton")
	self.ReturnCenterBtn.Name = "ReturnCenterBtn"
	self.ReturnCenterBtn.Size = UDim2.new(0, 140, 0, 24)
	self.ReturnCenterBtn.Position = UDim2.new(0, 0, 0, 0)
	self.ReturnCenterBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
	self.ReturnCenterBtn.BorderSizePixel = 0
	self.ReturnCenterBtn.Font = Enum.Font.GothamBold
	self.ReturnCenterBtn.TextSize = 16
	self.ReturnCenterBtn.TextColor3 = Color3.fromRGB(170, 85, 255)
	self.ReturnCenterBtn.Text = "Return Window to Center"
	self.ReturnCenterBtn.Parent = self.Window

	self.ReturnCenterBtn.MouseButton1Click:Connect(function()
		self.Window.Position = UDim2.new(0.5, -self.Window.AbsoluteSize.X/2, 0.5, -self.Window.AbsoluteSize.Y/2)
	end)

	-- State variables
	self.Tabs = {}
	self.ActiveTab = nil

	return self
end

-- Add tab, returns tab object with Content frame for adding UI elements
function VoidUI:AddTab(name)
	assert(type(name) == "string", "Tab name must be a string")

	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "_TabButton"
	tabButton.Size = UDim2.new(1, 0, 0, 32)
	tabButton.BackgroundColor3 = Color3.fromRGB(30, 0, 75)
	tabButton.BorderSizePixel = 0
	tabButton.Font = Enum.Font.GothamBold
	tabButton.TextSize = 16
	tabButton.TextColor3 = Color3.fromRGB(170, 85, 255)
	tabButton.Text = name
	tabButton.Parent = self.TabList

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = name .. "_Content"
	contentFrame.Size = UDim2.new(1, 0, 1, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = false
	contentFrame.Parent = self.ContentHolder

	local tabData = {
		name = name,
		button = tabButton,
		content = contentFrame,
		collapsed = false,
	}

	self.Tabs[#self.Tabs + 1] = tabData

	-- Resize canvas for scrolling if needed
	self.TabList.CanvasSize = UDim2.new(0, 0, 0, #self.Tabs * 32)

	-- Click handler for tab selection and collapsing
	tabButton.MouseButton1Click:Connect(function()
		if self.ActiveTab == tabData then
			-- Collapse or expand
			tabData.collapsed = not tabData.collapsed
			tabData.content.Visible = not tabData.collapsed
			tabButton.BackgroundColor3 = tabData.collapsed and Color3.fromRGB(20, 0, 50) or Color3.fromRGB(30, 0, 75)
		else
			self:SelectTab(name)
		end
	end)

	-- Auto-select first tab added
	if not self.ActiveTab then
		self:SelectTab(name)
	end

	return tabData
end

-- Select tab by name
function VoidUI:SelectTab(name)
	for _, tab in ipairs(self.Tabs) do
		if tab.name == name then
			-- Show selected tab
			tab.content.Visible = true
			tab.button.BackgroundColor3 = Color3.fromRGB(90, 30, 150) -- Highlight
			self.ActiveTab = tab
		else
			tab.content.Visible = false
			tab.button.BackgroundColor3 = Color3.fromRGB(30, 0, 75)
			tab.collapsed = false
		end
	end
end

-- General purpose RGB color picker creator
-- Params:
--   parent (Instance): Parent UI element to contain the picker
--   defaultColor (Color3): initial color (optional)
-- Returns:
--   pickerFrame (Frame): the UI container
--   getColor (function): function returning current Color3 and hex string
--   okButton (TextButton): the OK button instance (optional, can be hidden or reused)
function VoidUI.CreateRGBPicker(parent, defaultColor)
	defaultColor = defaultColor or Color3.fromRGB(128, 128, 128)

	local pickerFrame = Instance.new("Frame")
	pickerFrame.Size = UDim2.new(1, 0, 0, 160)
	pickerFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 55)
	pickerFrame.BorderSizePixel = 0
	pickerFrame.Parent = parent

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 24)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(170, 85, 255)
	title.Text = "Select Color"
	title.Parent = pickerFrame

	local function createColorSlider(labelText, posY, defaultValue)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 20, 0, 24)
		label.Position = UDim2.new(0, 10, 0, posY)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextSize = 18
		label.TextColor3 = Color3.fromRGB(170, 85, 255)
		label.Text = labelText
		label.Parent = pickerFrame

		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(0.7, -30, 0, 24)
		sliderFrame.Position = UDim2.new(0, 40, 0, posY)
		sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
		sliderFrame.BorderSizePixel = 0
		sliderFrame.Parent = pickerFrame

		local fill = Instance.new("Frame")
		fill.Name = "Fill"
		fill.Size = UDim2.new(defaultValue / 255, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
		fill.BorderSizePixel = 0
		fill.Parent = sliderFrame

		local sliderBtn = Instance.new("TextButton")
		sliderBtn.Size = UDim2.new(0, 16, 1, 0)
		sliderBtn.Position = UDim2.new(defaultValue / 255, -8, 0, 0)
		sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sliderBtn.BorderSizePixel = 0
		sliderBtn.AutoButtonColor = false
		sliderBtn.Parent = sliderFrame

		local inputBox = Instance.new("TextBox")
		inputBox.Size = UDim2.new(0, 50, 0, 24)
		inputBox.Position = UDim2.new(0.75, 0, 0, posY)
		inputBox.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
		inputBox.BorderSizePixel = 0
		inputBox.Font = Enum.Font.Gotham
		inputBox.TextSize = 16
		inputBox.TextColor3 = Color3.fromRGB(170, 85, 255)
		inputBox.Text = tostring(defaultValue)
		inputBox.ClearTextOnFocus = false
		inputBox.Parent = pickerFrame

		return {
			label = label,
			sliderFrame = sliderFrame,
			fill = fill,
			sliderBtn = sliderBtn,
			inputBox = inputBox,
			value = defaultValue
		}
	end

	local rSlider = createColorSlider("R:", 40, defaultColor.R * 255)
	local gSlider = createColorSlider("G:", 70, defaultColor.G * 255)
	local bSlider = createColorSlider("B:", 100, defaultColor.B * 255)

	local previewBox = Instance.new("Frame")
	previewBox.Size = UDim2.new(0, 80, 0, 80)
	previewBox.Position = UDim2.new(1, -90, 0, 40)
	previewBox.BackgroundColor3 = defaultColor
	previewBox.BorderSizePixel = 0
	previewBox.Parent = pickerFrame

	local hexLabel = Instance.new("TextLabel")
	hexLabel.Size = UDim2.new(0, 80, 0, 24)
	hexLabel.Position = UDim2.new(1, -90, 0, 125)
	hexLabel.BackgroundTransparency = 1
	hexLabel.Font = Enum.Font.GothamBold
	hexLabel.TextSize = 18
	hexLabel.TextColor3 = Color3.fromRGB(170, 85, 255)
	hexLabel.Text = "#000000"
	hexLabel.TextXAlignment = Enum.TextXAlignment.Center
	hexLabel.Parent = pickerFrame

	local okButton = Instance.new("TextButton")
	okButton.Size = UDim2.new(0, 60, 0, 30)
	okButton.Position = UDim2.new(1, -80, 1, -40)
	okButton.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
	okButton.BorderSizePixel = 0
	okButton.Font = Enum.Font.GothamBold
	okButton.TextColor3 = Color3.fromRGB(170, 85, 255)
	okButton.Text = "OK"
	okButton.Parent = pickerFrame

	local function updateSlider(slider, val)
		val = clamp(val, 0, 255)
		slider.value = val
		slider.fill.Size = UDim2.new(val / 255, 0, 1, 0)
		slider.sliderBtn.Position = UDim2.new(val / 255, -8, 0, 0)
		slider.inputBox.Text = tostring(math.floor(val))
	end

	local function rgbToHex(r, g, b)
		local function toHex(n)
			return string.format("%02X", n)
		end
		return "#" .. toHex(r) .. toHex(g) .. toHex(b)
	end

	local function updatePreview()
		local r, g, b = rSlider.value, gSlider.value, bSlider.value
		previewBox.BackgroundColor3 = Color3.fromRGB(r, g, b)
		hexLabel.Text = rgbToHex(r, g, b)
	end

	local draggingSlider = nil

	local function sliderInputChanged(input)
		if draggingSlider then
			local sliderPos = draggingSlider.sliderFrame.AbsolutePosition
			local sliderSize = draggingSlider.sliderFrame.AbsoluteSize
			local x = clamp(input.Position.X, sliderPos.X, sliderPos.X + sliderSize.X)
			local val = ((x - sliderPos.X) / sliderSize.X) * 255
			updateSlider(draggingSlider, val)
			updatePreview()
		end
    end
