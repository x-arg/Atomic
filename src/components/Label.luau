--[[
    Atomic UI Library - Label Component
    Simple text label
]]

local Label = {}
Label.__index = Label

function Label.new(section, config)
    local self = setmetatable({}, Label)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Label"
    self.Size = config.Size or 13
    self.Color = config.Color
    self.Wrap = config.Wrap ~= false
    self.Center = config.Center or false
    
    self:_CreateLabel()
    
    return self
end

function Label:_CreateLabel()
    -- Container
    local container = Instance.new("Frame")
    container.Name = "Label"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.fromScale(1, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = self.Color or self.Theme.TextSecondary
    label.TextSize = self.Size
    label.FontFace = self.Theme.Font.Main
    label.TextWrapped = self.Wrap
    label.TextXAlignment = self.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
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

function Label:SetSize(size)
    self.Size = size
    self.Label.TextSize = size
end

function Label:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Label
