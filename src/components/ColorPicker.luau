--[[
    Atomic UI Library - ColorPicker Component
    Color selection widget
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(section, config)
    local self = setmetatable({}, ColorPicker)
    
    self.Section = section
    self.Window = section.Window
    self.Library = section.Library
    self.Theme = section.Theme
    self.Utils = section.Utils
    
    self.Config = config
    self.Text = config.Text or "Color"
    self.Default = config.Default or Color3.fromRGB(255, 255, 255)
    self.Callback = config.Callback or function() end
    self.Disabled = config.Disabled or false
    
    self.Value = self.Default
    self.Hue = 0
    self.Saturation = 0
    self.Value2 = 1 -- Value in HSV (renamed to avoid conflict)
    self.Alpha = 1
    self.Open = false
    self.DraggingSaturation = false
    self.DraggingHue = false
    
    -- Convert default color to HSV
    self.Hue, self.Saturation, self.Value2 = self.Utils:RGBtoHSV(self.Default)
    
    self:_CreateColorPicker()
    
    return self
end

function ColorPicker:_CreateColorPicker()
    -- Container
    local container = Instance.new("Frame")
    container.Name = "ColorPicker"
    container.Size = UDim2.fromScale(1, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.ZIndex = 10
    container.Parent = self.Section.Content
    self.Container = container
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 6)
    containerLayout.Parent = container
    
    -- Header row
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = container
    self.Header = header
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Padding = UDim.new(0, 8)
    headerLayout.Parent = header
    
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
    label.Parent = header
    self.Label = label
    
    -- Color preview button
    local preview = Instance.new("TextButton")
    preview.Name = "Preview"
    preview.Size = UDim2.fromOffset(50, 24)
    preview.BackgroundColor3 = self.Value
    preview.BackgroundTransparency = 0
    preview.BorderSizePixel = 0
    preview.Text = ""
    preview.AutoButtonColor = false
    preview.Active = not self.Disabled
    preview.LayoutOrder = 2
    preview.Parent = header
    self.Preview = preview
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = preview
    
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Thickness = 1
    previewStroke.Color = self.Theme.Border
    previewStroke.Parent = preview
    
    -- Hex value display
    local hexDisplay = Instance.new("TextLabel")
    hexDisplay.Name = "Hex"
    hexDisplay.Size = UDim2.fromOffset(0, 24)
    hexDisplay.AutomaticSize = Enum.AutomaticSize.X
    hexDisplay.BackgroundTransparency = 1
    hexDisplay.Text = self.Utils:Color3ToHex(self.Value)
    hexDisplay.TextColor3 = self.Theme.TextMuted
    hexDisplay.TextSize = 11
    hexDisplay.FontFace = self.Theme.Font.Mono
    hexDisplay.LayoutOrder = 3
    hexDisplay.Parent = header
    self.HexDisplay = hexDisplay
    
    local hexPadding = Instance.new("UIPadding")
    hexPadding.PaddingLeft = UDim.new(0, 4)
    hexPadding.Parent = hexDisplay
    
    -- Picker container (dropdown)
    local pickerContainer = Instance.new("Frame")
    pickerContainer.Name = "Picker"
    pickerContainer.Size = UDim2.fromScale(1, 0)
    pickerContainer.AutomaticSize = Enum.AutomaticSize.Y
    pickerContainer.BackgroundColor3 = self.Theme.Card
    pickerContainer.BackgroundTransparency = 0
    pickerContainer.BorderSizePixel = 0
    pickerContainer.Visible = false
    pickerContainer.LayoutOrder = 2
    pickerContainer.ZIndex = 9
    pickerContainer.Parent = container
    self.PickerContainer = pickerContainer
    
    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 8)
    pickerCorner.Parent = pickerContainer
    
    local pickerStroke = Instance.new("UIStroke")
    pickerStroke.Thickness = 1
    pickerStroke.Color = self.Theme.Border
    pickerStroke.Parent = pickerContainer
    
    local pickerPadding = Instance.new("UIPadding")
    pickerPadding.PaddingTop = UDim.new(0, 12)
    pickerPadding.PaddingBottom = UDim.new(0, 12)
    pickerPadding.PaddingLeft = UDim.new(0, 12)
    pickerPadding.PaddingRight = UDim.new(0, 12)
    pickerPadding.Parent = pickerContainer
    
    -- Saturation/Value picker
    local satValPicker = Instance.new("TextButton")
    satValPicker.Name = "SaturationValue"
    satValPicker.Size = UDim2.fromOffset(200, 150)
    satValPicker.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    satValPicker.BackgroundTransparency = 0
    satValPicker.BorderSizePixel = 0
    satValPicker.Text = ""
    satValPicker.AutoButtonColor = false
    satValPicker.ZIndex = 9
    satValPicker.Parent = pickerContainer
    self.SatValPicker = satValPicker
    
    local satValCorner = Instance.new("UICorner")
    satValCorner.CornerRadius = UDim.new(0, 6)
    satValCorner.Parent = satValPicker
    
    -- Saturation gradient (left to right)
    local satGradient = Instance.new("UIGradient")
    satGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, 1))
    })
    satGradient.Parent = satValPicker
    self.SatGradient = satGradient
    
    -- Value gradient (top to bottom)
    local valGradient = Instance.new("UIGradient")
    valGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    valGradient.Rotation = 90
    valGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    valGradient.Parent = satValPicker
    
    -- Sat/Val cursor
    local svCursor = Instance.new("Frame")
    svCursor.Name = "Cursor"
    svCursor.Size = UDim2.fromOffset(12, 12)
    svCursor.Position = UDim2.fromOffset(self.Saturation * 200 - 6, (1 - self.Value2) * 150 - 6)
    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svCursor.BorderSizePixel = 0
    svCursor.ZIndex = 10
    svCursor.Parent = satValPicker
    self.SVCursor = svCursor
    
    local svCursorCorner = Instance.new("UICorner")
    svCursorCorner.CornerRadius = UDim.new(1, 0)
    svCursorCorner.Parent = svCursor
    
    local svCursorStroke = Instance.new("UIStroke")
    svCursorStroke.Thickness = 2
    svCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    svCursorStroke.Parent = svCursor
    
    -- Hue slider
    local hueSlider = Instance.new("TextButton")
    hueSlider.Name = "HueSlider"
    hueSlider.Size = UDim2.fromOffset(200, 20)
    hueSlider.Position = UDim2.fromOffset(0, 160)
    hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueSlider.BackgroundTransparency = 0
    hueSlider.BorderSizePixel = 0
    hueSlider.Text = ""
    hueSlider.AutoButtonColor = false
    hueSlider.ZIndex = 9
    hueSlider.Parent = pickerContainer
    self.HueSlider = hueSlider
    
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 6)
    hueCorner.Parent = hueSlider
    
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueSlider
    
    -- Hue cursor
    local hueCursor = Instance.new("Frame")
    hueCursor.Name = "Cursor"
    hueCursor.Size = UDim2.fromOffset(6, 24)
    hueCursor.Position = UDim2.fromOffset(self.Hue * 200 - 3, -2)
    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 10
    hueCursor.Parent = hueSlider
    self.HueCursor = hueCursor
    
    local hueCursorCorner = Instance.new("UICorner")
    hueCursorCorner.CornerRadius = UDim.new(0, 3)
    hueCursorCorner.Parent = hueCursor
    
    local hueCursorStroke = Instance.new("UIStroke")
    hueCursorStroke.Thickness = 1
    hueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    hueCursorStroke.Parent = hueCursor
    
    -- Input handlers
    local function updateSatVal(input)
        local relX = math.clamp((input.Position.X - satValPicker.AbsolutePosition.X) / 200, 0, 1)
        local relY = math.clamp((input.Position.Y - satValPicker.AbsolutePosition.Y) / 150, 0, 1)
        
        self.Saturation = relX
        self.Value2 = 1 - relY
        
        self.SVCursor.Position = UDim2.fromOffset(relX * 200 - 6, relY * 150 - 6)
        self:_UpdateColor()
    end
    
    local function updateHue(input)
        local relX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / 200, 0, 1)
        self.Hue = relX
        self.HueCursor.Position = UDim2.fromOffset(relX * 200 - 3, -2)
        self:_UpdateColor()
    end
    
    satValPicker.MouseButton1Down:Connect(function(input)
        self.DraggingSaturation = true
        updateSatVal(input)
    end)
    
    satValPicker.MouseButton1Up:Connect(function()
        self.DraggingSaturation = false
    end)
    
    hueSlider.MouseButton1Down:Connect(function(input)
        self.DraggingHue = true
        updateHue(input)
    end)
    
    hueSlider.MouseButton1Up:Connect(function()
        self.DraggingHue = false
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.DraggingSaturation = false
            self.DraggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if self.DraggingSaturation then
                updateSatVal(input)
            elseif self.DraggingHue then
                updateHue(input)
            end
        end
    end)
    
    -- Toggle dropdown
    preview.MouseButton1Click:Connect(function()
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

function ColorPicker:_UpdateColor()
    self.Value = Color3.fromHSV(self.Hue, self.Saturation, self.Value2)
    self.Preview.BackgroundColor3 = self.Value
    self.HexDisplay.Text = self.Utils:Color3ToHex(self.Value)
    
    -- Update saturation gradient
    self.SatGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, 1))
    })
    
    if self.Callback then
        self.Callback(self.Value)
    end
end

function ColorPicker:Open()
    self.Open = true
    self.PickerContainer.Visible = true
end

function ColorPicker:Close()
    self.Open = false
    self.PickerContainer.Visible = false
end

function ColorPicker:SetValue(color, callback)
    self.Value = color
    self.Hue, self.Saturation, self.Value2 = self.Utils:RGBtoHSV(color)
    
    self.Preview.BackgroundColor3 = color
    self.HexDisplay.Text = self.Utils:Color3ToHex(color)
    
    self.SVCursor.Position = UDim2.fromOffset(self.Saturation * 200 - 6, (1 - self.Value2) * 150 - 6)
    self.HueCursor.Position = UDim2.fromOffset(self.Hue * 200 - 3, -2)
    
    self:_UpdateColor()
    
    if callback ~= false and self.Callback then
        self.Callback(color)
    end
end

function ColorPicker:GetValue()
    return self.Value
end

function ColorPicker:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function ColorPicker:SetDisabled(disabled)
    self.Disabled = disabled
    self.Preview.Active = not disabled
    self.Label.TextColor3 = disabled and self.Theme.TextMuted or self.Theme.TextPrimary
    
    if disabled and self.Open then
        self:Close()
    end
end

function ColorPicker:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

return ColorPicker
