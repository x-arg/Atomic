--[[
    Atomic UI Library - Tab Component
    Tab container for organizing content
]]

local Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Library = window.Library
    self.Theme = window.Theme
    self.Utils = window.Utils
    
    self.Config = config
    self.Name = config.Name or "Tab"
    self.Icon = config.Icon
    
    self.Sections = {}
    self.Visible = false
    self.Selected = false
    
    self:_CreateTab()
    
    return self
end

function Tab:_CreateTab()
    -- Tab button in header
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
    
    -- Hover effect
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
    
    -- Click handler
    tabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Tab content container
    local content = Instance.new("ScrollingFrame")
    content.Name = self.Name .. "_Content"
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundColor3 = self.Theme.Background
    content.BackgroundTransparency = 0
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
    contentPadding.PaddingLeft = UDim.new(0, 0)
    contentPadding.PaddingRight = UDim.new(0, 0)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.Parent = content
    
    -- Columns container
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
    config = config or {}
    
    local Section = require(script.Parent:WaitForChild("Section"))
    local section = Section.new(self, config)
    table.insert(self.Sections, section)
    
    return section
end

function Tab:UpdateAccentColor(color)
    for _, section in ipairs(self.Sections) do
        section:UpdateAccentColor(color)
    end
end

function Tab:Destroy()
    -- Destroy all sections
    for _, section in ipairs(self.Sections) do
        section:Destroy()
    end
    
    -- Destroy button and content
    if self.Button then
        self.Button:Destroy()
    end
    if self.Content then
        self.Content:Destroy()
    end
end

return Tab
