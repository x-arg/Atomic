--[[
    Atomic UI Library - Tooltip Component
    Hover tooltip display
]]

local UserInputService = game:GetService("UserInputService")

local Tooltip = {}
Tooltip.__index = Tooltip

function Tooltip.new(library, parent, config)
    local self = setmetatable({}, Tooltip)
    
    self.Library = library
    self.Theme = library.Theme
    self.Utils = library.Utils
    
    self.Config = config
    self.Text = config.Text or "Tooltip"
    self.Position = config.Position or "Top" -- Top, Bottom, Left, Right
    self.Delay = config.Delay or 0.5
    
    self.Visible = false
    self.ShowTimer = nil
    
    self:_CreateTooltip(parent)
    
    return self
end

function Tooltip:_CreateTooltip(parent)
    -- Tooltip container
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.fromOffset(0, 0)
    tooltip.AutomaticSize = Enum.AutomaticSize.XY
    tooltip.BackgroundColor3 = self.Theme.CardActive
    tooltip.BackgroundTransparency = 0
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 100
    tooltip.Parent = parent
    self.Tooltip = tooltip
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 4)
    tooltipCorner.Parent = tooltip
    
    local tooltipStroke = Instance.new("UIStroke")
    tooltipStroke.Thickness = 1
    tooltipStroke.Color = self.Theme.Border
    tooltipStroke.Parent = tooltip
    
    local tooltipPadding = Instance.new("UIPadding")
    tooltipPadding.PaddingTop = UDim.new(0, 6)
    tooltipPadding.PaddingBottom = UDim.new(0, 6)
    tooltipPadding.PaddingLeft = UDim.new(0, 10)
    tooltipPadding.PaddingRight = UDim.new(0, 10)
    tooltipPadding.Parent = tooltip
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.fromOffset(0, 0)
    text.AutomaticSize = Enum.AutomaticSize.XY
    text.BackgroundTransparency = 1
    text.Text = self.Text
    text.TextColor3 = self.Theme.TextPrimary
    text.TextSize = 12
    text.FontFace = self.Theme.Font.Main
    text.Parent = tooltip
    self.TextLabel = text
    
    -- Show/hide on hover
    parent.MouseEnter:Connect(function()
        self:Show()
    end)
    
    parent.MouseLeave:Connect(function()
        self:Hide()
    end)
end

function Tooltip:Show()
    if self.ShowTimer then
        task.cancel(self.ShowTimer)
    end
    
    self.ShowTimer = task.delay(self.Delay, function()
        self.Visible = true
        self.Tooltip.Visible = true
        
        -- Calculate position
        local parent = self.Tooltip.Parent
        local parentSize = parent.AbsoluteSize
        local tooltipSize = self.Tooltip.AbsoluteSize
        
        local position
        local offset = 8
        
        if self.Position == "Top" then
            position = UDim2.fromOffset(
                (parentSize.X - tooltipSize.X) / 2,
                -tooltipSize.Y - offset
            )
        elseif self.Position == "Bottom" then
            position = UDim2.fromOffset(
                (parentSize.X - tooltipSize.X) / 2,
                parentSize.Y + offset
            )
        elseif self.Position == "Left" then
            position = UDim2.fromOffset(
                -tooltipSize.X - offset,
                (parentSize.Y - tooltipSize.Y) / 2
            )
        elseif self.Position == "Right" then
            position = UDim2.fromOffset(
                parentSize.X + offset,
                (parentSize.Y - tooltipSize.Y) / 2
            )
        end
        
        self.Tooltip.Position = position or UDim2.fromOffset(0, 0)
        
        -- Animate in
        self.Tooltip.BackgroundTransparency = 1
        self.Utils:QuickTween(self.Tooltip, {BackgroundTransparency = 0})
    end)
end

function Tooltip:Hide()
    if self.ShowTimer then
        task.cancel(self.ShowTimer)
        self.ShowTimer = nil
    end
    
    self.Visible = false
    self.Utils:QuickTween(self.Tooltip, {BackgroundTransparency = 1})
    
    task.delay(0.2, function()
        self.Tooltip.Visible = false
    end)
end

function Tooltip:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Tooltip:Destroy()
    if self.ShowTimer then
        task.cancel(self.ShowTimer)
    end
    if self.Tooltip then
        self.Tooltip:Destroy()
    end
end

return Tooltip
