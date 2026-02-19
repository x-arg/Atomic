--[[
    Atomic UI Library - Progress Component
    Progress bar display
]]

local Progress = {}
Progress.__index = Progress

function Progress.new(section, config)
    local self = setmetatable({}, Progress)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
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
    -- Container
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
    
    -- Header row
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
    label.TextColor3 = self.Theme.TextPrimary
    label.TextSize = 13
    label.FontFace = self.Theme.Font.Main
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = header
    self.Label = label
    
    -- Percentage display
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
    fill.BackgroundTransparency = 0
    fill.BorderSizePixel = 0
    fill.Parent = track
    self.Fill = fill
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Gradient overlay for visual effect
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    fillGradient.Rotation = 90
    fillGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    fillGradient.Parent = fill
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

function Progress:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Progress:SetColor(color)
    self.Color = color
    self.Fill.BackgroundColor3 = color
end

function Progress:SetMax(max)
    self.Max = max
    self:SetValue(self.Value)
end

function Progress:Increment(amount)
    self:SetValue(self.Value + (amount or 1))
end

function Progress:Decrement(amount)
    self:SetValue(self.Value - (amount or 1))
end

function Progress:Reset()
    self:SetValue(0)
end

function Progress:Complete()
    self:SetValue(self.Max)
end

function Progress:UpdateAccentColor(color)
    if not self.Color then
        self.Fill.BackgroundColor3 = color
    end
end

function Progress:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Progress
