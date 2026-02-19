--[[
    Atomic UI Library - Button Component
    Clickable button element
]]

local Button = {}
Button.__index = Button

function Button.new(section, config)
    local self = setmetatable({}, Button)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Button"
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    self.Style = config.Style or "Default" -- Default, Primary, Success, Warning, Error
    
    self:_CreateButton()
    
    return self
end

function Button:_CreateButton()
    -- Determine colors based on style
    local bgColor, hoverColor, activeColor, textColor
    
    if self.Style == "Primary" then
        bgColor = self.Theme.Accent
        hoverColor = self.Theme.AccentHover
        activeColor = self.Theme.AccentActive
        textColor = self.Theme.TextPrimary
    elseif self.Style == "Success" then
        bgColor = self.Theme.Success
        hoverColor = self.Utils:AdjustColor(bgColor, 0.1)
        activeColor = self.Utils:AdjustColor(bgColor, -0.1)
        textColor = Color3.fromRGB(15, 15, 20)
    elseif self.Style == "Warning" then
        bgColor = self.Theme.Warning
        hoverColor = self.Utils:AdjustColor(bgColor, 0.1)
        activeColor = self.Utils:AdjustColor(bgColor, -0.1)
        textColor = Color3.fromRGB(15, 15, 20)
    elseif self.Style == "Error" then
        bgColor = self.Theme.Error
        hoverColor = self.Utils:AdjustColor(bgColor, 0.1)
        activeColor = self.Utils:AdjustColor(bgColor, -0.1)
        textColor = self.Theme.TextPrimary
    else
        bgColor = self.Theme.CardHover
        hoverColor = self.Theme.CardActive
        activeColor = self.Theme.Border
        textColor = self.Theme.TextPrimary
    end
    
    -- Container
    local container = Instance.new("Frame")
    container.Name = "Button"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.Section.Content
    self.Container = container
    
    -- Button
    local button = Instance.new("TextButton")
    button.Name = "ButtonElement"
    button.Size = UDim2.fromScale(1, 0)
    button.AutomaticSize = Enum.AutomaticSize.Y
    button.BackgroundColor3 = self.Disabled and self.Theme.Border or bgColor
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.Text = self.Text
    button.TextColor3 = self.Disabled and self.Theme.TextMuted or textColor
    button.TextSize = 13
    button.FontFace = self.Theme.Font.Main
    button.AutoButtonColor = false
    button.Active = not self.Disabled
    button.Parent = container
    self.Button = button
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local buttonPadding = Instance.new("UIPadding")
    buttonPadding.PaddingTop = UDim.new(0, 8)
    buttonPadding.PaddingBottom = UDim.new(0, 8)
    buttonPadding.PaddingLeft = UDim.new(0, 12)
    buttonPadding.PaddingRight = UDim.new(0, 12)
    buttonPadding.Parent = button
    
    -- Hover and click effects
    if not self.Disabled then
        button.MouseEnter:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = hoverColor})
        end)
        
        button.MouseLeave:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = bgColor})
        end)
        
        button.MouseButton1Down:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = activeColor})
        end)
        
        button.MouseButton1Up:Connect(function()
            self.Utils:QuickTween(button, {BackgroundColor3 = hoverColor})
        end)
        
        -- Ripple effect
        self.Utils:AddRippleEffect(button, self.Style == "Default" and self.Theme.TextMuted or textColor)
        
        -- Click callback
        button.MouseButton1Click:Connect(function()
            if self.Callback then
                self.Callback()
            end
        end)
    end
end

function Button:SetText(text)
    self.Text = text
    self.Button.Text = text
end

function Button:SetCallback(callback)
    self.Callback = callback
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    self.Button.Active = not disabled
    
    if disabled then
        self.Button.BackgroundColor3 = self.Theme.Border
        self.Button.TextColor3 = self.Theme.TextMuted
    else
        self.Button.BackgroundColor3 = self.Theme.CardHover
        self.Button.TextColor3 = self.Theme.TextPrimary
    end
end

function Button:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return Button
