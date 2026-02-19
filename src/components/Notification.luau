--[[
    Atomic UI Library - Notification Component
    Toast notification system
]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Notification = {}
Notification.__index = Notification

Notification._Queue = {}
Notification._Container = nil
Notification._ActiveCount = 0
Notification._MaxActive = 5

function Notification.new(library, config)
    local self = setmetatable({}, Notification)
    
    self.Library = library
    self.Theme = library.Theme
    self.Utils = library.Utils
    
    self.Config = config
    self.Title = config.Title or "Notification"
    self.Content = config.Content or ""
    self.Duration = config.Duration or 5
    self.Type = config.Type or "Info" -- Info, Success, Warning, Error
    self.Callback = config.Callback
    
    self:_CreateNotification()
    
    return self
end

function Notification:_GetContainer()
    if not Notification._Container then
        local container = Instance.new("Frame")
        container.Name = "Notifications"
        container.Size = UDim2.fromScale(1, 1)
        container.Position = UDim2.fromScale(0, 0)
        container.BackgroundTransparency = 1
        container.IgnoreGuiInset = true
        container.Parent = CoreGui
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 50)
        padding.PaddingRight = UDim.new(0, 20)
        padding.PaddingBottom = UDim.new(0, 20)
        padding.Parent = container
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Padding = UDim.new(0, 10)
        layout.Parent = container
        
        Notification._Container = container
        table.insert(self.Library._Objects, container)
    end
    
    return Notification._Container
end

function Notification:_CreateNotification()
    -- Get status color
    local statusColors = {
        Info = self.Theme.Info,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error,
    }
    local statusColor = statusColors[self.Type] or self.Theme.Info
    
    -- Container
    local container = Instance.new("Frame")
    container.Name = "Notification"
    container.Size = UDim2.fromOffset(300, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundColor3 = self.Theme.Card
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.Parent = self:_GetContainer()
    self.Container = container
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Thickness = 1
    containerStroke.Color = self.Theme.Border
    containerStroke.Parent = container
    
    -- Status indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.fromOffset(4, 0)
    indicator.BackgroundColor3 = statusColor
    indicator.BorderSizePixel = 0
    indicator.Parent = container
    self.Indicator = indicator
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.fromScale(1, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.Parent = container
    self.ContentFrame = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.Parent = content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 4)
    contentLayout.Parent = content
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.fromScale(1, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y
    header.BackgroundTransparency = 1
    header.Parent = content
    self.Header = header
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    headerLayout.Parent = header
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.fromOffset(18, 18)
    icon.BackgroundTransparency = 1
    icon.Text = self:_GetIcon()
    icon.TextColor3 = statusColor
    icon.TextSize = 14
    icon.FontFace = self.Theme.Font.Bold
    icon.LayoutOrder = 1
    icon.Parent = header
    self.Icon = icon
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 0)
    title.AutomaticSize = Enum.AutomaticSize.XY
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = self.Theme.TextPrimary
    title.TextSize = 14
    title.FontFace = self.Theme.Font.Bold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 2
    title.Parent = header
    self.TitleLabel = title
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.TextMuted
    closeBtn.TextSize = 16
    closeBtn.FontFace = self.Theme.Font.Bold
    closeBtn.LayoutOrder = 3
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    self.CloseButton = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Dismiss()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        self.Utils:QuickTween(closeBtn, {TextColor3 = self.Theme.TextPrimary})
    end)
    
    closeBtn.MouseLeave:Connect(function()
        self.Utils:QuickTween(closeBtn, {TextColor3 = self.Theme.TextMuted})
    end)
    
    -- Content text
    if self.Content and self.Content ~= "" then
        local contentText = Instance.new("TextLabel")
        contentText.Name = "Text"
        contentText.Size = UDim2.fromScale(1, 0)
        contentText.AutomaticSize = Enum.AutomaticSize.Y
        contentText.BackgroundTransparency = 1
        contentText.Text = self.Content
        contentText.TextColor3 = self.Theme.TextSecondary
        contentText.TextSize = 12
        contentText.FontFace = self.Theme.Font.Main
        contentText.TextWrapped = true
        contentText.TextXAlignment = Enum.TextXAlignment.Left
        contentText.TextYAlignment = Enum.TextYAlignment.Top
        contentText.Parent = content
        self.ContentLabel = contentText
    end
    
    -- Progress bar
    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressContainer"
    progressContainer.Size = UDim2.fromScale(1, 0)
    progressContainer.AutomaticSize = Enum.AutomaticSize.Y
    progressContainer.BackgroundTransparency = 1
    progressContainer.Parent = content
    self.ProgressContainer = progressContainer
    
    local progressPadding = Instance.new("UIPadding")
    progressPadding.PaddingTop = UDim.new(0, 8)
    progressPadding.Parent = progressContainer
    
    local progressBg = Instance.new("Frame")
    progressBg.Name = "Background"
    progressBg.Size = UDim2.fromScale(1, 0)
    progressBg.BackgroundColor3 = self.Theme.Border
    progressBg.BackgroundTransparency = 0.5
    progressBg.BorderSizePixel = 0
    progressBg.Parent = progressContainer
    self.ProgressBg = progressBg
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(1, 0)
    progressBgCorner.Parent = progressBg
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.fromScale(1, 0)
    progressFill.BackgroundColor3 = statusColor
    progressFill.BackgroundTransparency = 0.3
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    self.ProgressFill = progressFill
    
    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(1, 0)
    progressFillCorner.Parent = progressFill
    
    -- Animate in
    container.Position = UDim2.fromScale(1.2, 0)
    self.Utils:Tween(container, self.Theme.Animation.Normal, {
        Position = UDim2.fromScale(0, 0)
    })
    
    -- Start auto-dismiss timer
    self:_StartTimer()
    
    -- Hover to pause
    container.MouseEnter:Connect(function()
        self:_PauseTimer()
    end)
    
    container.MouseLeave:Connect(function()
        self:_ResumeTimer()
    end)
    
    Notification._ActiveCount = Notification._ActiveCount + 1
end

function Notification:_GetIcon()
    local icons = {
        Info = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Error = "✕",
    }
    return icons[self.Type] or "ℹ"
end

function Notification:_StartTimer()
    self.StartTime = tick()
    self.RemainingTime = self.Duration
    
    self.TimerConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not self.Paused then
            self.RemainingTime = self.RemainingTime - game:GetService("RunService").Heartbeat:Wait()
            
            local progress = self.RemainingTime / self.Duration
            self.ProgressFill.Size = UDim2.fromScale(progress, 0)
            
            if self.RemainingTime <= 0 then
                self:Dismiss()
            end
        end
    end)
end

function Notification:_PauseTimer()
    self.Paused = true
    self.Utils:QuickTween(self.ProgressFill, {BackgroundTransparency = 0})
end

function Notification:_ResumeTimer()
    self.Paused = false
    self.Utils:QuickTween(self.ProgressFill, {BackgroundTransparency = 0.3})
end

function Notification:Dismiss()
    if self.Dismissing then return end
    self.Dismissing = true
    
    if self.TimerConnection then
        self.TimerConnection:Disconnect()
    end
    
    self.Utils:Tween(self.Container, self.Theme.Animation.Fast, {
        Position = UDim2.fromScale(1.2, 0),
        BackgroundTransparency = 1
    })
    
    task.delay(0.2, function()
        if self.Callback then
            self.Callback()
        end
        self.Container:Destroy()
        Notification._ActiveCount = Notification._ActiveCount - 1
    end)
end

function Notification:SetTitle(title)
    self.Title = title
    self.TitleLabel.Text = title
end

function Notification:SetContent(content)
    self.Content = content
    if self.ContentLabel then
        self.ContentLabel.Text = content
    end
end

return Notification
