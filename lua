local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local selectedTarget = nil
local isAntiAfkMode = false
local isAttacking = false


task.spawn(function()
  
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 999999
    Lighting.Technology = Enum.Technology.Compatibility

    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v.Enabled = false
        end
    end


    local function optimizeObject(obj)
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("ParticleEmitter") 
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Trail") or obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        optimizeObject(v)
    end

    Workspace.DescendantAdded:Connect(optimizeObject)
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    task.wait(0.2)
    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)


task.spawn(function()
    while true do
        task.wait(60)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
        end)
    end
end)


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "fuck"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 360)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "UBG Bot [Max Optimized]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Title.Parent = Frame

local NickLabel = Instance.new("TextLabel")
NickLabel.Size = UDim2.new(0.9, 0, 0, 20)
NickLabel.Position = UDim2.new(0.05, 0, 0, 28)
NickLabel.Text = "UR NICK " .. LocalPlayer.Name
NickLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
NickLabel.BackgroundTransparency = 1
NickLabel.TextSize = 13
NickLabel.TextXAlignment = Enum.TextXAlignment.Left
NickLabel.Parent = Frame

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0.9, 0, 0, 35)
ModeBtn.Position = UDim2.new(0.05, 0, 0, 55)
ModeBtn.Text = "ATTACKER"
ModeBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 140)
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.TextSize = 14
ModeBtn.Parent = Frame

local AttackerContainer = Instance.new("Frame")
AttackerContainer.Size = UDim2.new(1, 0, 0, 230)
AttackerContainer.Position = UDim2.new(0, 0, 0, 95)
AttackerContainer.BackgroundTransparency = 1
AttackerContainer.Parent = Frame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 110)
Scroll.Position = UDim2.new(0.05, 0, 0, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = AttackerContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = Scroll

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.9, 0, 0, 25)
TargetLabel.Position = UDim2.new(0.05, 0, 0, 115)
TargetLabel.Text = "PLAYER: not"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = AttackerContainer

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 145)
ToggleBtn.Text = "AUTO ATTACK : OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.Parent = AttackerContainer

ModeBtn.MouseButton1Click:Connect(function()
    isAntiAfkMode = not isAntiAfkMode
    if isAntiAfkMode then
        ModeBtn.Text = "AFK"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(140, 100, 40)
        AttackerContainer.Visible = false 
        isAttacking = false
        ToggleBtn.Text = "AUTOATACK OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
    else
        ModeBtn.Text = "ATTACKER"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 140)
        AttackerContainer.Visible = true
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isAttacking = not isAttacking
    if isAttacking then
        ToggleBtn.Text = "AUTO ATTACK ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
    else
        ToggleBtn.Text = "AUTO ATACKK OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
    end
end)

local function refreshPlayerList()
    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 25)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = player.Name
            btn.Parent = Scroll

            btn.MouseButton1Click:Connect(function()
                selectedTarget = player
                TargetLabel.Text = "PLAYER: " .. player.Name
            end)
        end
    end
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)


local lastAttack = 0
local attackInterval = 0.15

RunService.RenderStepped:Connect(function()
    if isAntiAfkMode or not isAttacking or not selectedTarget or not selectedTarget.Character then return end
    
    local tRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
    local myChar = LocalPlayer.Character
    if not myChar or not tRoot then return end
    
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local targetPos = tRoot.Position
    myRoot.CFrame = CFrame.new(targetPos - (tRoot.CFrame.LookVector * 2), targetPos)
    
    if tick() - lastAttack >= attackInterval then
        lastAttack = tick()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end)
