--[[
    Atomic UI Library - Theme Module
    Dark mode color scheme with white text
]]

local Theme = {
    -- Main colors
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(20, 20, 28),
    BackgroundTertiary = Color3.fromRGB(25, 25, 35),
    
    -- Card/Container colors
    Card = Color3.fromRGB(22, 22, 30),
    CardHover = Color3.fromRGB(28, 28, 38),
    CardActive = Color3.fromRGB(32, 32, 42),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    TextMuted = Color3.fromRGB(120, 120, 135),
    TextDisabled = Color3.fromRGB(80, 80, 90),
    
    -- Accent colors
    Accent = Color3.fromRGB(88, 101, 242), -- Discord-like blurple
    AccentHover = Color3.fromRGB(108, 121, 255),
    AccentActive = Color3.fromRGB(78, 91, 232),
    
    -- Status colors
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Info = Color3.fromRGB(88, 101, 242),
    
    -- Border colors
    Border = Color3.fromRGB(45, 45, 55),
    BorderLight = Color3.fromRGB(55, 55, 65),
    
    -- Shadow/Overlay
    Shadow = Color3.fromRGB(0, 0, 0),
    Overlay = Color3.fromRGB(0, 0, 0),
    
    -- Scrollbar
    Scrollbar = Color3.fromRGB(40, 40, 50),
    ScrollbarHover = Color3.fromRGB(50, 50, 60),
    
    -- Input colors
    InputBackground = Color3.fromRGB(18, 18, 24),
    InputBorder = Color3.fromRGB(40, 40, 50),
    InputBorderActive = Color3.fromRGB(88, 101, 242),
    
    -- Gradients
    GradientStart = Color3.fromRGB(25, 25, 35),
    GradientEnd = Color3.fromRGB(15, 15, 20),
    
    -- Transparency values
    Transparency = {
        Full = 1,
        None = 0,
        Light = 0.1,
        Medium = 0.5,
        Heavy = 0.8,
    },
    
    -- Typography
    Font = {
        Main = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
        Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
        Light = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light),
        Mono = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Medium),
    },
    
    FontSize = {
        XS = 10,
        S = 12,
        M = 14,
        L = 16,
        XL = 18,
        XXL = 24,
        Title = 28,
    },
    
    -- Spacing
    Spacing = {
        XS = 2,
        S = 4,
        M = 8,
        L = 12,
        XL = 16,
        XXL = 24,
    },
    
    -- Border radius
    Radius = {
        S = UDim.new(0, 4),
        M = UDim.new(0, 6),
        L = UDim.new(0, 8),
        XL = UDim.new(0, 12),
        Round = UDim.new(1, 0),
    },
    
    -- Animation
    Animation = {
        Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    },
}

-- Helper function to get status color
function Theme:GetStatusColor(statusType)
    local colors = {
        Success = self.Success,
        Warning = self.Warning,
        Error = self.Error,
        Info = self.Info,
    }
    return colors[statusType] or self.Info
end

-- Helper function to lighten/darken color
function Theme:AdjustColor(color, amount)
    local r, g, b = color.R, color.G, color.B
    r = math.clamp(r + amount, 0, 1)
    g = math.clamp(g + amount, 0, 1)
    b = math.clamp(b + amount, 0, 1)
    return Color3.new(r, g, b)
end

-- Create UICorner with specified radius
function Theme:CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.Radius.M
    return corner
end

-- Create UIStroke with theme colors
function Theme:CreateStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or self.Border
    stroke.Transparency = 0
    return stroke
end

-- Create UIListLayout
function Theme:CreateListLayout(direction, padding)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = padding or UDim.new(0, self.Spacing.M)
    if direction then
        layout.FillDirection = direction
    end
    return layout
end

-- Create padding
function Theme:CreatePadding(padding)
    local p = Instance.new("UIPadding")
    p.PaddingTop = padding or UDim.new(0, self.Spacing.M)
    p.PaddingBottom = padding or UDim.new(0, self.Spacing.M)
    p.PaddingLeft = padding or UDim.new(0, self.Spacing.M)
    p.PaddingRight = padding or UDim.new(0, self.Spacing.M)
    return p
end

return Theme
