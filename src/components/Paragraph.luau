--[[
    Atomic UI Library - Paragraph Component
    Multi-line text display
]]

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(section, config)
    local self = setmetatable({}, Paragraph)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Title = config.Title or ""
    self.Text = config.Text or "Paragraph text"
    self.Size = config.Size or 12
    
    self:_CreateParagraph()
    
    return self
end

function Paragraph:_CreateParagraph()
    -- Container
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
    
    -- Title (if provided)
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
    
    -- Text
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

function Paragraph:SetTitle(title)
    self.Title = title
    if self.TitleLabel then
        self.TitleLabel.Text = title
    end
end

function Paragraph:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Paragraph
