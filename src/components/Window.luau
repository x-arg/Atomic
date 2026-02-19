--[[
    Atomic UI Library - Window Component
    Main window container for the UI
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Window = {}
Window.__index = Window

function Window.new(library, config)
    local self = setmetatable({}, Window)
    
    self.Library = library
    self.Config = config
    self.Theme = library.Theme
    self.Utils = library.Utils
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    self.Minimized = false
    
    self:_CreateWindow()
    
    return self
end

function Window:_CreateWindow()
    -- Main container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = self.Config.Title .. "_Atomic"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    self.ScreenGui = screenGui
    table.insert(self.Library._Objects, screenGui)
    
    -- Window shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.fromOffset(self.Config.Size.X.Offset + 60, self.Config.Size.Y.Offset + 60)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = self.Theme.Shadow
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = screenGui
    self.Shadow = shadow
    
    -- Main window frame
    local windowFrame = Instance.new("Frame")
    windowFrame.Name = "Window"
    windowFrame.Size = self.Config.Size
    windowFrame.Position = self.Config.Position
    windowFrame.AnchorPoint = Vector2.new(0, 0)
    windowFrame.BackgroundColor3 = self.Theme.Background
    windowFrame.BorderSizePixel = 0
    windowFrame.Parent = screenGui
    self.Frame = windowFrame
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 10)
    windowCorner.Parent = windowFrame
    
    local windowStroke = Instance.new("UIStroke")
    windowStroke.Thickness = 1
    windowStroke.Color = self.Theme.Border
    windowStroke.Parent = windowFrame
    self.Stroke = windowStroke
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundColor3 = self.Theme.BackgroundSecondary
    header.BorderSizePixel = 0
    header.Parent = windowFrame
    self.Header = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    local headerFix = Instance.new("Frame")
    headerFix.Name = "Fix"
    headerFix.Size = UDim2.fromScale(1, 0.5)
    headerFix.Position = UDim2.fromScale(0, 0.5)
    headerFix.BackgroundColor3 = self.Theme.BackgroundSecondary
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    local headerPadding = Instance.new("UIPadding")
    headerPadding.PaddingTop = UDim.new(0, 10)
    headerPadding.PaddingBottom = UDim.new(0, 10)
    headerPadding.PaddingLeft = UDim.new(0, 14)
    headerPadding.PaddingRight = UDim.new(0, 14)
    headerPadding.Parent = header
    
    -- Header content
    local headerContent = Instance.new("Frame")
    headerContent.Name = "Content"
    headerContent.Size = UDim2.fromScale(1, 0)
    headerContent.AutomaticSize = Enum.AutomaticSize.Y
    headerContent.BackgroundTransparency = 1
    headerContent.Parent = header
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.Padding = UDim.new(0, 8)
    headerLayout.Parent = headerContent
    
    -- Title row
    local titleRow = Instance.new("Frame")
    titleRow.Name = "TitleRow"
    titleRow.Size = UDim2.fromScale(1, 0)
    titleRow.AutomaticSize = Enum.AutomaticSize.Y
    titleRow.BackgroundTransparency = 1
    titleRow.Parent = headerContent
    
    local titleRowLayout = Instance.new("UIListLayout")
    titleRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    titleRowLayout.FillDirection = Enum.FillDirection.Horizontal
    titleRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    titleRowLayout.Parent = titleRow
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 0)
    title.AutomaticSize = Enum.AutomaticSize.XY
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title
    title.TextColor3 = self.Theme.TextPrimary
    title.TextSize = 16
    title.FontFace = self.Theme.Font.Bold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 1
    title.Parent = titleRow
    self.Title = title
    
    -- Version badge
    local version = Instance.new("TextLabel")
    version.Name = "Version"
    version.Size = UDim2.fromOffset(0, 18)
    version.AutomaticSize = Enum.AutomaticSize.X
    version.BackgroundColor3 = self.Theme.Card
    version.BackgroundTransparency = 0
    version.BorderSizePixel = 0
    version.Text = "v" .. self.Library.Version
    version.TextColor3 = self.Theme.TextMuted
    version.TextSize = 10
    version.FontFace = self.Theme.Font.Main
    version.LayoutOrder = 2
    version.Parent = titleRow
    
    local versionCorner = Instance.new("UICorner")
    versionCorner.CornerRadius = UDim.new(0, 4)
    versionCorner.Parent = version
    
    local versionPadding = Instance.new("UIPadding")
    versionPadding.PaddingLeft = UDim.new(0, 6)
    versionPadding.PaddingRight = UDim.new(0, 6)
    versionPadding.Parent = version
    
    -- Tab buttons container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.fromScale(1, 0)
    tabButtons.AutomaticSize = Enum.AutomaticSize.Y
    tabButtons.BackgroundTransparency = 1
    tabButtons.LayoutOrder = 2
    tabButtons.Parent = headerContent
    self.TabButtonsContainer = tabButtons
    
    local tabButtonsLayout = Instance.new("UIListLayout")
    tabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabButtonsLayout.Padding = UDim.new(0, 4)
    tabButtonsLayout.Parent = tabButtons
    
    -- Window control buttons (minimize, close)
    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Size = UDim2.fromScale(0, 1)
    controls.AutomaticSize = Enum.AutomaticSize.X
    controls.BackgroundTransparency = 1
    controls.LayoutOrder = 3
    controls.Parent = titleRow
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.Padding = UDim.new(0, 8)
    controlsLayout.Parent = controls
    
    -- Minimize button
    if self.Config.Minimizable then
        local minimizeBtn = Instance.new("TextButton")
        minimizeBtn.Name = "Minimize"
        minimizeBtn.Size = UDim2.fromOffset(24, 24)
        minimizeBtn.BackgroundColor3 = self.Theme.Card
        minimizeBtn.BackgroundTransparency = 0
        minimizeBtn.BorderSizePixel = 0
        minimizeBtn.Text = "−"
        minimizeBtn.TextColor3 = self.Theme.TextSecondary
        minimizeBtn.TextSize = 18
        minimizeBtn.FontFace = self.Theme.Font.Bold
        minimizeBtn.AutoButtonColor = false
        minimizeBtn.LayoutOrder = 1
        minimizeBtn.Parent = controls
        self.MinimizeButton = minimizeBtn
        
        local minimizeCorner = Instance.new("UICorner")
        minimizeCorner.CornerRadius = UDim.new(0, 6)
        minimizeCorner.Parent = minimizeBtn
        
        minimizeBtn.MouseEnter:Connect(function()
            self.Utils:QuickTween(minimizeBtn, {BackgroundColor3 = self.Theme.CardHover})
        end)
        
        minimizeBtn.MouseLeave:Connect(function()
            self.Utils:QuickTween(minimizeBtn, {BackgroundColor3 = self.Theme.Card})
        end)
        
        minimizeBtn.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
    end
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.fromOffset(24, 24)
    closeBtn.BackgroundColor3 = self.Theme.Card
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.TextSecondary
    closeBtn.TextSize = 18
    closeBtn.FontFace = self.Theme.Font.Bold
    closeBtn.AutoButtonColor = false
    closeBtn.LayoutOrder = 2
    closeBtn.Parent = controls
    self.CloseButton = closeBtn
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseEnter:Connect(function()
        self.Utils:QuickTween(closeBtn, {BackgroundColor3 = self.Theme.Error})
        self.Utils:QuickTween(closeBtn, {TextColor3 = self.Theme.TextPrimary})
    end)
    
    closeBtn.MouseLeave:Connect(function()
        self.Utils:QuickTween(closeBtn, {BackgroundColor3 = self.Theme.Card})
        self.Utils:QuickTween(closeBtn, {TextColor3 = self.Theme.TextSecondary})
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.fromScale(1, 1)
    content.Position = UDim2.fromScale(0, 0)
    content.AnchorPoint = Vector2.new(0, 0)
    content.BackgroundColor3 = self.Theme.Background
    content.BorderSizePixel = 0
    content.Parent = windowFrame
    self.Content = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 0)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.Parent = content
    
    -- Make window draggable
    if self.Config.Draggable then
        self.Utils:MakeDraggable(windowFrame, header)
    end
    
    -- Toggle key bind
    if self.Config.ToggleKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == self.Config.ToggleKey then
                self:Toggle()
            end
        end)
    end
    
    -- Store reference
    self.Connections = {}
end

function Window:CreateTab(config)
    config = config or {}
    
    local Tab = require(script.Parent:WaitForChild("Tab"))
    local tab = Tab.new(self, config)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    -- Deselect all tabs
    for _, t in ipairs(self.Tabs) do
        t:SetVisible(false)
        t:SetSelected(false)
    end
    
    -- Select the specified tab
    tab:SetVisible(true)
    tab:SetSelected(true)
    self.CurrentTab = tab
end

function Window:Toggle()
    self.Visible = not self.Visible
    
    if self.Visible then
        self.Utils:QuickTween(self.Frame, {BackgroundTransparency = 0})
        self.Utils:QuickTween(self.Shadow, {ImageTransparency = 0.4})
    else
        self.Utils:QuickTween(self.Frame, {BackgroundTransparency = 1})
        self.Utils:QuickTween(self.Shadow, {ImageTransparency = 1})
    end
    
    self.Frame.Visible = self.Visible
    self.Shadow.Visible = self.Visible
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        self.Utils:Tween(self.Content, self.Theme.Animation.Fast, {
            Size = UDim2.fromScale(1, 0),
            ClipsDescendants = true
        })
        
        self.Utils:Tween(self.Frame, self.Theme.Animation.Fast, {
            Size = UDim2.fromOffset(self.Config.Size.X.Offset, 90)
        })
        
        if self.MinimizeButton then
            self.MinimizeButton.Text = "+"
        end
    else
        self.Utils:Tween(self.Content, self.Theme.Animation.Fast, {
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = false
        })
        
        self.Utils:Tween(self.Frame, self.Theme.Animation.Fast, {
            Size = self.Config.Size
        })
        
        if self.MinimizeButton then
            self.MinimizeButton.Text = "−"
        end
    end
end

function Window:SetTitle(title)
    self.Title.Text = title
    self.ScreenGui.Name = title .. "_Atomic"
end

function Window:SetSize(size)
    self.Config.Size = size
    self.Utils:QuickTween(self.Frame, {Size = size})
end

function Window:UpdateAccentColor(color)
    self.Theme.Accent = color
    for _, tab in ipairs(self.Tabs) do
        tab:UpdateAccentColor(color)
    end
end

function Window:Destroy()
    -- Disconnect all connections
    for _, connection in ipairs(self.Connections) do
        if connection.Disconnect then
            connection:Disconnect()
        end
    end
    
    -- Destroy all tabs
    for _, tab in ipairs(self.Tabs) do
        tab:Destroy()
    end
    
    -- Destroy the screen gui
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Remove from library
    for i, window in ipairs(self.Library._Windows) do
        if window == self then
            table.remove(self.Library._Windows, i)
            break
        end
    end
end

return Window
