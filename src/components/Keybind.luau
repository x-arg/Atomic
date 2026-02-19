--[[
    Atomic UI Library - Keybind Component
    Key binding input
]]

local UserInputService = game:GetService("UserInputService")

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, config)
    local self = setmetatable({}, Keybind)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Keybind"
    self.Default = config.Default or Enum.KeyCode.Unknown
    self.Callback = config.Callback or function() end
    self.ChangedCallback = config.ChangedCallback or function() end
    self.Disabled = config.Disabled or false
    
    self.Value = self.Default
    self.Listening = false
    
    self:_CreateKeybind()
    
    return self
end

function Keybind:_CreateKeybind()
    -- Container
    local container = Instance.new("Frame")
    container.Name = "Keybind"
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
    label.LayoutOrder = 1
    label.Parent = container
    self.Label = label
    
    -- Key button
    local keyBtn = Instance.new("TextButton")
    keyBtn.Name = "KeyButton"
    keyBtn.Size = UDim2.fromOffset(80, 26)
    keyBtn.BackgroundColor3 = self.Disabled and self.Theme.Border or self.Theme.InputBackground
    keyBtn.BackgroundTransparency = 0
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = self:_GetKeyName(self.Value)
    keyBtn.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    keyBtn.TextSize = 12
    keyBtn.FontFace = self.Theme.Font.Mono
    keyBtn.AutoButtonColor = false
    keyBtn.Active = not self.Disabled
    keyBtn.LayoutOrder = 2
    keyBtn.Parent = container
    self.KeyButton = keyBtn
    
    local keyBtnCorner = Instance.new("UICorner")
    keyBtnCorner.CornerRadius = UDim.new(0, 6)
    keyBtnCorner.Parent = keyBtn
    
    local keyBtnStroke = Instance.new("UIStroke")
    keyBtnStroke.Thickness = 1
    keyBtnStroke.Color = self.Theme.InputBorder
    keyBtnStroke.Transparency = 0.5
    keyBtnStroke.Parent = keyBtn
    self.KeyButtonStroke = keyBtnStroke
    
    -- Click to bind
    keyBtn.MouseButton1Click:Connect(function()
        if not self.Disabled and not self.Listening then
            self:StartListening()
        end
    end)
    
    -- Right-click to clear
    keyBtn.MouseButton2Click:Connect(function()
        if not self.Disabled then
            self:SetValue(Enum.KeyCode.Unknown)
        end
    end)
    
    -- Hover effects
    keyBtn.MouseEnter:Connect(function()
        if not self.Disabled and not self.Listening then
            self.Utils:QuickTween(keyBtn, {BackgroundColor3 = self.Theme.CardHover})
        end
    end)
    
    keyBtn.MouseLeave:Connect(function()
        if not self.Disabled and not self.Listening then
            self.Utils:QuickTween(keyBtn, {BackgroundColor3 = self.Theme.InputBackground})
        end
    end)
end

function Keybind:_GetKeyName(keyCode)
    if keyCode == Enum.KeyCode.Unknown then
        return "None"
    end
    
    local name = keyCode.Name
    
    -- Clean up key names
    local replacements = {
        ["LeftControl"] = "LCtrl",
        ["RightControl"] = "RCtrl",
        ["LeftShift"] = "LShift",
        ["RightShift"] = "RShift",
        ["LeftAlt"] = "LAlt",
        ["RightAlt"] = "RAlt",
        ["LeftSuper"] = "LWin",
        ["RightSuper"] = "RWin",
        ["ButtonL1"] = "LB",
        ["ButtonR1"] = "RB",
        ["ButtonL2"] = "LT",
        ["ButtonR2"] = "RT",
        ["ButtonL3"] = "L3",
        ["ButtonR3"] = "R3",
        ["DPadLeft"] = "←",
        ["DPadRight"] = "→",
        ["DPadUp"] = "↑",
        ["DPadDown"] = "↓",
    }
    
    return replacements[name] or name
end

function Keybind:StartListening()
    self.Listening = true
    self.KeyButton.Text = "..."
    self.KeyButton.TextColor3 = self.Theme.Accent
    self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.Accent})
    
    -- Listen for input
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local keyCode
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keyCode = input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            keyCode = Enum.KeyCode.Unknown -- Don't bind mouse1
            self.Listening = false
            self.KeyButton.Text = self:_GetKeyName(self.Value)
            self.KeyButton.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
            self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
            connection:Disconnect()
            return
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            keyCode = Enum.KeyCode.Unknown
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            keyCode = Enum.KeyCode.MouseButton3
        elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
            keyCode = input.KeyCode
        end
        
        if keyCode then
            self:SetValue(keyCode)
            self.Listening = false
            connection:Disconnect()
        end
    end)
    
    -- Timeout after 5 seconds
    task.delay(5, function()
        if self.Listening then
            self.Listening = false
            self.KeyButton.Text = self:_GetKeyName(self.Value)
            self.KeyButton.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
            self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
            if connection then
                connection:Disconnect()
            end
        end
    end)
end

function Keybind:SetValue(keyCode, callback)
    self.Value = keyCode
    self.KeyButton.Text = self:_GetKeyName(keyCode)
    self.KeyButton.TextColor3 = self.Disabled and self.Theme.TextMuted or self.Theme.TextSecondary
    self.Utils:QuickTween(self.KeyButtonStroke, {Color = self.Theme.InputBorder})
    
    if callback ~= false then
        self.ChangedCallback(keyCode)
    end
end

function Keybind:GetValue()
    return self.Value
end

function Keybind:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Keybind:SetDisabled(disabled)
    self.Disabled = disabled
    self.KeyButton.Active = not disabled
    self.Label.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    self.KeyButton.BackgroundColor3 = disabled and self.Theme.Border or self.Theme.InputBackground
    self.KeyButton.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextSecondary
end

function Keybind:GetCallback()
    return function()
        if not self.Disabled then
            self.Callback()
        end
    end
end

function Keybind:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Keybind
