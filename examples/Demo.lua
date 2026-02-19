--[[
    Atomic UI Library - Example/Demo Script
    
    This script demonstrates all the components and features
    of the Atomic UI library.
    
    Usage:
    1. Place the Atomic folder in your game
    2. Require the library: local Atomic = loadstring(game:HttpGet("path/to/Atomic"))()
    3. Create windows, tabs, and add components
]]

-- Load the library
local Atomic = loadstring(game:HttpGet("https://raw.githubusercontent.com/x-arg/Atomic/main/src/Atomic.luau"))()

-- Or if using locally:
-- local Atomic = require(script.Parent:WaitForChild("Atomic"))

-- Create main window
local Window = Atomic:CreateWindow({
    Title = "Atomic UI Demo",
    Size = UDim2.fromOffset(580, 450),
    Position = UDim2.fromOffset(200, 150),
    ToggleKey = Enum.KeyCode.RightControl,
    Draggable = true,
    Minimizable = true,
})

-- Create tabs
local HomeTab = Window:CreateTab({Name = "Home"})
local InputsTab = Window:CreateTab({Name = "Inputs"})
local AdvancedTab = Window:CreateTab({Name = "Advanced"})
local SettingsTab = Window:CreateTab({Name = "Settings"})

-- ==================== HOME TAB ====================
local HomeSection = HomeTab:CreateSection({Name = "Welcome", Column = 1})

HomeSection:AddLabel({
    Text = "Welcome to Atomic UI Library!",
    Size = 16
})

HomeSection:AddParagraph({
    Title = "About",
    Text = "Atomic is a minimalist, feature-rich UI library for Roblox. It features a dark mode design with white text, smooth animations, and a complete set of components for building beautiful interfaces."
})

HomeSection:AddDivider({Text = "Quick Stats"})

local StatsSection = HomeTab:CreateSection({Name = "Statistics", Column = 2})

StatsSection:AddLabel({Text = "Components: 15+"})
StatsSection:AddLabel({Text = "Animations: Smooth"})
StatsSection:AddLabel({Text = "Theme: Dark Mode"})
StatsSection:AddLabel({Text = "Version: 1.0.0"})

-- ==================== INPUTS TAB ====================
local ButtonsSection = InputsTab:CreateSection({Name = "Buttons", Column = 1})

ButtonsSection:AddButton({
    Text = "Default Button",
    Callback = function()
        print("Default button clicked!")
    end
})

ButtonsSection:AddButton({
    Text = "Primary Button",
    Style = "Primary",
    Callback = function()
        print("Primary button clicked!")
    end
})

ButtonsSection:AddButton({
    Text = "Success Button",
    Style = "Success",
    Callback = function()
        print("Success button clicked!")
    end
})

ButtonsSection:AddButton({
    Text = "Warning Button",
    Style = "Warning",
    Callback = function()
        print("Warning button clicked!")
    end
})

ButtonsSection:AddButton({
    Text = "Error Button",
    Style = "Error",
    Callback = function()
        print("Error button clicked!")
    end
})

local TogglesSection = InputsTab:CreateSection({Name = "Toggles", Column = 2})

TogglesSection:AddToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle set to:", value)
    end
})

TogglesSection:AddToggle({
    Text = "Auto-Save",
    Default = true,
    Callback = function(value)
        print("Auto-save:", value)
    end
})

TogglesSection:AddToggle({
    Text = "Disabled Toggle",
    Default = false,
    Disabled = true
})

local SlidersSection = InputsTab:CreateSection({Name = "Sliders", Column = 1})

SlidersSection:AddSlider({
    Text = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Volume:", value)
    end
})

SlidersSection:AddSlider({
    Text = "Sensitivity",
    Min = 0,
    Max = 10,
    Default = 2.5,
    Increment = 0.1,
    Precise = true,
    Callback = function(value)
        print("Sensitivity:", value)
    end
})

local TextInputsSection = InputsTab:CreateSection({Name = "Text Inputs", Column = 2})

TextInputsSection:AddTextBox({
    Label = "Username",
    Placeholder = "Enter your username...",
    Callback = function(text, enterPressed)
        print("Username:", text, "Enter pressed:", enterPressed)
    end
})

TextInputsSection:AddTextBox({
    Label = "Age (Numeric)",
    Placeholder = "Enter your age...",
    Numeric = true,
    MaxLength = 3,
    Callback = function(text)
        print("Age:", text)
    end
})

local DropdownsSection = InputsTab:CreateSection({Name = "Dropdowns", Column = 1})

DropdownsSection:AddDropdown({
    Text = "Select Game Mode",
    Options = {"Classic", "Battle Royale", "Team Deathmatch", "Capture the Flag", "Free for All"},
    Default = "Classic",
    Callback = function(value)
        print("Game mode:", value)
    end
})

DropdownsSection:AddDropdown({
    Text = "Select Weapons (Multi)",
    Options = {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    MultiSelect = true,
    Callback = function(values)
        print("Selected weapons:", table.concat(values, ", "))
    end
})

-- ==================== ADVANCED TAB ====================
local KeybindsSection = AdvancedTab:CreateSection({Name = "Keybinds", Column = 1})

KeybindsSection:AddKeybind({
    Text = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        print("UI toggled!")
    end,
    ChangedCallback = function(key)
        print("Keybind changed to:", key.Name)
    end
})

KeybindsSection:AddKeybind({
    Text = "Quick Action",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Quick action triggered!")
    end
})

local ColorsSection = AdvancedTab:CreateSection({Name = "Color Pickers", Column = 2})

ColorsSection:AddColorPicker({
    Text = "Primary Color",
    Default = Color3.fromRGB(88, 101, 242),
    Callback = function(color)
        print("Primary color:", color)
    end
})

ColorsSection:AddColorPicker({
    Text = "Secondary Color",
    Default = Color3.fromRGB(87, 242, 135),
    Callback = function(color)
        print("Secondary color:", color)
    end
})

local ProgressSection = AdvancedTab:CreateSection({Name = "Progress Bars", Column = 1})

local progress1 = ProgressSection:AddProgress({
    Text = "Download Progress",
    Default = 45,
    Max = 100
})

ProgressSection:AddButton({
    Text = "Simulate Download",
    Style = "Primary",
    Callback = function()
        progress1:Reset()
        for i = 1, 100 do
            task.wait(0.05)
            progress1:SetValue(i)
        end
        Atomic:Notify({
            Title = "Download Complete",
            Content = "Your file has been downloaded successfully.",
            Type = "Success",
            Duration = 3
        })
    end
})

local progress2 = ProgressSection:AddProgress({
    Text = "Upload Progress",
    Default = 0,
    Max = 100,
    Color = Color3.fromRGB(87, 242, 135)
})

ProgressSection:AddButton({
    Text = "Simulate Upload",
    Style = "Success",
    Callback = function()
        progress2:Reset()
        for i = 1, 100 do
            task.wait(0.03)
            progress2:Increment()
        end
        Atomic:Notify({
            Title = "Upload Complete",
            Content = "Your file has been uploaded successfully.",
            Type = "Success",
            Duration = 3
        })
    end
})

-- ==================== SETTINGS TAB ====================
local UISettingsSection = SettingsTab:CreateSection({Name = "UI Settings", Column = 1})

UISettingsSection:AddSlider({
    Text = "Window Scale",
    Min = 0.5,
    Max = 1.5,
    Default = 1,
    Increment = 0.1,
    Precise = true,
    Callback = function(value)
        -- Scale the window
        local baseSize = UDim2.fromOffset(580, 450)
        Window:SetSize(UDim2.fromOffset(baseSize.X.Offset * value, baseSize.Y.Offset * value))
    end
})

UISettingsSection:AddColorPicker({
    Text = "Accent Color",
    Default = Color3.fromRGB(88, 101, 242),
    Callback = function(color)
        Atomic:SetAccentColor(color)
    end
})

local NotificationsSection = SettingsTab:CreateSection({Name = "Notifications Test", Column = 2})

NotificationsSection:AddButton({
    Text = "Info Notification",
    Callback = function()
        Atomic:Notify({
            Title = "Information",
            Content = "This is an info notification.",
            Type = "Info",
            Duration = 5
        })
    end
})

NotificationsSection:AddButton({
    Text = "Success Notification",
    Style = "Success",
    Callback = function()
        Atomic:Notify({
            Title = "Success!",
            Content = "Operation completed successfully.",
            Type = "Success",
            Duration = 5
        })
    end
})

NotificationsSection:AddButton({
    Text = "Warning Notification",
    Style = "Warning",
    Callback = function()
        Atomic:Notify({
            Title = "Warning",
            Content = "This action cannot be undone.",
            Type = "Warning",
            Duration = 5
        })
    end
})

NotificationsSection:AddButton({
    Text = "Error Notification",
    Style = "Error",
    Callback = function()
        Atomic:Notify({
            Title = "Error",
            Content = "Something went wrong. Please try again.",
            Type = "Error",
            Duration = 5
        })
    end
})

local AboutSection = SettingsTab:CreateSection({Name = "About", Column = 1})

AboutSection:AddLabel({Text = "Atomic UI Library v1.0.0"})
AboutSection:AddLabel({Text = "Created by the Atomic Team"})
AboutSection:AddDivider()
AboutSection:AddParagraph({
    Text = "A minimalist, feature-rich UI library for Roblox featuring dark mode, smooth animations, and a complete set of components."
})

AboutSection:AddButton({
    Text = "Cleanup & Close",
    Style = "Error",
    Callback = function()
        Atomic:Cleanup()
    end
})

-- Welcome notification
task.wait(1)
Atomic:Notify({
    Title = "Welcome!",
    Content = "Atomic UI Library is ready. Press Right Control to toggle.",
    Type = "Info",
    Duration = 5
})

print("Atomic UI Demo loaded successfully!")
