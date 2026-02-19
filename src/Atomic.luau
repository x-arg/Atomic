--[[
    Atomic UI Library
    A minimalist, complete UI library for Roblox
    Version: 1.0.0
    
    Features:
    - Dark mode with white text
    - Smooth animations
    - Full component library
    - Easy to use API
]]

local Atomic = {
    Version = "1.0.0",
    Author = "Atomic Team",
    _Objects = {},
    _Connections = {},
    _Windows = {},
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Modules
local Theme = script:WaitForChild("Theme")
local Utilities = script:WaitForChild("Utilities")
local Components = script:WaitForChild("Components")

-- Load modules
Atomic.Theme = require(Theme)
Atomic.Utils = require(Utilities)

-- Component loaders
local Window = require(Components:WaitForChild("Window"))
local Tab = require(Components:WaitForChild("Tab"))
local Section = require(Components:WaitForChild("Section"))
local Button = require(Components:WaitForChild("Button"))
local Toggle = require(Components:WaitForChild("Toggle"))
local Slider = require(Components:WaitForChild("Slider"))
local TextBox = require(Components:WaitForChild("TextBox"))
local Dropdown = require(Components:WaitForChild("Dropdown"))
local Label = require(Components:WaitForChild("Label"))
local Divider = require(Components:WaitForChild("Divider"))
local Keybind = require(Components:WaitForChild("Keybind"))
local ColorPicker = require(Components:WaitForChild("ColorPicker"))
local Progress = require(Components:WaitForChild("Progress"))
local Notification = require(Components:WaitForChild("Notification"))
local Tooltip = require(Components:WaitForChild("Tooltip"))
local Paragraph = require(Components:WaitForChild("Paragraph"))

-- Create a new Window
function Atomic:CreateWindow(config)
    config = config or {}
    
    local windowConfig = {
        Title = config.Title or "Atomic",
        Size = config.Size or UDim2.fromOffset(580, 400),
        Position = config.Position or UDim2.fromOffset(100, 100),
        Theme = config.Theme or "Dark",
        AccentColor = config.AccentColor or Atomic.Theme.Accent,
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        ShowToggleButton = config.ShowToggleButton ~= false,
        Draggable = config.Draggable ~= false,
        Minimizable = config.Minimizable ~= false,
    }
    
    local window = Window.new(self, windowConfig)
    table.insert(self._Windows, window)
    
    return window
end

-- Create notification system
function Atomic:Notify(config)
    config = config or {}
    
    local notificationConfig = {
        Title = config.Title or "Notification",
        Content = config.Content or "",
        Duration = config.Duration or 5,
        Type = config.Type or "Info", -- Info, Success, Warning, Error
        Callback = config.Callback,
    }
    
    return Notification.new(self, notificationConfig)
end

-- Create global tooltip
function Atomic:CreateTooltip(parent, config)
    config = config or {}
    return Tooltip.new(self, parent, config)
end

-- Cleanup all objects
function Atomic:Cleanup()
    for _, connection in ipairs(self._Connections) do
        if connection.Disconnect then
            connection:Disconnect()
        end
    end
    
    for _, object in ipairs(self._Objects) do
        if object.Destroy then
            object:Destroy()
        end
    end
    
    self._Connections = {}
    self._Objects = {}
    self._Windows = {}
end

-- Get all windows
function Atomic:GetWindows()
    return self._Windows
end

-- Set global accent color
function Atomic:SetAccentColor(color)
    self.Theme.Accent = color
    for _, window in ipairs(self._Windows) do
        window:UpdateAccentColor(color)
    end
end

-- Export components for direct access
Atomic.Components = {
    Window = Window,
    Tab = Tab,
    Section = Section,
    Button = Button,
    Toggle = Toggle,
    Slider = Slider,
    TextBox = TextBox,
    Dropdown = Dropdown,
    Label = Label,
    Divider = Divider,
    Keybind = Keybind,
    ColorPicker = ColorPicker,
    Progress = Progress,
    Notification = Notification,
    Tooltip = Tooltip,
    Paragraph = Paragraph,
}

return Atomic
