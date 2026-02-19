--[[
    Atomic UI Library
    A minimalist, complete UI library for Roblox
    Version: 1.0.0
    
    Features:
    - Dark mode with white text
    - Smooth animations
    - Full component library
    - Easy to use API
    
    Usage:
    local Atomic = loadstring(game:HttpGet("https://raw.githubusercontent.com/x-arg/Atomic/main/src/Atomic.luau"))()
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ==================== THEME ====================
local Theme = {
    -- Main colors
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(20, 20, 28),
    BackgroundTertiary = Color3.fromRGB(25, 25, 35),
    
    -- Card/Container colors
    Card = Color3.fromRGB(22, 22, 30),
    CardHover = Color3.fromRGB(28, 28, 38),
    CardActive = Color3.fromRGB(32, 32, 42),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    TextMuted = Color3.fromRGB(120, 120, 135),
    TextDisabled = Color3.fromRGB(80, 80, 90),
    
    -- Accent colors
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(108, 121, 255),
    AccentActive = Color3.fromRGB(78, 91, 232),
    
    -- Status colors
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Info = Color3.fromRGB(88, 101, 242),
    
    -- Border colors
    Border = Color3.fromRGB(45, 45, 55),
    BorderLight = Color3.fromRGB(55, 55, 65),
    
    -- Shadow/Overlay
    Shadow = Color3.fromRGB(0, 0, 0),
    Overlay = Color3.fromRGB(0, 0, 0),
    
    -- Scrollbar
    Scrollbar = Color3.fromRGB(40, 40, 50),
    ScrollbarHover = Color3.fromRGB(50, 50, 60),
    
    -- Input colors
    InputBackground = Color3.fromRGB(18, 18, 24),
    InputBorder = Color3.fromRGB(40, 40, 50),
    InputBorderActive = Color3.fromRGB(88, 101, 242),
    
    -- Typography
    Font = {
        Main = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
        Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
        Light = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light),
        Mono = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Medium),
    },
    
    -- Animation
    Animation = {
        Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    },
}

function Theme:AdjustColor(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

-- ==================== UTILITIES ====================
local Utils = {}

function Utils:Tween(instance, tweenInfo, properties)
    tweenInfo = tweenInfo or Theme.Animation.Normal
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utils:QuickTween(instance, properties)
    return self:Tween(instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
end

function Utils:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utils:Round(number, decimalPlaces)
    decimalPlaces = decimalPlaces or 0
    local multiplier = 10 ^ decimalPlaces
    return math.floor(number * multiplier + 0.5) / multiplier
end

function Utils:Color3ToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255))
end

function Utils:HexToColor3(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

function Utils:HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

function Utils:RGBtoHSV(color)
    local r, g, b = color.R, color.G, color.B
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    
    local d = max - min
    if max == 0 then s = 0 else s = d / max end
    
    if max == min then
        h = 0
    elseif max == r then
        h = (g - b) / d
        if g < b then h = h + 6 end
    elseif max == g then
        h = (b - r) / d + 2
    elseif max == b then
        h = (r - g) / d + 4
    end
    
    h = h / 6
    
    return h, s, v
end

function Utils:AddRippleEffect(button, rippleColor)
    rippleColor = rippleColor or Color3.new(1, 1, 1)
    
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = rippleColor
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.Size = UDim2.fromOffset(0, 0)
        ripple.Position = UDim2.fromScale(0.5, 0.5)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        self:Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(maxSize, maxSize),
            BackgroundTransparency = 1
        })
        
        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end)
end

-- ==================== COMPONENT DEFINITIONS ====================
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local Button = {}
Button.__index = Button

local Toggle = {}
Toggle.__index = Toggle

local Slider = {}
Slider.__index = Slider

local TextBox = {}
TextBox.__index = TextBox

local Dropdown = {}
Dropdown.__index = Dropdown

local Label = {}
Label.__index = Label

local Paragraph = {}
Paragraph.__index = Paragraph

local Divider = {}
Divider.__index = Divider

local Keybind = {}
Keybind.__index = Keybind

local ColorPicker = {}
ColorPicker.__index = ColorPicker

local Progress = {}
Progress.__index = Progress

local Notification = {}
Notification.__index = Notification

Notification._Queue = {}
Notification._Container = nil
Notification._ActiveCount = 0

-- ==================== WINDOW ====================
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
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = self.Config.Title .. "_Atomic"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    self.ScreenGui = screenGui
    table.insert(self.Library._Objects, screenGui)
    
    -- Shadow
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
    
    -- Main frame
    local windowFrame = Instance.new("Frame")
    windowFrame.Name = "Window"
    windowFrame.Size = self.Config.Size
    windowFrame.Position = self.Config.Position
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
    
    -- Controls
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
    content.BackgroundColor3 = self.Theme.Background
    content.BorderSizePixel = 0
    content.Parent = windowFrame
    self.Content = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.Parent = content
    
    -- Make draggable
    if self.Config.Draggable then
        self.Utils:MakeDraggable(windowFrame, header)
    end
    
    -- Toggle key
    if self.Config.ToggleKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == self.Config.ToggleKey then
                self:Toggle()
            end
        end)
    end
    
    self.Connections = {}
end

function Window:CreateTab(config)
    local tab = Tab.new(self, config or {})
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t:SetVisible(false)
        t:SetSelected(false)
    end
    tab:SetVisible(true)
    tab:SetSelected(true)
    self.CurrentTab = tab
end

function Window:Toggle()
    self.Visible = not self.Visible
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
    for _, connection in ipairs(self.Connections) do
        if connection.Disconnect then connection:Disconnect() end
    end
    for _, tab in ipairs(self.Tabs) do
        tab:Destroy()
    end
    if self.ScreenGui then self.ScreenGui:Destroy() end
    for i, window in ipairs(self.Library._Windows) do
        if window == self then
            table.remove(self.Library._Windows, i)
            break
        end
    end
end

-- ==================== TAB ====================
function Tab.new(window, config)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Library = window.Library
    self.Theme = window.Theme
    self.Utils = window.Utils
    self.Name = config.Name or "Tab"
    self.Sections = {}
    self.Visible = false
    self.Selected = false
    
    self:_CreateTab()
    
    return self
end

function Tab:_CreateTab()
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = self.Name
    tabButton.Size = UDim2.fromOffset(0, 26)
    tabButton.AutomaticSize = Enum.AutomaticSize.X
    tabButton.BackgroundColor3 = self.Theme.BackgroundTertiary
    tabButton.BackgroundTransparency = 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = self.Name
    tabButton.TextColor3 = self.Theme.TextMuted
    tabButton.TextSize = 13
    tabButton.FontFace = self.Theme.Font.Main
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.Window.TabButtonsContainer
    self.Button = tabButton
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tabButton
    
    local buttonPadding = Instance.new("UIPadding")
    buttonPadding.PaddingLeft = UDim.new(0, 10)
    buttonPadding.PaddingRight = UDim.new(0, 10)
    buttonPadding.PaddingTop = UDim.new(0, 4)
    buttonPadding.PaddingBottom = UDim.new(0, 4)
    buttonPadding.Parent = tabButton
    
    tabButton.MouseEnter:Connect(function()
        if not self.Selected then
            self.Utils:QuickTween(tabButton, {
                BackgroundColor3 = self.Theme.CardHover,
                BackgroundTransparency = 0,
                TextColor3 = self.Theme.TextSecondary
            })
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not self.Selected then
            self.Utils:QuickTween(tabButton, {
                BackgroundColor3 = self.Theme.BackgroundTertiary,
                BackgroundTransparency = 1,
                TextColor3 = self.Theme.TextMuted
            })
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Content
    local content = Instance.new("ScrollingFrame")
    content.Name = self.Name .. "_Content"
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundColor3 = self.Theme.Background
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = self.Theme.Scrollbar
    content.ScrollBarImageTransparency = 0.5
    content.CanvasSize = UDim2.fromScale(0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.Visible = false
    content.Parent = self.Window.Content
    self.Content = content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.Parent = content
    
    -- Columns
    local columns = Instance.new("Frame")
    columns.Name = "Columns"
    columns.Size = UDim2.fromScale(1, 0)
    columns.AutomaticSize = Enum.AutomaticSize.Y
    columns.BackgroundTransparency = 1
    columns.Parent = content
    self.ColumnsContainer = columns
    
    local columnsLayout = Instance.new("UIGridLayout")
    columnsLayout.CellSize = UDim2.fromScale(0.5, 0)
    columnsLayout.CellPadding = UDim2.fromOffset(12, 0)
    columnsLayout.FillDirectionMaxCells = 2
    columnsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    columnsLayout.Parent = columns
end

function Tab:SetVisible(visible)
    self.Content.Visible = visible
    self.Visible = visible
end

function Tab:SetSelected(selected)
    self.Selected = selected
    if selected then
        self.Utils:QuickTween(self.Button, {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0,
            TextColor3 = self.Theme.TextPrimary
        })
    else
        self.Utils:QuickTween(self.Button, {
            BackgroundColor3 = self.Theme.BackgroundTertiary,
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.TextMuted
        })
    end
end

function Tab:CreateSection(config)
    local section = Section.new(self, config or {})
    table.insert(self.Sections, section)
    return section
end

function Tab:UpdateAccentColor(color)
    for _, section in ipairs(self.Sections) do
        section:UpdateAccentColor(color)
    end
end

function Tab:Destroy()
    for _, section in ipairs(self.Sections) do
        section:Destroy()
    end
    if self.Button then self.Button:Destroy() end
    if self.Content then self.Content:Destroy() end
end

-- ==================== SECTION ====================
function Section.new(tab, config)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Library = tab.Library
    self.Theme = tab.Theme
    self.Utils = tab.Utils
    self.Name = config.Name or "Section"
    self.Column = config.Column or 1
    self.Elements = {}
    
    self:_CreateSection()
    
    return self
end

function Section:_CreateSection()
    local columnName = "Column" .. self.Column
    local columnContainer = self.Tab.ColumnsContainer:FindFirstChild(columnName)
    
    if not columnContainer then
        columnContainer = Instance.new("Frame")
        columnContainer.Name = columnName
        columnContainer.Size = UDim2.fromScale(1, 0)
        columnContainer.AutomaticSize = Enum.AutomaticSize.Y
        columnContainer.BackgroundTransparency = 1
        columnContainer.Parent = self.Tab.ColumnsContainer
        
        local columnLayout = Instance.new("UIListLayout")
        columnLayout.SortOrder = Enum.SortOrder.LayoutOrder
        columnLayout.Padding = UDim.new(0, 12)
        columnLayout.Parent = columnContainer
    end
    
    local section = Instance.new("Frame")
    section.Name = self.Name
    section.Size = UDim2.fromScale(1, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = self.Theme.Card
    section.BorderSizePixel = 0
    section.Parent = columnContainer
    self.Frame = section
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Thickness = 1
    sectionStroke.Color = self.Theme.Border
    sectionStroke.Transparency = 0.5
    sectionStroke.Parent = section
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Parent = section
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 0)
    title.AutomaticSize = Enum.AutomaticSize.Y
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = self.Theme.TextPrimary
    title.TextSize = 14
    title.FontFace = self.Theme.Font.Bold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    self.Title = title
    
    local titlePadding = Instance.new("UIPadding")
    titlePadding.PaddingTop = UDim.new(0, 12)
    titlePadding.PaddingLeft = UDim.new(0, 12)
    titlePadding.PaddingRight = UDim.new(0, 12)
    titlePadding.Parent = title
    
    -- Divider
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -24, 0, 1)
    divider.Position = UDim2.fromOffset(12, 0)
    divider.BackgroundColor3 = self.Theme.Border
    divider.BackgroundTransparency = 0.3
    divider.BorderSizePixel = 0
    divider.Parent = header
    
    -- Content
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.fromScale(1, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Parent = section
    self.Content = content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.Parent = content
end

function Section:AddButton(config)
    local button = Button.new(self, config or {})
    table.insert(self.Elements, button)
    return button
end

function Section:AddToggle(config)
    local toggle = Toggle.new(self, config or {})
    table.insert(self.Elements, toggle)
    return toggle
end

function Section:AddSlider(config)
    local slider = Slider.new(self, config or {})
    table.insert(self.Elements, slider)
    return slider
end

function Section:AddTextBox(config)
    local textBox = TextBox.new(self, config or {})
    table.insert(self.Elements, textBox)
    return textBox
end

function Section:AddDropdown(config)
    local dropdown = Dropdown.new(self, config or {})
    table.insert(self.Elements, dropdown)
    return dropdown
end

function Section:AddLabel(config)
    local label = Label.new(self, config or {})
    table.insert(self.Elements, label)
    return label
end

function Section:AddParagraph(config)
    local paragraph = Paragraph.new(self, config or {})
    table.insert(self.Elements, paragraph)
    return paragraph
end

function Section:AddDivider(config)
    local divider = Divider.new(self, config or {})
    table.insert(self.Elements, divider)
    return divider
end

function Section:AddKeybind(config)
    local keybind = Keybind.new(self, config or {})
    table.insert(self.Elements, keybind)
    return keybind
end

function Section:AddColorPicker(config)
    local colorPicker = ColorPicker.new(self, config or {})
    table.insert(self.Elements, colorPicker)
    return colorPicker
end

function Section:AddProgress(config)
    local progress = Progress.new(self, config or {})
    table.insert(self.Elements, progress)
    return progress
end

function Section:SetTitle(title)
    self.Name = title
    self.Title.Text = title
    self.Frame.Name = title
end

function Section:UpdateAccentColor(color)
    for _, element in ipairs(self.Elements) do
        if element.UpdateAccentColor then
            element:UpdateAccentColor(color)
        end
    end
end

function Section:Destroy()
    for _, element in ipairs(self.Elements) do
        if element.Destroy then element:Destroy() end
    end
    if self.Frame then self.Frame:Destroy() end
end

-- ==================== BUTTON ====================
function Button.new(section, config)
    local self = setmetatable({}, Button)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Button"
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Style = config.Style or "Default"
    
    self:_CreateButton()
    
    return self
end

function Button:_CreateButton()
    local bgColor, hoverColor, activeColor, textColor
    
    if self.Style == "Primary" then
        bgColor, hoverColor, activeColor, textColor = self.Theme.Accent, self.Theme.AccentHover, self.Theme.AccentActive, self.Theme.TextPrimary
    elseif self.Style == "Success" then
        bgColor = self.Theme.Success
        hoverColor = self.Theme:AdjustColor(bgColor, 0.1)
        activeColor = self.Theme:AdjustColor(bgColor, -0.1)
        textColor = Color3.fromRGB(15, 15, 20)
    elseif self.Style == "Warning" then
        bgColor = self.Theme.Warning
        hoverColor = self.Theme:AdjustColor(bgColor, 0.1)
        activeColor = self.Theme:AdjustColor(bgColor, -0.1)
        textColor = Color3.fromRGB(15, 15, 20)
    elseif self.Style == "Error" then
        bgColor, hoverColor, activeColor, textColor = self.Theme.Error, self.Theme:AdjustColor(self.Theme.Error, 0.1), self.Theme:AdjustColor(self.Theme.Error, -0.1), self.Theme.TextPrimary
    else
        bgColor, hoverColor, activeColor, textColor = self.Theme.CardHover, self.Theme.CardActive, self.Theme.Border, self.Theme.TextPrimary
    end
    
    local container = Instance.new("Frame")
    container.Name = "Button"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local button = Instance.new("TextButton")
    button.Name = "ButtonElement"
    button.Size = UDim2.fromScale(1, 0)
    button.AutomaticSize = Enum.AutomaticSize.Y
    button.BackgroundColor3 = self.Disabled and self.Theme.Border or bgColor
    button.BorderSizePixel = 0
    button.Text = self.Text
    button.TextColor3 = self.Disabled and self.Theme.TextMuted or textColor
    button.TextSize = 13
    button.FontFace = self.Theme.Font.Main
    button.AutoButtonColor = false
    button.Active = not self.Disabled
    button.Parent = container
    self.Button = button
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local buttonPadding = Instance.new("UIPadding")
    buttonPadding.PaddingTop = UDim.new(0, 8)
    buttonPadding.PaddingBottom = UDim.new(0, 8)
    buttonPadding.PaddingLeft = UDim.new(0, 12)
    buttonPadding.PaddingRight = UDim.new(0, 12)
    buttonPadding.Parent = button
    
    if not self.Disabled then
        button.MouseEnter:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = hoverColor})
        end)
        
        button.MouseLeave:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = bgColor})
        end)
        
        button.MouseButton1Down:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = activeColor})
        end)
        
        button.MouseButton1Up:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = hoverColor})
        end)
        
        self.Utils:AddRippleEffect(button, self.Style == "Default" and self.Theme.TextMuted or textColor)
        
        button.MouseButton1Click:Connect(function()
            if self.Callback then self.Callback() end
        end)
    end
end

function Button:SetText(text)
    self.Text = text
    self.Button.Text = text
end

function Button:SetCallback(callback)
    self.Callback = callback
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    self.Button.Active = not disabled
end

function Button:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== TOGGLE ====================
function Toggle.new(section, config)
    local self = setmetatable({}, Toggle)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Toggle"
    self.Default = config.Default or false
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Value = self.Default
    
    self:_CreateToggle()
    
    return self
end

function Toggle:_CreateToggle()
    local container = Instance.new("Frame")
    container.Name = "Toggle"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.FillDirection = Enum.FillDirection.Horizontal
    containerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    containerLayout.Padding = UDim.new(0, 8)
    containerLayout.Parent = container
    
    local toggleArea = Instance.new("TextButton")
    toggleArea.Name = "ToggleArea"
    toggleArea.Size = UDim2.fromOffset(40, 22)
    toggleArea.BackgroundColor3 = self.Value and self.Theme.Accent or self.Theme.Border
    toggleArea.BorderSizePixel = 0
    toggleArea.Text = ""
    toggleArea.AutoButtonColor = false
    toggleArea.Active = not self.Disabled
    toggleArea.LayoutOrder = 1
    toggleArea.Parent = container
    self.ToggleArea = toggleArea
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleArea
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = self.Value and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = self.Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Parent = toggleArea
    self.Knob = knob
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 2
    label.Parent = container
    self.Label = label
    
    toggleArea.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:SetValue(not self.Value)
        end
    end)
end

function Toggle:SetValue(value, callback)
    self.Value = value
    
    if value then
        self.Utils:QuickTween(self.Knob, {Position = UDim2.fromOffset(20, 2)})
        self.Utils:QuickTween(self.ToggleArea, {BackgroundColor3 = self.Theme.Accent})
    else
        self.Utils:QuickTween(self.Knob, {Position = UDim2.fromOffset(2, 2)})
        self.Utils:QuickTween(self.ToggleArea, {BackgroundColor3 = self.Theme.Border})
    end
    
    if callback ~= false and self.Callback then
        self.Callback(value)
    end
end

function Toggle:GetValue()
    return self.Value
end

function Toggle:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Toggle:SetDisabled(disabled)
    self.Disabled = disabled
    self.ToggleArea.Active = not disabled
end

function Toggle:UpdateAccentColor(color)
    if self.Value then
        self.ToggleArea.BackgroundColor3 = color
    end
end

function Toggle:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== SLIDER ====================
function Slider.new(section, config)
    local self = setmetatable({}, Slider)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Slider"
    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Default = config.Default or self.Min
    self.Increment = config.Increment or 1
    self.Precise = config.Precise or false
    self.Suffix = config.Suffix or ""
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Value = self.Default
    self.Dragging = false
    
    self:_CreateSlider()
    
    return self
end

function Slider:_CreateSlider()
    local container = Instance.new("Frame")
    container.Name = "Slider"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = container
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.Parent = header
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = header
    self.Label = label
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "Value"
    valueDisplay.Size = UDim2.fromOffset(0, 0)
    valueDisplay.AutomaticSize = Enum.AutomaticSize.XY
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Text = tostring(self.Value) .. self.Suffix
    valueDisplay.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    valueDisplay.TextSize = 12
    valueDisplay.FontFace = self.Theme.Font.Mono
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.LayoutOrder = 2
    valueDisplay.Parent = header
    self.ValueDisplay = valueDisplay
    
    -- Track container
    local trackContainer = Instance.new("Frame")
    trackContainer.Name = "TrackContainer"
    trackContainer.Size = UDim2.fromScale(1, 0)
    trackContainer.AutomaticSize = Enum.AutomaticSize.Y
    trackContainer.BackgroundTransparency = 1
    trackContainer.LayoutOrder = 2
    trackContainer.Parent = container
    
    local trackPadding = Instance.new("UIPadding")
    trackPadding.PaddingTop = UDim.new(0, 4)
    trackPadding.PaddingBottom = UDim.new(0, 4)
    trackPadding.Parent = trackContainer
    
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.Size = UDim2.fromScale(1, 0)
    track.AutomaticSize = Enum.AutomaticSize.Y
    track.BackgroundColor3 = self.Theme.Border
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.Active = not self.Disabled
    track.Parent = trackContainer
    self.Track = track
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local trackInnerPadding = Instance.new("UIPadding")
    trackInnerPadding.PaddingTop = UDim.new(0, 6)
    trackInnerPadding.PaddingBottom = UDim.new(0, 6)
    trackInnerPadding.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.fromScale(self:_GetPercent(), 1)
    fill.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    self.Fill = fill
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.fromScale(self:_GetPercent(), 0.5)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = self.Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Parent = track
    self.Knob = knob
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Thickness = 2
    knobStroke.Color = self.Theme.Accent
    knobStroke.Parent = knob
    self.KnobStroke = knobStroke
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local rawValue = self.Min + (self.Max - self.Min) * relativeX
        local roundedValue
        
        if self.Precise then
            roundedValue = self.Utils:Round(rawValue, 2)
        else
            roundedValue = self.Utils:Round(rawValue / self.Increment) * self.Increment
        end
        
        roundedValue = math.clamp(roundedValue, self.Min, self.Max)
        
        if roundedValue ~= self.Value then
            self:SetValue(roundedValue)
        end
    end
    
    track.MouseButton1Down:Connect(function(input)
        if not self.Disabled then
            self.Dragging = true
            updateSlider(input)
        end
    end)
    
    track.MouseButton1Up:Connect(function()
        self.Dragging = false
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
end

function Slider:_GetPercent()
    return (self.Value - self.Min) / (self.Max - self.Min)
end

function Slider:SetValue(value, callback)
    value = math.clamp(value, self.Min, self.Max)
    
    if self.Precise then
        value = self.Utils:Round(value, 2)
    else
        value = self.Utils:Round(value / self.Increment) * self.Increment
    end
    
    self.Value = value
    local percent = self:_GetPercent()
    
    self.Utils:QuickTween(self.Fill, {Size = UDim2.fromScale(percent, 1)})
    self.Utils:QuickTween(self.Knob, {Position = UDim2.fromScale(percent, 0.5)})
    
    self.ValueDisplay.Text = tostring(value) .. self.Suffix
    
    if callback ~= false and self.Callback then
        self.Callback(value)
    end
end

function Slider:GetValue()
    return self.Value
end

function Slider:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Slider:SetDisabled(disabled)
    self.Disabled = disabled
    self.Track.Active = not disabled
end

function Slider:UpdateAccentColor(color)
    self.Fill.BackgroundColor3 = color
    self.KnobStroke.Color = color
end

function Slider:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== TEXTBOX ====================
function TextBox.new(section, config)
    local self = setmetatable({}, TextBox)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or ""
    self.Placeholder = config.Placeholder or "Enter text..."
    self.Label = config.Label or ""
    self.Numeric = config.Numeric or false
    self.MaxLength = config.MaxLength or 200
    self.ClearOnFocus = config.ClearOnFocus or false
    self.Callback = config.Callback or function() end
    self.ChangedCallback = config.ChangedCallback or function() end
    self.Disabled = config.Disabled or false
    
    self:_CreateTextBox()
    
    return self
end

function TextBox:_CreateTextBox()
    local container = Instance.new("Frame")
    container.Name = "TextBox"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container
    
    if self.Label and self.Label ~= "" then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.fromScale(1, 0)
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.BackgroundTransparency = 1
        label.Text = self.Label
        label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
        label.TextSize = 13
        label.FontFace = self.Theme.Font.Main
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = 1
        label.Parent = container
        self.LabelElement = label
    end
    
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.fromScale(1, 0)
    inputContainer.AutomaticSize = Enum.AutomaticSize.Y
    inputContainer.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    inputContainer.BorderSizePixel = 0
    inputContainer.LayoutOrder = 2
    inputContainer.Parent = container
    self.InputContainer = inputContainer
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputContainer
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Thickness = 1
    inputStroke.Color = self.Theme.InputBorder
    inputStroke.Transparency = 0.5
    inputStroke.Parent = inputContainer
    self.InputStroke = inputStroke
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBoxElement"
    textBox.Size = UDim2.fromScale(1, 0)
    textBox.AutomaticSize = Enum.AutomaticSize.Y
    textBox.BackgroundTransparency = 1
    textBox.Text = self.Text
    textBox.PlaceholderText = self.Placeholder
    textBox.PlaceholderColor3 = self.Theme.TextMuted
    textBox.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    textBox.TextSize = 13
    textBox.FontFace = self.Theme.Font.Main
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextWrapped = true
    textBox.ClearTextOnFocus = self.ClearOnFocus
    textBox.MaxLength = self.MaxLength
    textBox.Active = not self.Disabled
    textBox.Parent = inputContainer
    self.TextBoxElement = textBox
    
    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingTop = UDim.new(0, 8)
    textBoxPadding.PaddingBottom = UDim.new(0, 8)
    textBoxPadding.PaddingLeft = UDim.new(0, 10)
    textBoxPadding.PaddingRight = UDim.new(0, 10)
    textBoxPadding.Parent = textBox
    
    textBox.Focused:Connect(function()
        if not self.Disabled then
            self.Utils:QuickTween(self.InputStroke, {Color = self.Theme.Accent, Transparency = 0})
        end
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if not self.Disabled then
            self.Utils:QuickTween(self.InputStroke, {Color = self.Theme.InputBorder, Transparency = 0.5})
            self.Text = textBox.Text
            self.Callback(self.Text, enterPressed)
        end
    end)
    
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if not self.Disabled then
            self.Text = textBox.Text
            self.ChangedCallback(self.Text)
        end
    end)
    
    if self.Numeric then
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            local text = textBox.Text
            local numericText = text:gsub("[^%d%.%-]", "")
            if text ~= numericText then
                textBox.Text = numericText
            end
        end)
    end
end

function TextBox:SetText(text)
    self.Text = text
    self.TextBoxElement.Text = text
end

function TextBox:GetText()
    return self.TextBoxElement.Text
end

function TextBox:SetPlaceholder(placeholder)
    self.Placeholder = placeholder
    self.TextBoxElement.PlaceholderText = placeholder
end

function TextBox:SetDisabled(disabled)
    self.Disabled = disabled
    self.TextBoxElement.Active = not disabled
end

function TextBox:SetCallback(callback)
    self.Callback = callback
end

function TextBox:Clear()
    self.TextBoxElement.Text = ""
    self.Text = ""
end

function TextBox:Focus()
    self.TextBoxElement:CaptureFocus()
end

function TextBox:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== DROPDOWN ====================
function Dropdown.new(section, config)
    local self = setmetatable({}, Dropdown)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Dropdown"
    self.Options = config.Options or {}
    self.Default = config.Default or (#self.Options > 0 and self.Options[1] or nil)
    self.MultiSelect = config.MultiSelect or false
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Value = self.MultiSelect and {} or self.Default
    self.Open = false
    
    self:_CreateDropdown()
    
    return self
end

function Dropdown:_CreateDropdown()
    local container = Instance.new("Frame")
    container.Name = "Dropdown"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.ZIndex = 10
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.ZIndex = 10
    label.Parent = container
    self.Label = label
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = "Button"
    dropdownBtn.Size = UDim2.fromScale(1, 0)
    dropdownBtn.AutomaticSize = Enum.AutomaticSize.Y
    dropdownBtn.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = self.MultiSelect and "Select options..." or (self.Value or "Select...")
    dropdownBtn.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    dropdownBtn.TextSize = 13
    dropdownBtn.FontFace = self.Theme.Font.Main
    dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Active = not self.Disabled
    dropdownBtn.LayoutOrder = 2
    dropdownBtn.ZIndex = 10
    dropdownBtn.Parent = container
    self.Button = dropdownBtn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = self.Theme.InputBorder
    btnStroke.Transparency = 0.5
    btnStroke.Parent = dropdownBtn
    self.ButtonStroke = btnStroke
    
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingTop = UDim.new(0, 8)
    btnPadding.PaddingBottom = UDim.new(0, 8)
    btnPadding.PaddingLeft = UDim.new(0, 10)
    btnPadding.PaddingRight = UDim.new(0, 28)
    btnPadding.Parent = dropdownBtn
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.Position = UDim2.fromScale(1, 0.5)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.Theme.TextMuted
    arrow.TextSize = 10
    arrow.FontFace = self.Theme.Font.Bold
    arrow.ZIndex = 11
    arrow.Parent = dropdownBtn
    self.Arrow = arrow
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.fromScale(1, 0)
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.BackgroundColor3 = self.Theme.Card
    optionsContainer.BorderSizePixel = 0
    optionsContainer.Visible = false
    optionsContainer.LayoutOrder = 3
    optionsContainer.ZIndex = 9
    optionsContainer.Parent = container
    self.OptionsContainer = optionsContainer
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsContainer
    
    local optionsStroke = Instance.new("UIStroke")
    optionsStroke.Thickness = 1
    optionsStroke.Color = self.Theme.Border
    optionsStroke.Parent = optionsContainer
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsContainer
    
    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, 4)
    optionsPadding.PaddingBottom = UDim.new(0, 4)
    optionsPadding.Parent = optionsContainer
    
    self.OptionButtons = {}
    for i, option in ipairs(self.Options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Name = "Option_" .. tostring(i)
        optionBtn.Size = UDim2.fromScale(1, 0)
        optionBtn.AutomaticSize = Enum.AutomaticSize.Y
        optionBtn.BackgroundColor3 = self.Theme.Card
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = "  " .. tostring(option)
        optionBtn.TextColor3 = self.Theme.TextSecondary
        optionBtn.TextSize = 13
        optionBtn.FontFace = self.Theme.Font.Main
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        optionBtn.AutoButtonColor = false
        optionBtn.ZIndex = 9
        optionBtn.Parent = optionsContainer
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingTop = UDim.new(0, 6)
        optionPadding.PaddingBottom = UDim.new(0, 6)
        optionPadding.Parent = optionBtn
        
        optionBtn.MouseEnter:Connect(function()
            self.Utils:QuickTween(optionBtn, {BackgroundColor3 = self.Theme.CardHover})
        end)
        
        optionBtn.MouseLeave:Connect(function()
            self.Utils:QuickTween(optionBtn, {BackgroundColor3 = self.Theme.Card})
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            if self.MultiSelect then
                self:_ToggleMultiOption(option)
            else
                self:SetValue(option)
                self:Close()
            end
        end)
        
        self.OptionButtons[option] = optionBtn
    end
    
    self:_UpdateDisplay()
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if not self.Disabled then
            if self.Open then
                self:Close()
            else
                self:Open()
            end
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if self.Open and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local containerPos = container.AbsolutePosition
            local containerSize = container.AbsoluteSize
            
            if mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or
               mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y then
                self:Close()
            end
        end
    end)
end

function Dropdown:_ToggleMultiOption(option)
    local index = table.find(self.Value, option)
    if index then
        table.remove(self.Value, index)
    else
        table.insert(self.Value, option)
    end
    self:_UpdateDisplay()
    self.Callback(self.Value)
end

function Dropdown:_UpdateDisplay()
    if self.MultiSelect then
        if #self.Value == 0 then
            self.Button.Text = "Select options..."
            self.Button.TextColor3 = self.Theme.TextMuted
        else
            self.Button.Text = table.concat(self.Value, ", ")
            self.Button.TextColor3 = self.Theme.TextPrimary
        end
        
        for option, btn in pairs(self.OptionButtons) do
            if table.find(self.Value, option) then
                btn.Text = "✓ " .. tostring(option)
                btn.TextColor3 = self.Theme.Accent
            else
                btn.Text = "  " .. tostring(option)
                btn.TextColor3 = self.Theme.TextSecondary
            end
        end
    else
        if self.Value then
            self.Button.Text = tostring(self.Value)
            self.Button.TextColor3 = self.Theme.TextPrimary
            
            for option, btn in pairs(self.OptionButtons) do
                if option == self.Value then
                    btn.Text = "✓ " .. tostring(option)
                    btn.TextColor3 = self.Theme.Accent
                else
                    btn.Text = "  " .. tostring(option)
                    btn.TextColor3 = self.Theme.TextSecondary
                end
            end
        end
    end
end

function Dropdown:Open()
    self.Open = true
    self.OptionsContainer.Visible = true
    self.Utils:QuickTween(self.Arrow, {Rotation = 180})
    self.Utils:QuickTween(self.ButtonStroke, {Color = self.Theme.Accent})
end

function Dropdown:Close()
    self.Open = false
    self.OptionsContainer.Visible = false
    self.Utils:QuickTween(self.Arrow, {Rotation = 0})
    self.Utils:QuickTween(self.ButtonStroke, {Color = self.Theme.InputBorder})
end

function Dropdown:SetValue(value, callback)
    if self.MultiSelect then
        if type(value) == "table" then
            self.Value = value
        end
    else
        self.Value = value
    end
    self:_UpdateDisplay()
    
    if callback ~= false and self.Callback then
        self.Callback(self.Value)
    end
end

function Dropdown:GetValue()
    return self.Value
end

function Dropdown:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Dropdown:SetDisabled(disabled)
    self.Disabled = disabled
    self.Button.Active = not disabled
end

function Dropdown:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== LABEL ====================
function Label.new(section, config)
    local self = setmetatable({}, Label)
    
    self.Section = section
    self.Theme = section.Theme
    self.Text = config.Text or "Label"
    self.Size = config.Size or 13
    self.Color = config.Color
    
    self:_CreateLabel()
    
    return self
end

function Label:_CreateLabel()
    local container = Instance.new("Frame")
    container.Name = "Label"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Color or self.Theme.TextSecondary
    label.TextSize = self.Size
    label.FontFace = self.Theme.Font.Main
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = container
    self.Label = label
end

function Label:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Label:SetColor(color)
    self.Color = color
    self.Label.TextColor3 = color
end

function Label:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== PARAGRAPH ====================
function Paragraph.new(section, config)
    local self = setmetatable({}, Paragraph)
    
    self.Section = section
    self.Theme = section.Theme
    self.Title = config.Title or ""
    self.Text = config.Text or "Paragraph text"
    self.Size = config.Size or 12
    
    self:_CreateParagraph()
    
    return self
end

function Paragraph:_CreateParagraph()
    local container = Instance.new("Frame")
    container.Name = "Paragraph"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundColor3 = self.Theme.BackgroundTertiary
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local containerPadding = Instance.new("UIPadding")
    containerPadding.PaddingTop = UDim.new(0, 10)
    containerPadding.PaddingBottom = UDim.new(0, 10)
    containerPadding.PaddingLeft = UDim.new(0, 12)
    containerPadding.PaddingRight = UDim.new(0, 12)
    containerPadding.Parent = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 6)
    containerLayout.Parent = container
    
    if self.Title and self.Title ~= "" then
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.fromScale(1, 0)
        title.AutomaticSize = Enum.AutomaticSize.Y
        title.BackgroundTransparency = 1
        title.Text = self.Title
        title.TextColor3 = self.Theme.TextPrimary
        title.TextSize = 13
        title.FontFace = self.Theme.Font.Bold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = container
        self.TitleLabel = title
    end
    
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.fromScale(1, 0)
    text.AutomaticSize = Enum.AutomaticSize.Y
    text.BackgroundTransparency = 1
    text.Text = self.Text
    text.TextColor3 = self.Theme.TextSecondary
    text.TextSize = self.Size
    text.FontFace = self.Theme.Font.Main
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Top
    text.Parent = container
    self.TextLabel = text
end

function Paragraph:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Paragraph:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== DIVIDER ====================
function Divider.new(section, config)
    local self = setmetatable({}, Divider)
    
    self.Section = section
    self.Theme = section.Theme
    self.Text = config.Text or ""
    self.Padding = config.Padding or 8
    
    self:_CreateDivider()
    
    return self
end

function Divider:_CreateDivider()
    local container = Instance.new("Frame")
    container.Name = "Divider"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerPadding = Instance.new("UIPadding")
    containerPadding.PaddingTop = UDim.new(0, self.Padding)
    containerPadding.PaddingBottom = UDim.new(0, self.Padding)
    containerPadding.Parent = container
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.Size = UDim2.fromScale(1, 0)
    line.BackgroundColor3 = self.Theme.Border
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = container
    
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(1, 0)
    lineCorner.Parent = line
end

function Divider:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== KEYBIND ====================
function Keybind.new(section, config)
    local self = setmetatable({}, Keybind)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Keybind"
    self.Default = config.Default or Enum.KeyCode.Unknown
    self.Callback = config.Callback or function() end
    self.ChangedCallback = config.ChangedCallback or function() end
    self.Disabled = config.Disabled or false
    self.Value = self.Default
    self.Listening = false
    
    self:_CreateKeybind()
    
    return self
end

function Keybind:_CreateKeybind()
    local container = Instance.new("Frame")
    container.Name = "Keybind"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.FillDirection = Enum.FillDirection.Horizontal
    containerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    containerLayout.Padding = UDim.new(0, 8)
    containerLayout.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = container
    self.Label = label
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Name = "KeyButton"
    keyBtn.Size = UDim2.fromOffset(80, 26)
    keyBtn.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = self:_GetKeyName(self.Value)
    keyBtn.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    keyBtn.TextSize = 12
    keyBtn.FontFace = self.Theme.Font.Mono
    keyBtn.AutoButtonColor = false
    keyBtn.Active = not self.Disabled
    keyBtn.LayoutOrder = 2
    keyBtn.Parent = container
    self.KeyButton = keyBtn
    
    local keyBtnCorner = Instance.new("UICorner")
    keyBtnCorner.CornerRadius = UDim.new(0, 6)
    keyBtnCorner.Parent = keyBtn
    
    local keyBtnStroke = Instance.new("UIStroke")
    keyBtnStroke.Thickness = 1
    keyBtnStroke.Color = self.Theme.InputBorder
    keyBtnStroke.Transparency = 0.5
    keyBtnStroke.Parent = keyBtn
    self.KeyButtonStroke = keyBtnStroke
    
    keyBtn.MouseButton1Click:Connect(function()
        if not self.Disabled and not self.Listening then
            self:StartListening()
        end
    end)
    
    keyBtn.MouseEnter:Connect(function()
        if not self.Disabled and not self.Listening then
            self.Utils:QuickTween(keyBtn, {BackgroundColor3 = self.Theme.CardHover})
        end
    end)
    
    keyBtn.MouseLeave:Connect(function()
        if not self.Disabled and not self.Listening then
            self.Utils:QuickTween(keyBtn, {BackgroundColor3 = self.Theme.InputBackground})
        end
    end)
end

function Keybind:_GetKeyName(keyCode)
    if keyCode == Enum.KeyCode.Unknown then
        return "None"
    end
    
    local name = keyCode.Name
    local replacements = {
        ["LeftControl"] = "LCtrl", ["RightControl"] = "RCtrl",
        ["LeftShift"] = "LShift", ["RightShift"] = "RShift",
        ["LeftAlt"] = "LAlt", ["RightAlt"] = "RAlt",
    }
    
    return replacements[name] or name
end

function Keybind:StartListening()
    self.Listening = true
    self.KeyButton.Text = "..."
    self.KeyButton.TextColor3 = self.Theme.Accent
    self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.Accent})
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local keyCode
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keyCode = input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Listening = false
            self.KeyButton.Text = self:_GetKeyName(self.Value)
            self.KeyButton.TextColor3 = self.Theme.TextSecondary
            self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
            connection:Disconnect()
            return
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyCode = Enum.KeyCode.Unknown
        end
        
        if keyCode then
            self:SetValue(keyCode)
            self.Listening = false
            connection:Disconnect()
        end
    end)
    
    task.delay(5, function()
        if self.Listening then
            self.Listening = false
            self.KeyButton.Text = self:_GetKeyName(self.Value)
            self.KeyButton.TextColor3 = self.Theme.TextSecondary
            self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
            if connection then connection:Disconnect() end
        end
    end)
end

function Keybind:SetValue(keyCode, callback)
    self.Value = keyCode
    self.KeyButton.Text = self:_GetKeyName(keyCode)
    self.KeyButton.TextColor3 = self.Theme.TextSecondary
    self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
    
    if callback ~= false then
        self.ChangedCallback(keyCode)
    end
end

function Keybind:GetValue()
    return self.Value
end

function Keybind:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== COLORPICKER ====================
function ColorPicker.new(section, config)
    local self = setmetatable({}, ColorPicker)
    
    self.Section = section
    self.Window = section.Window
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Color"
    self.Default = config.Default or Color3.fromRGB(255, 255, 255)
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Value = self.Default
    self.Hue = 0
    self.Saturation = 0
    self.Value2 = 1
    self.Open = false
    self.DraggingSaturation = false
    self.DraggingHue = false
    
    self.Hue, self.Saturation, self.Value2 = self.Utils:RGBtoHSV(self.Default)
    
    self:_CreateColorPicker()
    
    return self
end

function ColorPicker:_CreateColorPicker()
    local container = Instance.new("Frame")
    container.Name = "ColorPicker"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.ZIndex = 10
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 6)
    containerLayout.Parent = container
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = container
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Padding = UDim.new(0, 8)
    headerLayout.Parent = header
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = header
    self.Label = label
    
    local preview = Instance.new("TextButton")
    preview.Name = "Preview"
    preview.Size = UDim2.fromOffset(50, 24)
    preview.BackgroundColor3 = self.Value
    preview.BorderSizePixel = 0
    preview.Text = ""
    preview.AutoButtonColor = false
    preview.Active = not self.Disabled
    preview.LayoutOrder = 2
    preview.Parent = header
    self.Preview = preview
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = preview
    
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Thickness = 1
    previewStroke.Color = self.Theme.Border
    previewStroke.Parent = preview
    
    local hexDisplay = Instance.new("TextLabel")
    hexDisplay.Name = "Hex"
    hexDisplay.Size = UDim2.fromOffset(0, 24)
    hexDisplay.AutomaticSize = Enum.AutomaticSize.X
    hexDisplay.BackgroundTransparency = 1
    hexDisplay.Text = self.Utils:Color3ToHex(self.Value)
    hexDisplay.TextColor3 = self.Theme.TextMuted
    hexDisplay.TextSize = 11
    hexDisplay.FontFace = self.Theme.Font.Mono
    hexDisplay.LayoutOrder = 3
    hexDisplay.Parent = header
    self.HexDisplay = hexDisplay
    
    -- Picker container
    local pickerContainer = Instance.new("Frame")
    pickerContainer.Name = "Picker"
    pickerContainer.Size = UDim2.fromScale(1, 0)
    pickerContainer.AutomaticSize = Enum.AutomaticSize.Y
    pickerContainer.BackgroundColor3 = self.Theme.Card
    pickerContainer.BorderSizePixel = 0
    pickerContainer.Visible = false
    pickerContainer.LayoutOrder = 2
    pickerContainer.ZIndex = 9
    pickerContainer.Parent = container
    self.PickerContainer = pickerContainer
    
    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 8)
    pickerCorner.Parent = pickerContainer
    
    local pickerStroke = Instance.new("UIStroke")
    pickerStroke.Thickness = 1
    pickerStroke.Color = self.Theme.Border
    pickerStroke.Parent = pickerContainer
    
    local pickerPadding = Instance.new("UIPadding")
    pickerPadding.PaddingTop = UDim.new(0, 12)
    pickerPadding.PaddingBottom = UDim.new(0, 12)
    pickerPadding.PaddingLeft = UDim.new(0, 12)
    pickerPadding.PaddingRight = UDim.new(0, 12)
    pickerPadding.Parent = pickerContainer
    
    -- Saturation/Value picker
    local satValPicker = Instance.new("TextButton")
    satValPicker.Name = "SaturationValue"
    satValPicker.Size = UDim2.fromOffset(200, 150)
    satValPicker.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    satValPicker.BorderSizePixel = 0
    satValPicker.Text = ""
    satValPicker.AutoButtonColor = false
    satValPicker.ZIndex = 9
    satValPicker.Parent = pickerContainer
    self.SatValPicker = satValPicker
    
    local satValCorner = Instance.new("UICorner")
    satValCorner.CornerRadius = UDim.new(0, 6)
    satValCorner.Parent = satValPicker
    
    local satGradient = Instance.new("UIGradient")
    satGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, 1))
    })
    satGradient.Parent = satValPicker
    self.SatGradient = satGradient
    
    local valGradient = Instance.new("UIGradient")
    valGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    valGradient.Rotation = 90
    valGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    valGradient.Parent = satValPicker
    
    -- SV Cursor
    local svCursor = Instance.new("Frame")
    svCursor.Name = "Cursor"
    svCursor.Size = UDim2.fromOffset(12, 12)
    svCursor.Position = UDim2.fromOffset(self.Saturation * 200 - 6, (1 - self.Value2) * 150 - 6)
    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svCursor.BorderSizePixel = 0
    svCursor.ZIndex = 10
    svCursor.Parent = satValPicker
    self.SVCursor = svCursor
    
    local svCursorCorner = Instance.new("UICorner")
    svCursorCorner.CornerRadius = UDim.new(1, 0)
    svCursorCorner.Parent = svCursor
    
    local svCursorStroke = Instance.new("UIStroke")
    svCursorStroke.Thickness = 2
    svCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    svCursorStroke.Parent = svCursor
    
    -- Hue slider
    local hueSlider = Instance.new("TextButton")
    hueSlider.Name = "HueSlider"
    hueSlider.Size = UDim2.fromOffset(200, 20)
    hueSlider.Position = UDim2.fromOffset(0, 160)
    hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueSlider.BorderSizePixel = 0
    hueSlider.Text = ""
    hueSlider.AutoButtonColor = false
    hueSlider.ZIndex = 9
    hueSlider.Parent = pickerContainer
    self.HueSlider = hueSlider
    
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 6)
    hueCorner.Parent = hueSlider
    
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueSlider
    
    -- Hue cursor
    local hueCursor = Instance.new("Frame")
    hueCursor.Name = "Cursor"
    hueCursor.Size = UDim2.fromOffset(6, 24)
    hueCursor.Position = UDim2.fromOffset(self.Hue * 200 - 3, -2)
    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 10
    hueCursor.Parent = hueSlider
    self.HueCursor = hueCursor
    
    local hueCursorCorner = Instance.new("UICorner")
    hueCursorCorner.CornerRadius = UDim.new(0, 3)
    hueCursorCorner.Parent = hueCursor
    
    local hueCursorStroke = Instance.new("UIStroke")
    hueCursorStroke.Thickness = 1
    hueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    hueCursorStroke.Parent = hueCursor
    
    -- Input handlers
    local function updateSatVal(input)
        local relX = math.clamp((input.Position.X - satValPicker.AbsolutePosition.X) / 200, 0, 1)
        local relY = math.clamp((input.Position.Y - satValPicker.AbsolutePosition.Y) / 150, 0, 1)
        
        self.Saturation = relX
        self.Value2 = 1 - relY
        
        self.SVCursor.Position = UDim2.fromOffset(relX * 200 - 6, relY * 150 - 6)
        self:_UpdateColor()
    end
    
    local function updateHue(input)
        local relX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / 200, 0, 1)
        self.Hue = relX
        self.HueCursor.Position = UDim2.fromOffset(relX * 200 - 3, -2)
        self:_UpdateColor()
    end
    
    satValPicker.MouseButton1Down:Connect(function(input)
        self.DraggingSaturation = true
        updateSatVal(input)
    end)
    
    hueSlider.MouseButton1Down:Connect(function(input)
        self.DraggingHue = true
        updateHue(input)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.DraggingSaturation = false
            self.DraggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if self.DraggingSaturation then
                updateSatVal(input)
            elseif self.DraggingHue then
                updateHue(input)
            end
        end
    end)
    
    preview.MouseButton1Click:Connect(function()
        if not self.Disabled then
            if self.Open then
                self:Close()
            else
                self:Open()
            end
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if self.Open and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local containerPos = container.AbsolutePosition
            local containerSize = container.AbsoluteSize
            
            if mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or
               mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y then
                self:Close()
            end
        end
    end)
end

function ColorPicker:_UpdateColor()
    self.Value = Color3.fromHSV(self.Hue, self.Saturation, self.Value2)
    self.Preview.BackgroundColor3 = self.Value
    self.HexDisplay.Text = self.Utils:Color3ToHex(self.Value)
    
    self.SatGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, 1))
    })
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

function ColorPicker:Open()
    self.Open = true
    self.PickerContainer.Visible = true
end

function ColorPicker:Close()
    self.Open = false
    self.PickerContainer.Visible = false
end

function ColorPicker:SetValue(color, callback)
    self.Value = color
    self.Hue, self.Saturation, self.Value2 = self.Utils:RGBtoHSV(color)
    
    self.Preview.BackgroundColor3 = color
    self.HexDisplay.Text = self.Utils:Color3ToHex(color)
    
    self.SVCursor.Position = UDim2.fromOffset(self.Saturation * 200 - 6, (1 - self.Value2) * 150 - 6)
    self.HueCursor.Position = UDim2.fromOffset(self.Hue * 200 - 3, -2)
    
    self:_UpdateColor()
    
    if callback ~= false and self.Callback then
        self.Callback(color)
    end
end

function ColorPicker:GetValue()
    return self.Value
end

function ColorPicker:SetDisabled(disabled)
    self.Disabled = disabled
    self.Preview.Active = not disabled
end

function ColorPicker:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== PROGRESS ====================
function Progress.new(section, config)
    local self = setmetatable({}, Progress)
    
    self.Section = section
    self.Theme = section.Theme
    self.Utils = section.Utils
    self.Text = config.Text or "Progress"
    self.Default = config.Default or 0
    self.Max = config.Max or 100
    self.ShowPercentage = config.ShowPercentage ~= false
    self.Color = config.Color
    self.Value = self.Default
    
    self:_CreateProgress()
    
    return self
end

function Progress:_CreateProgress()
    local container = Instance.new("Frame")
    container.Name = "Progress"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = container
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.Parent = header
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = header
    self.Label = label
    
    if self.ShowPercentage then
        local percentage = Instance.new("TextLabel")
        percentage.Name = "Percentage"
        percentage.Size = UDim2.fromOffset(0, 0)
        percentage.AutomaticSize = Enum.AutomaticSize.XY
        percentage.BackgroundTransparency = 1
        percentage.Text = math.floor(self.Value / self.Max * 100) .. "%"
        percentage.TextColor3 = self.Theme.TextMuted
        percentage.TextSize = 12
        percentage.FontFace = self.Theme.Font.Mono
        percentage.TextXAlignment = Enum.TextXAlignment.Right
        percentage.LayoutOrder = 2
        percentage.Parent = header
        self.Percentage = percentage
    end
    
    -- Track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.fromScale(1, 0)
    track.AutomaticSize = Enum.AutomaticSize.Y
    track.BackgroundColor3 = self.Theme.Border
    track.BackgroundTransparency = 0.5
    track.BorderSizePixel = 0
    track.LayoutOrder = 2
    track.Parent = container
    self.Track = track
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local trackPadding = Instance.new("UIPadding")
    trackPadding.PaddingTop = UDim.new(0, 4)
    trackPadding.PaddingBottom = UDim.new(0, 4)
    trackPadding.Parent = track
    
    -- Fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.fromScale(self.Value / self.Max, 1)
    fill.BackgroundColor3 = self.Color or self.Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    self.Fill = fill
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
end

function Progress:SetValue(value, animate)
    self.Value = math.clamp(value, 0, self.Max)
    local percent = self.Value / self.Max
    
    if animate ~= false then
        self.Utils:Tween(self.Fill, self.Theme.Animation.Normal, {
            Size = UDim2.fromScale(percent, 1)
        })
    else
        self.Fill.Size = UDim2.fromScale(percent, 1)
    end
    
    if self.ShowPercentage and self.Percentage then
        self.Percentage.Text = math.floor(percent * 100) .. "%"
    end
end

function Progress:GetValue()
    return self.Value
end

function Progress:Increment(amount)
    self:SetValue(self.Value + (amount or 1))
end

function Progress:Reset()
    self:SetValue(0)
end

function Progress:UpdateAccentColor(color)
    if not self.Color then
        self.Fill.BackgroundColor3 = color
    end
end

function Progress:Destroy()
    if self.Container then self.Container:Destroy() end
end

-- ==================== NOTIFICATION ====================
function Notification.new(library, config)
    local self = setmetatable({}, Notification)
    
    self.Library = library
    self.Theme = library.Theme
    self.Utils = library.Utils
    self.Title = config.Title or "Notification"
    self.Content = config.Content or ""
    self.Duration = config.Duration or 5
    self.Type = config.Type or "Info"
    self.Callback = config.Callback
    
    self:_CreateNotification()
    
    return self
end

function Notification:_GetContainer()
    if not Notification._Container then
        local container = Instance.new("Frame")
        container.Name = "Notifications"
        container.Size = UDim2.fromScale(1, 1)
        container.BackgroundTransparency = 1
        container.IgnoreGuiInset = true
        container.Parent = CoreGui
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 50)
        padding.PaddingRight = UDim.new(0, 20)
        padding.Parent = container
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Padding = UDim.new(0, 10)
        layout.Parent = container
        
        Notification._Container = container
        table.insert(self.Library._Objects, container)
    end
    
    return Notification._Container
end

function Notification:_CreateNotification()
    local statusColors = {
        Info = self.Theme.Info,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error,
    }
    local statusColor = statusColors[self.Type] or self.Theme.Info
    
    local container = Instance.new("Frame")
    container.Name = "Notification"
    container.Size = UDim2.fromOffset(300, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundColor3 = self.Theme.Card
    container.BorderSizePixel = 0
    container.Parent = self:_GetContainer()
    self.Container = container
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Thickness = 1
    containerStroke.Color = self.Theme.Border
    containerStroke.Parent = container
    
    -- Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.fromOffset(4, 0)
    indicator.BackgroundColor3 = statusColor
    indicator.BorderSizePixel = 0
    indicator.Parent = container
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    -- Content
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.fromScale(1, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Parent = container
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.Parent = content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 4)
    contentLayout.Parent = content
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Parent = content
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Parent = header
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.fromOffset(18, 18)
    icon.BackgroundTransparency = 1
    icon.Text = self:_GetIcon()
    icon.TextColor3 = statusColor
    icon.TextSize = 14
    icon.FontFace = self.Theme.Font.Bold
    icon.LayoutOrder = 1
    icon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 0)
    title.AutomaticSize = Enum.AutomaticSize.XY
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = self.Theme.TextPrimary
    title.TextSize = 14
    title.FontFace = self.Theme.Font.Bold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 2
    title.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.TextMuted
    closeBtn.TextSize = 16
    closeBtn.FontFace = self.Theme.Font.Bold
    closeBtn.LayoutOrder = 3
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Dismiss()
    end)
    
    -- Content text
    if self.Content and self.Content ~= "" then
        local contentText = Instance.new("TextLabel")
        contentText.Name = "Text"
        contentText.Size = UDim2.fromScale(1, 0)
        contentText.AutomaticSize = Enum.AutomaticSize.Y
        contentText.BackgroundTransparency = 1
        contentText.Text = self.Content
        contentText.TextColor3 = self.Theme.TextSecondary
        contentText.TextSize = 12
        contentText.FontFace = self.Theme.Font.Main
        contentText.TextWrapped = true
        contentText.TextXAlignment = Enum.TextXAlignment.Left
        contentText.TextYAlignment = Enum.TextYAlignment.Top
        contentText.Parent = content
    end
    
    -- Animate in
    container.Position = UDim2.fromScale(1.2, 0)
    self.Utils:Tween(container, self.Theme.Animation.Normal, {
        Position = UDim2.fromScale(0, 0)
    })
    
    -- Auto-dismiss
    self.StartTime = tick()
    self.RemainingTime = self.Duration
    
    self.TimerConnection = RunService.Heartbeat:Connect(function()
        if not self.Paused then
            self.RemainingTime = self.RemainingTime - RunService.Heartbeat:Wait()
            if self.RemainingTime <= 0 then
                self:Dismiss()
            end
        end
    end)
    
    container.MouseEnter:Connect(function()
        self.Paused = true
    end)
    
    container.MouseLeave:Connect(function()
        self.Paused = false
    end)
end

function Notification:_GetIcon()
    local icons = {
        Info = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Error = "✕",
    }
    return icons[self.Type] or "ℹ"
end

function Notification:Dismiss()
    if self.Dismissing then return end
    self.Dismissing = true
    
    if self.TimerConnection then
        self.TimerConnection:Disconnect()
    end
    
    self.Utils:Tween(self.Container, self.Theme.Animation.Fast, {
        Position = UDim2.fromScale(1.2, 0),
        BackgroundTransparency = 1
    })
    
    task.delay(0.2, function()
        if self.Callback then self.Callback() end
        self.Container:Destroy()
    end)
end

-- ==================== MAIN LIBRARY ====================
local Atomic = {
    Version = "1.0.0",
    Author = "Atomic Team",
    _Objects = {},
    _Connections = {},
    _Windows = {},
}

Atomic.Theme = Theme
Atomic.Utils = Utils

function Atomic:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Atomic",
        Size = config.Size or UDim2.fromOffset(580, 400),
        Position = config.Position or UDim2.fromOffset(100, 100),
        Theme = config.Theme or "Dark",
        AccentColor = config.AccentColor or self.Theme.Accent,
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        ShowToggleButton = config.ShowToggleButton ~= false,
        Draggable = config.Draggable ~= false,
        Minimizable = config.Minimizable ~= false,
    }
    
    local window = Window.new(self, windowConfig)
    table.insert(self._Windows, window)
    
    return window
end

function Atomic:Notify(config)
    config = config or {}
    
    local notificationConfig = {
        Title = config.Title or "Notification",
        Content = config.Content or "",
        Duration = config.Duration or 5,
        Type = config.Type or "Info",
        Callback = config.Callback,
    }
    
    return Notification.new(self, notificationConfig)
end

function Atomic:Cleanup()
    for _, connection in ipairs(self._Connections) do
        if connection.Disconnect then
            connection:Disconnect()
        end
    end
    
    for _, object in ipairs(self._Objects) do
        if object.Destroy then
            object:Destroy()
        end
    end
    
    self._Connections = {}
    self._Objects = {}
    self._Windows = {}
end

function Atomic:GetWindows()
    return self._Windows
end

function Atomic:SetAccentColor(color)
    self.Theme.Accent = color
    for _, window in ipairs(self._Windows) do
        window:UpdateAccentColor(color)
    end
end

return Atomic
