-- VoidUI Base Library (v0.1)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup old GUI
local oldGui = playerGui:FindFirstChild("VoidUI")
if oldGui then oldGui:Destroy() end

local VoidUI = {}

-- Helper: make draggable frame
local function makeDraggable(frame, dragArea)
    dragArea = dragArea or frame
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create main window function
function VoidUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local window = Instance.new("Frame")
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 500, 0, 350)
    window.Position = UDim2.new(0.5, -250, 0.5, -175)
    window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    window.BorderSizePixel = 0
    window.Parent = screenGui

    -- Make draggable by title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 0, 70)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Void UI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = Color3.fromRGB(170, 85, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    makeDraggable(window, titleBar)

    -- Tab bar frame
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, 120, 1, -35)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.fromRGB(25, 0, 55)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = window

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabBar

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -120, 1, -35)
    contentFrame.Position = UDim2.new(0, 120, 0, 35)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = window

    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Padding = UDim.new(0, 8)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Parent = contentFrame

    local tabs = {}
    local activeTab = nil

    -- Tab creation function
    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Size = UDim2.new(1, -16, 0, 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 0, 120)
        tabButton.BorderSizePixel = 0
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = name
        tabButton.TextSize = 18
        tabButton.TextColor3 = Color3.fromRGB(170, 85, 255)
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabBar

        local function setActive(active)
            if active then
                tabButton.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
                tabButton.TextColor3 = Color3.fromRGB(30, 30, 30)
            else
                tabButton.BackgroundColor3 = Color3.fromRGB(50, 0, 120)
                tabButton.TextColor3 = Color3.fromRGB(170, 85, 255)
            end
        end

        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 8)
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            if activeTab ~= tabContent then
                if activeTab then activeTab.Visible = false end
                for _, t in pairs(tabs) do t.setActive(false) end
                setActive(true)
                tabContent.Visible = true
                activeTab = tabContent
            end
        end)

        tabs[tabContent] = {
            button = tabButton,
            setActive = setActive,
            content = tabContent
        }

        return tabContent
    end

    -- Select first tab helper
    local function selectFirstTab()
        for _, tab in pairs(tabs) do
            tab.setActive(false)
            tab.content.Visible = false
        end
        local firstTab = next(tabs)
        if firstTab then
            tabs[firstTab].setActive(true)
            firstTab.Visible = true
            activeTab = firstTab
        end
    end

    local windowObj = {}

    function windowObj:CreateTab(name)
        return createTab(name)
    end

    function windowObj:GetGui()
        return screenGui
    end

    -- Select first tab on window creation
    selectFirstTab()

    return windowObj
end

return VoidUI
