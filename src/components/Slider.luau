--[[
    Atomic UI Library - Slider Component
    Range slider for numeric input
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Slider = {}
Slider.__index = Slider

function Slider.new(section, config)
    local self = setmetatable({}, Slider)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
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
    -- Container
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
    
    -- Header row (label + value display)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = container
    self.Header = header
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Parent = header
    
    -- Label
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
    
    -- Value display
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
    
    -- Slider track container
    local trackContainer = Instance.new("Frame")
    trackContainer.Name = "TrackContainer"
    trackContainer.Size = UDim2.fromScale(1, 0)
    trackContainer.AutomaticSize = Enum.AutomaticSize.Y
    trackContainer.BackgroundTransparency = 1
    trackContainer.LayoutOrder = 2
    trackContainer.Parent = container
    self.TrackContainer = trackContainer
    
    local trackPadding = Instance.new("UIPadding")
    trackPadding.PaddingTop = UDim.new(0, 4)
    trackPadding.PaddingBottom = UDim.new(0, 4)
    trackPadding.Parent = trackContainer
    
    -- Slider track
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.Size = UDim2.fromScale(1, 0)
    track.AutomaticSize = Enum.AutomaticSize.Y
    track.BackgroundColor3 = self.Theme.Border
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.Active = not self.Disabled
    track.Parent = trackContainer
    self.Track = track
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Track inner padding
    local trackInnerPadding = Instance.new("UIPadding")
    trackInnerPadding.PaddingTop = UDim.new(0, 6)
    trackInnerPadding.PaddingBottom = UDim.new(0, 6)
    trackInnerPadding.Parent = track
    
    -- Fill bar
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
    
    -- Slider knob
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
    
    -- Drag handlers
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
    
    -- Hover effects
    track.MouseEnter:Connect(function()
        if not self.Disabled then
            self.Utils:QuickTween(self.Knob, {Size = UDim2.fromOffset(18, 18)})
        end
    end)
    
    track.MouseLeave:Connect(function()
        if not self.Dragging then
            self.Utils:QuickTween(self.Knob, {Size = UDim2.fromOffset(16, 16)})
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
    self.Label.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    self.ValueDisplay.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    self.Fill.BackgroundColor3 = disabled and self.Theme.Border or self.Theme.Accent
end

function Slider:UpdateAccentColor(color)
    self.Fill.BackgroundColor3 = color
    self.KnobStroke.Color = color
end

function Slider:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Slider
