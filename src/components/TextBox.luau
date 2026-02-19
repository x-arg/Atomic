--[[
    Atomic UI Library - TextBox Component
    Text input field
]]

local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(section, config)
    local self = setmetatable({}, TextBox)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or ""
    self.Placeholder = config.Placeholder or "Enter text..."
    self.Label = config.Label or ""
    self.Numeric = config.Numeric or false
    self.MaxLength = config.MaxLength or 200
    self.ClearOnFocus = config.ClearOnFocus or false
    self.Callback = config.Callback or function() end
    self.ChangedCallback = config.ChangedCallback or function() end
    self.Disabled = config.Disabled or false
    
    self:_CreateTextBox()
    
    return self
end

function TextBox:_CreateTextBox()
    -- Container
    local container = Instance.new("Frame")
    container.Name = "TextBox"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container
    
    -- Label (if provided)
    if self.Label and self.Label ~= "" then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.fromScale(1, 0)
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.BackgroundTransparency = 1
        label.Text = self.Label
        label.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
        label.TextSize = 13
        label.FontFace = self.Theme.Font.Main
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = 1
        label.Parent = container
        self.LabelElement = label
    end
    
    -- Input container
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.fromScale(1, 0)
    inputContainer.AutomaticSize = Enum.AutomaticSize.Y
    inputContainer.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    inputContainer.BackgroundTransparency = 0
    inputContainer.BorderSizePixel = 0
    inputContainer.LayoutOrder = 2
    inputContainer.Parent = container
    self.InputContainer = inputContainer
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputContainer
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Thickness = 1
    inputStroke.Color = self.Theme.InputBorder
    inputStroke.Transparency = 0.5
    inputStroke.Parent = inputContainer
    self.InputStroke = inputStroke
    
    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBoxElement"
    textBox.Size = UDim2.fromScale(1, 0)
    textBox.AutomaticSize = Enum.AutomaticSize.Y
    textBox.BackgroundTransparency = 1
    textBox.Text = self.Text
    textBox.PlaceholderText = self.Placeholder
    textBox.PlaceholderColor3 = self.Theme.TextMuted
    textBox.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    textBox.TextSize = 13
    textBox.FontFace = self.Theme.Font.Main
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextWrapped = true
    textBox.ClearTextOnFocus = self.ClearOnFocus
    textBox.MaxLength = self.MaxLength
    textBox.Active = not self.Disabled
    textBox.Parent = inputContainer
    self.TextBoxElement = textBox
    
    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingTop = UDim.new(0, 8)
    textBoxPadding.PaddingBottom = UDim.new(0, 8)
    textBoxPadding.PaddingLeft = UDim.new(0, 10)
    textBoxPadding.PaddingRight = UDim.new(0, 10)
    textBoxPadding.Parent = textBox
    
    -- Focus effects
    textBox.Focused:Connect(function()
        if not self.Disabled then
            self.Utils:QuickTween(self.InputStroke, {Color = self.Theme.Accent, Transparency = 0})
            self.Utils:QuickTween(inputContainer, {BackgroundColor3 = self.Theme.InputBackground})
        end
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if not self.Disabled then
            self.Utils:QuickTween(self.InputStroke, {Color = self.Theme.InputBorder, Transparency = 0.5})
            self.Utils:QuickTween(inputContainer, {BackgroundColor3 = self.Theme.InputBackground})
            
            self.Text = textBox.Text
            self.Callback(self.Text, enterPressed)
        end
    end)
    
    -- Text changed callback
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if not self.Disabled then
            self.Text = textBox.Text
            self.ChangedCallback(self.Text)
        end
    end)
    
    -- Numeric only filter
    if self.Numeric then
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            local text = textBox.Text
            local numericText = text:gsub("[^%d%.%-]", "")
            if text ~= numericText then
                textBox.Text = numericText
            end
        end)
    end
end

function TextBox:SetText(text)
    self.Text = text
    self.TextBoxElement.Text = text
end

function TextBox:GetText()
    return self.TextBoxElement.Text
end

function TextBox:SetPlaceholder(placeholder)
    self.Placeholder = placeholder
    self.TextBoxElement.PlaceholderText = placeholder
end

function TextBox:SetDisabled(disabled)
    self.Disabled = disabled
    self.TextBoxElement.Active = not disabled
    self.InputContainer.BackgroundColor3 = disabled and self.Theme.Border or self.Theme.InputBackground
    self.TextBoxElement.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    
    if self.LabelElement then
        self.LabelElement.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    end
end

function TextBox:SetCallback(callback)
    self.Callback = callback
end

function TextBox:Clear()
    self.TextBoxElement.Text = ""
    self.Text = ""
end

function TextBox:Focus()
    self.TextBoxElement:CaptureFocus()
end

function TextBox:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return TextBox
