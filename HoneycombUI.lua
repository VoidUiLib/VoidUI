local HoneycombUI = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local function CreateCorner(radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	return c
end

local function CreatePadding(px)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, px)
	p.PaddingBottom = UDim.new(0, px)
	p.PaddingLeft = UDim.new(0, px)
	p.PaddingRight = UDim.new(0, px)
	return p
end

local function CreateLayout()
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, 6)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	return l
end

function HoneycombUI:Print(text)
	print("[HoneycombUI]: " .. tostring(text))
end

function HoneycombUI:CreateWindow(titleText)
	local window = {}
	local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	screenGui.Name = "HoneycombUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 500, 0, 350)
	main.Position = UDim2.new(0.5, -250, 0.5, -175)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Name = "Main"
	main.Parent = screenGui
	main:SetAttribute("Dragging", false)
	main:SetAttribute("Offset", Vector2.new(0, 0))
	main:SetAttribute("Start", Vector2.new(0, 0))

	CreateCorner(10).Parent = main

	-- Scaling
	local uiScale = Instance.new("UIScale", main)
	uiScale.Scale = 0.67

	-- Dragging
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Return function
	function window:ReturnWindow()
		main.Position = UDim2.new(0.5, -250, 0.5, -175)
	end

	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
	title.Text = titleText or "Honeycomb UI"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(200, 150, 255)
	title.BorderSizePixel = 0
	CreateCorner(8).Parent = title

	local sidebar = Instance.new("Frame", main)
	sidebar.Size = UDim2.new(0, 120, 1, -30)
	sidebar.Position = UDim2.new(0, 0, 0, 30)
	sidebar.BackgroundColor3 = Color3.fromRGB(35, 0, 70)
	CreateCorner(0).Parent = sidebar
	CreateLayout().Parent = sidebar

	local content = Instance.new("Frame", main)
	content.Size = UDim2.new(1, -120, 1, -30)
	content.Position = UDim2.new(0, 120, 0, 30)
	content.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
	CreateCorner(0).Parent = content

	local tabs = {}

	function window:AddTab(name)
		local tab = {}
		local btn = Instance.new("TextButton", sidebar)
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Text = name
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
		CreateCorner(6).Parent = btn

		local frame = Instance.new("ScrollingFrame", content)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.Visible = false
		frame.CanvasSize = UDim2.new(0, 0, 0, 0)
		frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		frame.BackgroundTransparency = 1
		frame.ScrollBarThickness = 6

		local layout = CreateLayout()
		layout.Parent = frame

		btn.MouseButton1Click:Connect(function()
			for _, t in pairs(tabs) do
				t.container.Visible = false
			end
			frame.Visible = true
		end)

		table.insert(tabs, {container = frame})

		function tab:AddButton(text, callback)
			local b = Instance.new("TextButton", frame)
			b.Size = UDim2.new(1, -20, 0, 32)
			b.Text = text
			b.Font = Enum.Font.Gotham
			b.TextSize = 16
			b.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.AutoButtonColor = true
			CreateCorner(6).Parent = b
			CreatePadding(6).Parent = b

			b.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)
		end

		function tab:AddTextbox(label, default, callback)
			local lbl = Instance.new("TextLabel", frame)
			lbl.Size = UDim2.new(1, -20, 0, 20)
			lbl.Text = label
			lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
			lbl.Font = Enum.Font.Gotham
			lbl.TextSize = 16
			lbl.BackgroundTransparency = 1
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local box = Instance.new("TextBox", frame)
			box.Size = UDim2.new(1, -20, 0, 32)
			box.Text = default or ""
			box.Font = Enum.Font.Gotham
			box.TextSize = 16
			box.BackgroundColor3 = Color3.fromRGB(60, 0, 130)
			box.TextColor3 = Color3.fromRGB(255, 255, 255)
			box.ClearTextOnFocus = false
			CreateCorner(6).Parent = box
			CreatePadding(6).Parent = box

			box.FocusLost:Connect(function(enter)
				if enter and callback then
					callback(box.Text)
				end
			end)
		end

		function tab:AddDropdown(label, options, callback)
			local lbl = Instance.new("TextLabel", frame)
			lbl.Size = UDim2.new(1, -20, 0, 20)
			lbl.Text = label
			lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
			lbl.Font = Enum.Font.Gotham
			lbl.TextSize = 16
			lbl.BackgroundTransparency = 1
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local dropBtn = Instance.new("TextButton", frame)
			dropBtn.Size = UDim2.new(1, -20, 0, 32)
			dropBtn.Text = "Select..."
			dropBtn.Font = Enum.Font.Gotham
			dropBtn.TextSize = 16
			dropBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 150)
			dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			CreateCorner(6).Parent = dropBtn
			CreatePadding(6).Parent = dropBtn

			local dropFrame = Instance.new("Frame", frame)
			dropFrame.Size = UDim2.new(1, -20, 0, #options * 26)
			dropFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
			dropFrame.Visible = false
			CreateCorner(4).Parent = dropFrame
			CreateLayout().Parent = dropFrame

			for _, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", dropFrame)
				optBtn.Size = UDim2.new(1, 0, 0, 26)
				optBtn.Text = opt
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextSize = 14
				optBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
				optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

				optBtn.MouseButton1Click:Connect(function()
					dropBtn.Text = opt
					dropFrame.Visible = false
					if callback then callback(opt) end
				end)
			end

			dropBtn.MouseButton1Click:Connect(function()
				dropFrame.Visible = not dropFrame.Visible
			end)
		end

		btn:MouseButton1Click()
		return tab
	end

	return window
end

return HoneycombUI
