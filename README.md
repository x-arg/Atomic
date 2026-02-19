# Atomic UI Library

A minimalist, feature-rich UI library for Roblox with dark mode design and smooth animations.

## Features

- 🌙 **Dark Mode Design** - Clean dark theme with white text
- ⚡ **Smooth Animations** - Fluid transitions and micro-interactions
- 🧩 **15+ Components** - Complete set of UI components
- 📱 **Responsive** - Adapts to different screen sizes
- 🎨 **Customizable** - Easy to theme and customize
- 📦 **Lightweight** - Optimized for performance

## Installation

### Load from GitHub

```lua
local Atomic = loadstring(game:HttpGet("https://raw.githubusercontent.com/x-arg/Atomic/main/src/Atomic.luau"))()
```

## Quick Start

```lua
-- Load the library
local Atomic = loadstring(game:HttpGet("https://raw.githubusercontent.com/x-arg/Atomic/main/src/Atomic.luau"))()

-- Create a window
local Window = Atomic:CreateWindow({
    Title = "My App",
    Size = UDim2.fromOffset(500, 400),
    ToggleKey = Enum.KeyCode.RightControl
})

-- Create a tab
local Tab = Window:CreateTab({Name = "Main"})

-- Create a section
local Section = Tab:CreateSection({Name = "Features"})

-- Add components
Section:AddButton({
    Text = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

Section:AddToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

## Components

### Window

The main container for your UI.

```lua
local Window = Atomic:CreateWindow({
    Title = "Window Title",           -- Window title
    Size = UDim2.fromOffset(500, 400), -- Window size
    Position = UDim2.fromOffset(100, 100), -- Window position
    AccentColor = Color3.fromRGB(88, 101, 242), -- Accent color
    ToggleKey = Enum.KeyCode.RightControl, -- Toggle visibility key
    Draggable = true,                  -- Allow window dragging
    Minimizable = true                 -- Allow minimizing
})
```

### Tab

Organize content into tabs.

```lua
local Tab = Window:CreateTab({
    Name = "Tab Name"
})
```

### Section

Group related components.

```lua
local Section = Tab:CreateSection({
    Name = "Section Name",
    Column = 1 -- 1 or 2 for left/right columns
})
```

### Button

Clickable buttons with multiple styles.

```lua
Section:AddButton({
    Text = "Button Text",
    Style = "Default", -- Default, Primary, Success, Warning, Error
    Disabled = false,
    Callback = function()
        print("Clicked!")
    end
})
```

### Toggle

Boolean switches.

```lua
Section:AddToggle({
    Text = "Toggle Label",
    Default = false,
    Disabled = false,
    Callback = function(value)
        print("Value:", value)
    end
})
```

### Slider

Numeric input with range.

```lua
Section:AddSlider({
    Text = "Slider Label",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,     -- Step size
    Precise = false,   -- Allow decimals
    Suffix = "%",      -- Text after value
    Disabled = false,
    Callback = function(value)
        print("Value:", value)
    end
})
```

### TextBox

Text input fields.

```lua
Section:AddTextBox({
    Label = "Field Label",
    Placeholder = "Enter text...",
    Default = "",
    Numeric = false,      -- Numbers only
    MaxLength = 200,
    ClearOnFocus = false,
    Disabled = false,
    Callback = function(text, enterPressed)
        print("Text:", text)
    end,
    ChangedCallback = function(text)
        -- Called on every text change
    end
})
```

### Dropdown

Selection menus.

```lua
-- Single select
Section:AddDropdown({
    Text = "Dropdown Label",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Disabled = false,
    Callback = function(value)
        print("Selected:", value)
    end
})

-- Multi-select
Section:AddDropdown({
    Text = "Multi-Select",
    Options = {"A", "B", "C"},
    MultiSelect = true,
    Callback = function(values)
        print("Selected:", table.concat(values, ", "))
    end
})
```

### Keybind

Keyboard input binding.

```lua
Section:AddKeybind({
    Text = "Action Key",
    Default = Enum.KeyCode.E,
    Disabled = false,
    Callback = function()
        print("Key pressed!")
    end,
    ChangedCallback = function(key)
        print("Key changed to:", key.Name)
    end
})
```

### ColorPicker

Color selection widget.

```lua
Section:AddColorPicker({
    Text = "Color Label",
    Default = Color3.fromRGB(255, 255, 255),
    Disabled = false,
    Callback = function(color)
        print("Color:", color)
    end
})
```

### Progress

Progress bar display.

```lua
local progress = Section:AddProgress({
    Text = "Progress Label",
    Default = 0,
    Max = 100,
    ShowPercentage = true,
    Color = Color3.fromRGB(88, 101, 242) -- Optional custom color
})

-- Methods
progress:SetValue(50)       -- Set progress
progress:Increment()        -- Add 1
progress:Increment(10)      -- Add 10
progress:Reset()            -- Set to 0
```

### Label

Simple text display.

```lua
Section:AddLabel({
    Text = "Label Text",
    Size = 13,             -- Font size
    Color = Color3.new(1, 1, 1), -- Optional custom color
    Wrap = true,
    Center = false
})
```

### Paragraph

Multi-line text block.

```lua
Section:AddParagraph({
    Title = "Title (optional)",
    Text = "Your paragraph content here...",
    Size = 12
})
```

### Divider

Visual separator.

```lua
Section:AddDivider()
```

### Notification

Toast notifications.

```lua
Atomic:Notify({
    Title = "Notification Title",
    Content = "Notification content text...",
    Duration = 5,          -- Seconds
    Type = "Info",         -- Info, Success, Warning, Error
    Callback = function()
        -- Called when dismissed
    end
})
```

## Theming

### Global Accent Color

```lua
Atomic:SetAccentColor(Color3.fromRGB(255, 100, 100))
```

### Custom Theme

Access theme colors through `Atomic.Theme`:

```lua
Atomic.Theme.Background = Color3.fromRGB(20, 20, 25)
Atomic.Theme.TextPrimary = Color3.fromRGB(255, 255, 255)
Atomic.Theme.Accent = Color3.fromRGB(88, 101, 242)
```

## Window Methods

```lua
Window:SetTitle("New Title")           -- Change window title
Window:SetSize(UDim2.fromOffset(600, 500)) -- Resize window
Window:Toggle()                        -- Toggle visibility
Window:ToggleMinimize()                -- Toggle minimize state
Window:Destroy()                       -- Remove window
```

## Utility Functions

The library includes useful utilities accessible via `Atomic.Utils`:

```lua
-- Tween animation
Atomic.Utils:QuickTween(instance, {BackgroundColor3 = Color3.new(1, 0, 0)})

-- Color conversion
Atomic.Utils:Color3ToHex(Color3.fromRGB(255, 0, 0)) -- "#FF0000"
Atomic.Utils:HexToColor3("#FF0000")

-- HSV/RGB conversion
Atomic.Utils:HSVtoRGB(0, 1, 1) -- Red
Atomic.Utils:RGBtoHSV(Color3.fromRGB(255, 0, 0))

-- Math helpers
Atomic.Utils:Round(3.14159, 2) -- 3.14
```

## License

MIT License - Feel free to use in your projects!

## Credits

Created by the Atomic Team
