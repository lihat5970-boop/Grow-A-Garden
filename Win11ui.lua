-- 窗口控制功能
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    toggleBtn.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    toggleBtn.Visible = false
end)

-- 拖拽逻辑
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- 使浮动按钮也可拖拽
local toggleDragging, toggleDragStart, toggleStartPos

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        toggleBtn.Position = UDim2.new(
            toggleStartPos.X.Scale, 
            toggleStartPos.X.Offset + delta.X,
            toggleStartPos.Y.Scale,
            toggleStartPos.Y.Offset + delta.Y
        )
    end
end)-- 浮动显示/隐藏按钮
local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "≡"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
toggleBtn.BorderSizePixel = 0
toggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Visible = false
toggleBtn.Parent = gui

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -52)
contentFrame.Position = UDim2.new(0, 10, 0, 42)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- 创建按钮的函数
local function createWin11Button(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.Parent = contentFrame
    return btn
end

-- 创建功能按钮
local teleportBtn = createWin11Button("传送回家", 0, Color3.fromRGB(0, 90, 158))
local speedBtn = createWin11Button("速度: 16", 50, Color3.fromRGB(16, 124, 16))
local script1Btn = createWin11Button("Script 1", 100, Color3.fromRGB(128, 0, 128))

-- 速度按钮功能
local currentSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed == 16 and 50 or currentSpeed == 50 and 100 or 16
    speedBtn.Text = "速度: "..currentSpeed
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = currentSpeed end
end)

-- 传送按钮功能
teleportBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then char:PivotTo(CFrame.new(0, 100, 0)) end
end)

-- Script 1按钮功能
script1Btn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/nootmaus/GrowAgarden/refs/heads/main/mauscripts',true))()
    end)
    
    if success then
        script1Btn.Text = "✓ 已执行"
    else
        script1Btn.Text = "错误!"
        warn("脚本加载失败: "..err)
    end
    task.wait(1)
    script1Btn.Text = "Script 1"
end)local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Win11UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 主窗口框架
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
frame.BorderSizePixel = 0

-- 窗口阴影
local windowShadow = Instance.new("ImageLabel")
windowShadow.Name = "Shadow"
windowShadow.Image = "rbxassetid://1316045217"
windowShadow.ImageColor3 = Color3.new(0, 0, 0)
windowShadow.ImageTransparency = 0.8
windowShadow.ScaleType = Enum.ScaleType.Slice
windowShadow.SliceCenter = Rect.new(10, 10, 118, 118)
windowShadow.Size = UDim2.new(1, 14, 1, 14)
windowShadow.Position = UDim2.new(0, -7, 0, -7)
windowShadow.BackgroundTransparency = 1
windowShadow.Parent = frame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BackgroundTransparency = 0.3

local titleText = Instance.new("TextLabel")
titleText.Text = "Windows 11 Menu"
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(240, 240, 240)
titleText.Font = Enum.Font.SourceSansSemibold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 最小化按钮
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "─"
minimizeBtn.Size = UDim2.new(0, 46, 0, 32)
minimizeBtn.Position = UDim2.new(1, -92, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 46, 0, 32)
closeBtn.Position = UDim2.new(1, -46, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BackgroundTransparency = 0.5
closeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar

titleBar.Parent = frame
frame.Parent = gui
