--[[
    Atomic UI Library - Section Component
    Section container for grouping elements
]]

local Section = {}
Section.__index = Section

function Section.new(tab, config)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Window = tab.Window
    self.Library = tab.Library
    self.Theme = tab.Theme
    self.Utils = tab.Utils
    
    self.Config = config
    self.Name = config.Name or "Section"
    self.Column = config.Column or 1
    
    self.Elements = {}
    
    self:_CreateSection()
    
    return self
end

function Section:_CreateSection()
    -- Column container
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
    
    -- Section frame
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
    self.Stroke = sectionStroke
    
    -- Section header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Parent = section
    self.Header = header
    
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
    
    -- Divider line
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -24, 0, 1)
    divider.Position = UDim2.fromOffset(12, 0)
    divider.BackgroundColor3 = self.Theme.Border
    divider.BackgroundTransparency = 0.3
    divider.BorderSizePixel = 0
    divider.Parent = header
    self.Divider = divider
    
    -- Content container
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
    config = config or {}
    
    local Button = require(script.Parent:WaitForChild("Button"))
    local button = Button.new(self, config)
    table.insert(self.Elements, button)
    
    return button
end

function Section:AddToggle(config)
    config = config or {}
    
    local Toggle = require(script.Parent:WaitForChild("Toggle"))
    local toggle = Toggle.new(self, config)
    table.insert(self.Elements, toggle)
    
    return toggle
end

function Section:AddSlider(config)
    config = config or {}
    
    local Slider = require(script.Parent:WaitForChild("Slider"))
    local slider = Slider.new(self, config)
    table.insert(self.Elements, slider)
    
    return slider
end

function Section:AddTextBox(config)
    config = config or {}
    
    local TextBox = require(script.Parent:WaitForChild("TextBox"))
    local textBox = TextBox.new(self, config)
    table.insert(self.Elements, textBox)
    
    return textBox
end

function Section:AddDropdown(config)
    config = config or {}
    
    local Dropdown = require(script.Parent:WaitForChild("Dropdown"))
    local dropdown = Dropdown.new(self, config)
    table.insert(self.Elements, dropdown)
    
    return dropdown
end

function Section:AddLabel(config)
    config = config or {}
    
    local Label = require(script.Parent:WaitForChild("Label"))
    local label = Label.new(self, config)
    table.insert(self.Elements, label)
    
    return label
end

function Section:AddParagraph(config)
    config = config or {}
    
    local Paragraph = require(script.Parent:WaitForChild("Paragraph"))
    local paragraph = Paragraph.new(self, config)
    table.insert(self.Elements, paragraph)
    
    return paragraph
end

function Section:AddDivider(config)
    config = config or {}
    
    local Divider = require(script.Parent:WaitForChild("Divider"))
    local divider = Divider.new(self, config)
    table.insert(self.Elements, divider)
    
    return divider
end

function Section:AddKeybind(config)
    config = config or {}
    
    local Keybind = require(script.Parent:WaitForChild("Keybind"))
    local keybind = Keybind.new(self, config)
    table.insert(self.Elements, keybind)
    
    return keybind
end

function Section:AddColorPicker(config)
    config = config or {}
    
    local ColorPicker = require(script.Parent:WaitForChild("ColorPicker"))
    local colorPicker = ColorPicker.new(self, config)
    table.insert(self.Elements, colorPicker)
    
    return colorPicker
end

function Section:AddProgress(config)
    config = config or {}
    
    local Progress = require(script.Parent:WaitForChild("Progress"))
    local progress = Progress.new(self, config)
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
    -- Destroy all elements
    for _, element in ipairs(self.Elements) do
        if element.Destroy then
            element:Destroy()
        end
    end
    
    -- Destroy frame
    if self.Frame then
        self.Frame:Destroy()
    end
end

return Section
