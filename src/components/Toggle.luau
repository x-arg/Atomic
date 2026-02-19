--[[
    Atomic UI Library - Toggle Component
    Boolean toggle switch
]]

local TweenService = game:GetService("TweenService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, config)
    local self = setmetatable({}, Toggle)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Toggle"
    self.Default = config.Default or false
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    
    self.Value = self.Default
    
    self:_CreateToggle()
    
    return self
end

function Toggle:_CreateToggle()
    -- Container
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
    
    -- Toggle button area
    local toggleArea = Instance.new("TextButton")
    toggleArea.Name = "ToggleArea"
    toggleArea.Size = UDim2.fromOffset(40, 22)
    toggleArea.BackgroundColor3 = self.Value and self.Theme.Accent or self.Theme.Border
    toggleArea.BackgroundTransparency = 0
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
    
    -- Toggle knob
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
    label.LayoutOrder = 2
    label.Parent = container
    self.Label = label
    
    -- Click handler
    toggleArea.MouseButton1Click:Connect(function()
        if not self.Disabled then
            self:SetValue(not self.Value)
        end
    end)
    
    -- Hover effects
    toggleArea.MouseEnter:Connect(function()
        if not self.Disabled then
            if self.Value then
                self.Utils:QuickTween(toggleArea, {BackgroundColor3 = self.Theme.AccentHover})
            else
                self.Utils:QuickTween(toggleArea, {BackgroundColor3 = self.Theme.BorderLight})
            end
        end
    end)
    
    toggleArea.MouseLeave:Connect(function()
        if not self.Disabled then
            if self.Value then
                self.Utils:QuickTween(toggleArea, {BackgroundColor3 = self.Theme.Accent})
            else
                self.Utils:QuickTween(toggleArea, {BackgroundColor3 = self.Theme.Border})
            end
        end
    end)
end

function Toggle:SetValue(value, callback)
    self.Value = value
    
    if value then
        self.Utils:Tween(self.Knob, self.Theme.Animation.Fast, {
            Position = UDim2.fromOffset(20, 2)
        })
        self.Utils:Tween(self.ToggleArea, self.Theme.Animation.Fast, {
            BackgroundColor3 = self.Theme.Accent
        })
    else
        self.Utils:Tween(self.Knob, self.Theme.Animation.Fast, {
            Position = UDim2.fromOffset(2, 2)
        })
        self.Utils:Tween(self.ToggleArea, self.Theme.Animation.Fast, {
            BackgroundColor3 = self.Theme.Border
        })
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
    self.Label.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
end

function Toggle:UpdateAccentColor(color)
    if self.Value then
        self.ToggleArea.BackgroundColor3 = color
    end
end

function Toggle:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Toggle
