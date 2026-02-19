--[[
    Atomic UI Library - Utilities Module
    Helper functions for the library
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Utilities = {}

-- Tween helper
function Utilities:Tween(instance, tweenInfo, properties)
    tweenInfo = tweenInfo or TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Quick tween with default animation
function Utilities:QuickTween(instance, properties)
    return self:Tween(instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
end

-- Create rounded frame
function Utilities:CreateRoundedFrame(config)
    config = config or {}
    
    local frame = Instance.new("Frame")
    frame.Name = config.Name or "RoundedFrame"
    frame.Size = config.Size or UDim2.fromScale(1, 1)
    frame.Position = config.Position or UDim2.fromScale(0, 0)
    frame.AnchorPoint = config.AnchorPoint or Vector2.new(0, 0)
    frame.BackgroundColor3 = config.Color or Color3.new(1, 1, 1)
    frame.BackgroundTransparency = config.Transparency or 0
    frame.BorderSizePixel = 0
    frame.ZIndex = config.ZIndex or 1
    frame.LayoutOrder = config.LayoutOrder or 0
    
    if config.Parent then
        frame.Parent = config.Parent
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.Radius or UDim.new(0, 6)
    corner.Parent = frame
    
    if config.Stroke then
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = type(config.Stroke) == "number" and config.Stroke or 1
        stroke.Color = config.StrokeColor or Color3.new(0.2, 0.2, 0.2)
        stroke.Parent = frame
    end
    
    return frame
end

-- Create text label with default styling
function Utilities:CreateLabel(config)
    config = config or {}
    
    local label = Instance.new("TextLabel")
    label.Name = config.Name or "Label"
    label.Size = config.Size or UDim2.fromScale(1, 0)
    label.AutomaticSize = config.AutomaticSize or Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Label"
    label.TextColor3 = config.Color or Color3.new(1, 1, 1)
    label.TextSize = config.TextSize or 14
    label.FontFace = config.Font or Font.new("rbxasset://fonts/families/GothamSSm.json")
    label.TextWrapped = config.Wrapped ~= false
    label.TextXAlignment = config.XAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = config.YAlignment or Enum.TextYAlignment.Center
    label.ZIndex = config.ZIndex or 1
    label.LayoutOrder = config.LayoutOrder or 0
    
    if config.Parent then
        label.Parent = config.Parent
    end
    
    return label
end

-- Create text button with default styling
function Utilities:CreateButton(config)
    config = config or {}
    
    local button = Instance.new("TextButton")
    button.Name = config.Name or "Button"
    button.Size = config.Size or UDim2.fromScale(1, 1)
    button.BackgroundColor3 = config.Color or Color3.new(0.1, 0.1, 0.1)
    button.BackgroundTransparency = config.Transparency or 0
    button.BorderSizePixel = 0
    button.Text = config.Text or "Button"
    button.TextColor3 = config.TextColor or Color3.new(1, 1, 1)
    button.TextSize = config.TextSize or 14
    button.FontFace = config.Font or Font.new("rbxasset://fonts/families/GothamSSm.json")
    button.ZIndex = config.ZIndex or 1
    button.LayoutOrder = config.LayoutOrder or 0
    button.AutoButtonColor = false
    
    if config.Parent then
        button.Parent = config.Parent
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.Radius or UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- Create image button with default styling
function Utilities:CreateImageButton(config)
    config = config or {}
    
    local button = Instance.new("ImageButton")
    button.Name = config.Name or "ImageButton"
    button.Size = config.Size or UDim2.fromOffset(24, 24)
    button.BackgroundTransparency = 1
    button.Image = config.Image or ""
    button.ImageColor3 = config.Color or Color3.new(1, 1, 1)
    button.ZIndex = config.ZIndex or 1
    button.LayoutOrder = config.LayoutOrder or 0
    button.AutoButtonColor = false
    
    if config.Parent then
        button.Parent = config.Parent
    end
    
    return button
end

-- Create text box with default styling
function Utilities:CreateTextBox(config)
    config = config or {}
    
    local textBox = Instance.new("TextBox")
    textBox.Name = config.Name or "TextBox"
    textBox.Size = config.Size or UDim2.fromScale(1, 1)
    textBox.BackgroundColor3 = config.Color or Color3.new(0.08, 0.08, 0.1)
    textBox.BackgroundTransparency = config.Transparency or 0
    textBox.BorderSizePixel = 0
    textBox.Text = config.Text or ""
    textBox.PlaceholderText = config.Placeholder or ""
    textBox.TextColor3 = config.TextColor or Color3.new(1, 1, 1)
    textBox.PlaceholderColor3 = config.PlaceholderColor or Color3.new(0.5, 0.5, 0.5)
    textBox.TextSize = config.TextSize or 14
    textBox.FontFace = config.Font or Font.new("rbxasset://fonts/families/GothamSSm.json")
    textBox.TextXAlignment = config.XAlignment or Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = config.ClearOnFocus or false
    textBox.ZIndex = config.ZIndex or 1
    textBox.LayoutOrder = config.LayoutOrder or 0
    
    if config.Parent then
        textBox.Parent = config.Parent
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.Radius or UDim.new(0, 6)
    corner.Parent = textBox
    
    return textBox
end

-- Create scrolling frame with default styling
function Utilities:CreateScrollFrame(config)
    config = config or {}
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = config.Name or "ScrollFrame"
    scrollFrame.Size = config.Size or UDim2.fromScale(1, 1)
    scrollFrame.BackgroundColor3 = config.Color or Color3.new(0.08, 0.08, 0.1)
    scrollFrame.BackgroundTransparency = config.Transparency or 0
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = config.ScrollThickness or 4
    scrollFrame.ScrollBarImageColor3 = config.ScrollColor or Color3.new(0.2, 0.2, 0.25)
    scrollFrame.CanvasSize = config.CanvasSize or UDim2.fromScale(0, 0)
    scrollFrame.AutomaticCanvasSize = config.AutoCanvasSize or Enum.AutomaticSize.Y
    scrollFrame.ScrollingDirection = config.Direction or Enum.ScrollingDirection.Y
    scrollFrame.ZIndex = config.ZIndex or 1
    scrollFrame.LayoutOrder = config.LayoutOrder or 0
    
    if config.Parent then
        scrollFrame.Parent = config.Parent
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.Radius or UDim.new(0, 0)
    corner.Parent = scrollFrame
    
    return scrollFrame
end

-- Create padding
function Utilities:CreatePadding(top, left, bottom, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingLeft = UDim.new(0, left or top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or top or 8)
    padding.PaddingRight = UDim.new(0, right or left or top or 8)
    return padding
end

-- Create list layout
function Utilities:CreateListLayout(direction, padding, horizontalAlignment)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, padding or 8)
    if direction then
        layout.FillDirection = direction
    end
    if horizontalAlignment then
        layout.HorizontalAlignment = horizontalAlignment
    end
    return layout
end

-- Create grid layout
function Utilities:CreateGridLayout(cellSize, padding)
    local layout = Instance.new("UIGridLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.CellSize = cellSize or UDim2.fromOffset(100, 100)
    layout.CellPadding = padding or UDim2.fromOffset(8, 8)
    return layout
end

-- Hover effect
function Utilities:AddHoverEffect(button, hoverColor, defaultColor)
    hoverColor = hoverColor or Color3.new(0.15, 0.15, 0.18)
    defaultColor = defaultColor or button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        self:QuickTween(button, {BackgroundColor3 = hoverColor})
    end)
    
    button.MouseLeave:Connect(function()
        self:QuickTween(button, {BackgroundColor3 = defaultColor})
    end)
end

-- Button click effect
function Utilities:AddClickEffect(button, clickColor, defaultColor)
    clickColor = clickColor or Color3.new(0.1, 0.1, 0.12)
    defaultColor = defaultColor or button.BackgroundColor3
    
    button.MouseButton1Down:Connect(function()
        self:QuickTween(button, {BackgroundColor3 = clickColor})
    end)
    
    button.MouseButton1Up:Connect(function()
        self:QuickTween(button, {BackgroundColor3 = defaultColor})
    end)
end

-- Ripple effect
function Utilities:AddRippleEffect(button, rippleColor)
    rippleColor = rippleColor or Color3.new(1, 1, 1)
    
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = rippleColor
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.Size = UDim2.fromOffset(0, 0)
        ripple.Position = UDim2.fromScale(0.5, 0.5)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        self:Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(maxSize, maxSize),
            BackgroundTransparency = 1
        })
        
        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end)
end

-- Make frame draggable
function Utilities:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Round number to decimal places
function Utilities:Round(number, decimalPlaces)
    decimalPlaces = decimalPlaces or 0
    local multiplier = 10 ^ decimalPlaces
    return math.floor(number * multiplier + 0.5) / multiplier
end

-- Clamp number between min and max
function Utilities:Clamp(number, min, max)
    return math.clamp(number, min, max)
end

-- Lerp between two values
function Utilities:Lerp(a, b, t)
    return a + (b - a) * t
end

-- Get input name
function Utilities:GetInputName(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        return input.KeyCode.Name
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        return "Mouse1"
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        return "Mouse2"
    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
        return "Mouse3"
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
        return input.KeyCode.Name
    end
    return "Unknown"
end

-- Color3 to Hex
function Utilities:Color3ToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255))
end

-- Hex to Color3
function Utilities:HexToColor3(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

-- HSV to RGB
function Utilities:HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

-- RGB to HSV
function Utilities:RGBtoHSV(color)
    local r, g, b = color.R, color.G, color.B
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    
    local d = max - min
    if max == 0 then s = 0 else s = d / max end
    
    if max == min then
        h = 0
    elseif max == r then
        h = (g - b) / d
        if g < b then h = h + 6 end
    elseif max == g then
        h = (b - r) / d + 2
    elseif max == b then
        h = (r - g) / d + 4
    end
    
    h = h / 6
    
    return h, s, v
end

return Utilities
