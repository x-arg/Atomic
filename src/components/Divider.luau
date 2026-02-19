--[[
    Atomic UI Library - Divider Component
    Horizontal separator line
]]

local Divider = {}
Divider.__index = Divider

function Divider.new(section, config)
    local self = setmetatable({}, Divider)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or ""
    self.Padding = config.Padding or 8
    
    self:_CreateDivider()
    
    return self
end

function Divider:_CreateDivider()
    -- Container
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
    
    if self.Text and self.Text ~= "" then
        -- Divider with text
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 10)
        layout.Parent = container
        
        -- Left line
        local leftLine = Instance.new("Frame")
        leftLine.Name = "LeftLine"
        leftLine.Size = UDim2.fromScale(1, 0)
        leftLine.AutomaticSize = Enum.AutomaticSize.X
        leftLine.BackgroundColor3 = self.Theme.Border
        leftLine.BackgroundTransparency = 0.3
        leftLine.BorderSizePixel = 0
        leftLine.LayoutOrder = 1
        leftLine.Parent = container
        
        local leftLineLayout = Instance.new("UIListLayout")
        leftLineLayout.Parent = leftLine
        
        -- Text
        local text = Instance.new("TextLabel")
        text.Name = "Text"
        text.Size = UDim2.fromOffset(0, 0)
        text.AutomaticSize = Enum.AutomaticSize.XY
        text.BackgroundTransparency = 1
        text.Text = self.Text
        text.TextColor3 = self.Theme.TextMuted
        text.TextSize = 11
        text.FontFace = self.Theme.Font.Main
        text.LayoutOrder = 2
        text.Parent = container
        self.TextLabel = text
        
        -- Right line
        local rightLine = Instance.new("Frame")
        rightLine.Name = "RightLine"
        rightLine.Size = UDim2.fromScale(1, 0)
        rightLine.AutomaticSize = Enum.AutomaticSize.X
        rightLine.BackgroundColor3 = self.Theme.Border
        rightLine.BackgroundTransparency = 0.3
        rightLine.BorderSizePixel = 0
        rightLine.LayoutOrder = 3
        rightLine.Parent = container
        
        local rightLineLayout = Instance.new("UIListLayout")
        rightLineLayout.Parent = rightLine
    else
        -- Simple line
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
end

function Divider:SetText(text)
    self.Text = text
    if self.TextLabel then
        self.TextLabel.Text = text
    end
end

function Divider:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Divider
