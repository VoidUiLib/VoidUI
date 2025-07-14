-- Honeycomb UI Core - Minimal Base
local HoneycombUI = {}

local TweenService = game:GetService("TweenService")

-- CreateWindow
function HoneycombUI:CreateWindow(title)
    local window = {}

    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "HoneycombUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 450, 0, 320)
    main.Position = UDim2.new(0.5, -225, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.BorderSizePixel = 0
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Name = "Main"
    main.Parent = screenGui

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
    titleBar.BorderSizePixel = 0
    titleBar.Text = title or "Honeycomb UI"
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextColor3 = Color3.fromRGB(170, 85, 255)
    titleBar.TextSize = 20
    titleBar.Parent = main

    local tabSidebar = Instance.new("Frame")
    tabSidebar.Size = UDim2.new(0, 120, 1, -30)
    tabSidebar.Position = UDim2.new(0, 0, 0, 30)
    tabSidebar.BackgroundColor3 = Color3.fromRGB(35, 0, 80)
    tabSidebar.Parent = main

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -120, 1, -30)
    contentFrame.Position = UDim2.new(0, 120, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 70)
    contentFrame.ClipsDescendants = true
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = main

    local tabs = {}

    function window:AddTab(tabName)
        local tab = {}
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.Text = tabName
        tabBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 100)
        tabBtn.TextColor3 = Color3.fromRGB(230, 180, 255)
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 18
        tabBtn.Parent = tabSidebar

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollBarThickness = 6
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        tab.content = tabContent

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.content.Visible = false
            end
            tabContent.Visible = true
        end)

        function tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 35)
            btn.BackgroundColor3 = Color3.fromRGB(70, 0, 150)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 18
            btn.Text = text
            btn.Parent = tabContent

            btn.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        end

        function tab:AddTextbox(label, default, callback)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 25)
            lbl.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 35)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 18
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextColor3 = Color3.fromRGB(170, 85, 255)
            lbl.Text = label
            lbl.Parent = tabContent

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -20, 0, 30)
            box.Position = UDim2.new(0, 10, 0, (#tabContent:GetChildren() * 35) + 25)
            box.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.GothamBold
            box.TextSize = 18
            box.ClearTextOnFocus = false
            box.Text = default or ""
            box.Parent = tabContent

            box.FocusLost:Connect(function(enter)
                if enter and callback then
                    callback(box.Text)
                end
            end)
        end

        function tab:AddDropdown(name, options, callback)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 25)
            lbl.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 35)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 18
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextColor3 = Color3.fromRGB(170, 85, 255)
            lbl.Text = name
            lbl.Parent = tabContent

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, (#tabContent:GetChildren() * 35) + 25)
            btn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 18
            btn.Text = "Select..."
            btn.Parent = tabContent

            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1, -20, 0, #options * 30)
            dropFrame.Position = btn.Position + UDim2.new(0, 0, 0, 35)
            dropFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
            dropFrame.Visible = false
            dropFrame.Parent = tabContent

            for _, opt in ipairs(options) do
                local o = Instance.new("TextButton")
                o.Size = UDim2.new(1, 0, 0, 30)
                o.Position = UDim2.new(0, 0, 0, (_ - 1) * 30)
                o.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
                o.TextColor3 = Color3.fromRGB(255, 255, 255)
                o.Font = Enum.Font.GothamBold
                o.TextSize = 18
                o.Text = opt
                o.Parent = dropFrame

                o.MouseButton1Click:Connect(function()
                    btn.Text = opt
                    dropFrame.Visible = false
                    if callback then callback(opt) end
                end)
            end

            btn.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
            end)
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.content.Visible = false
            end
            tabContent.Visible = true
        end)

        tabBtn:MouseButton1Click()

        table.insert(tabs, tab)
        return tab
    end

    return window
end

return HoneycombUI
