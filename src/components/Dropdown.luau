--[[
    Atomic UI Library - Dropdown Component
    Selection dropdown menu
]]

local UserInputService = game:GetService("UserInputService")

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, config)
    local self = setmetatable({}, Dropdown)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Dropdown"
    self.Options = config.Options or {}
    self.Default = config.Default or (self.Options[1] if #self.Options > 0 else nil)
    self.MultiSelect = config.MultiSelect or false
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.MaxVisible = config.MaxVisible or 6
    
    self.Value = self.MultiSelect and {} or self.Default
    self.Open = false
    
    self:_CreateDropdown()
    
    return self
end

function Dropdown:_CreateDropdown()
    -- Container
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
    
    -- Label
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
    
    -- Dropdown button
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = "Button"
    dropdownBtn.Size = UDim2.fromScale(1, 0)
    dropdownBtn.AutomaticSize = Enum.AutomaticSize.Y
    dropdownBtn.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    dropdownBtn.BackgroundTransparency = 0
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
    
    -- Arrow indicator
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.fromOffset(20, 20)
    arrow.Position = UDim2.fromScale(1, 0.5)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextMuted
    arrow.TextSize = 10
    arrow.FontFace = self.Theme.Font.Bold
    arrow.ZIndex = 11
    arrow.Parent = dropdownBtn
    self.Arrow = arrow
    
    -- Options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.fromScale(1, 0)
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.BackgroundColor3 = self.Theme.Card
    optionsContainer.BackgroundTransparency = 0
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
    
    -- Create option buttons
    self.OptionButtons = {}
    for i, option in ipairs(self.Options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Name = "Option_" .. tostring(i)
        optionBtn.Size = UDim2.fromScale(1, 0)
        optionBtn.AutomaticSize = Enum.AutomaticSize.Y
        optionBtn.BackgroundColor3 = self.Theme.Card
        optionBtn.BackgroundTransparency = 0
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
        
        -- Hover effect
        optionBtn.MouseEnter:Connect(function()
            self.Utils:QuickTween(optionBtn, {BackgroundColor3 = self.Theme.CardHover})
        end)
        
        optionBtn.MouseLeave:Connect(function()
            self.Utils:QuickTween(optionBtn, {BackgroundColor3 = self.Theme.Card})
        end)
        
        -- Click handler
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
    
    -- Update selection display
    self:_UpdateDisplay()
    
    -- Toggle dropdown
    dropdownBtn.MouseButton1Click:Connect(function()
        if not self.Disabled then
            if self.Open then
                self:Close()
            else
                self:Open()
            end
        end
    end)
    
    -- Close on click outside
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
        
        -- Update option button states
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
            
            -- Update option button states
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

function Dropdown:SetOptions(options)
    self.Options = options
    -- Clear existing option buttons
    for _, btn in pairs(self.OptionButtons) do
        btn:Destroy()
    end
    self.OptionButtons = {}
    
    -- Recreate option buttons
    for i, option in ipairs(self.Options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Name = "Option_" .. tostring(i)
        optionBtn.Size = UDim2.fromScale(1, 0)
        optionBtn.AutomaticSize = Enum.AutomaticSize.Y
        optionBtn.BackgroundColor3 = self.Theme.Card
        optionBtn.BackgroundTransparency = 0
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = "  " .. tostring(option)
        optionBtn.TextColor3 = self.Theme.TextSecondary
        optionBtn.TextSize = 13
        optionBtn.FontFace = self.Theme.Font.Main
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        optionBtn.AutoButtonColor = false
        optionBtn.ZIndex = 9
        optionBtn.Parent = self.OptionsContainer
        
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
end

function Dropdown:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Dropdown:SetDisabled(disabled)
    self.Disabled = disabled
    self.Button.Active = not disabled
    self.Label.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    self.Button.BackgroundColor3 = disabled and self.Theme.Border or self.Theme.InputBackground
    self.Button.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    
    if disabled and self.Open then
        self:Close()
    end
end

function Dropdown:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Dropdown
