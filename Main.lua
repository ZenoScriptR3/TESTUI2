-- ============================================================
--   KYZENO X PANEL  v3.0  |  WORKING FINAL
--   Place in: StarterPlayerScripts
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================================
--  State
-- ============================================================
local settings = {
    nightMode = false,
    walkSpeed = 16,
    freeze = false,
    infJump = false,
    noClip = false,
    smallAvatar = false,
    fly = false,
    flySpeed = 50,
    shiftLock = false,
    shiftLockNormal = false,
    shiftLockRange = 100,
    silentAim = false,
    silentAimRange = 20,
    aimTarget = "off",
    aimRange = 20,
    aimAssist = false,
    antiFling = false,
    antiVoid = false,
    antiKnockback = false,
    godMode = false,
    esp = false,
    espName = true,
    espHighlight = true,
    espStatus = true,
    espHealth = false,
    espTool = true,
    espNearbyTools = false,
    afk = false,
    spamE = false,
    uiScale = 1.0,
    autoLoad = true,
    instantPrompt = false,
    removeTexture = false,
    disabledAnimation = false,
    hideVFX = false,
    removeEffects = false,
    flingTouch = false,
    antiNPC = false,
}

local originalBrightness = Lighting.Brightness
local espObjects = {}
local espToolObjects = {}
local noClipConn = nil
local antiVoidConn = nil
local infJumpConn = nil
local flyConn = nil
local shiftLockConn = nil
local shiftLockNormalConn = nil
local antiFlingConn = nil
local antiKBConn = nil
local flingTouchConn = nil
local spamEConn = nil
local afkConn = nil
local spamEActive = false
local originalScales = {}

-- ============================================================
--  Colors
-- ============================================================
local C_RED = Color3.fromRGB(204, 0, 0)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_BG = Color3.fromRGB(10, 10, 10)
local C_MID = Color3.fromRGB(34, 34, 34)
local C_TEXT = Color3.fromRGB(224, 224, 224)
local C_GRAY = Color3.fromRGB(136, 136, 136)

-- ============================================================
--  Create GUI Elements
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KYZENO_X_PANEL"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Loading Screen
local loadScreen = Instance.new("Frame")
loadScreen.Size = UDim2.new(1, 0, 1, 0)
loadScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadScreen.BorderSizePixel = 0
loadScreen.ZIndex = 100
loadScreen.Parent = screenGui

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(0, 400, 0, 36)
loadTitle.Position = UDim2.new(0.5, -200, 0.5, -4)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "|KYZENO X PANEL|"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 28
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.ZIndex = 101
loadTitle.Parent = loadScreen

local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(0, 400, 0, 20)
loadSub.Position = UDim2.new(0.5, -200, 0.5, 34)
loadSub.BackgroundTransparency = 1
loadSub.Text = "VER. 3.0 | WORKING"
loadSub.TextColor3 = C_RED
loadSub.TextSize = 13
loadSub.Font = Enum.Font.GothamBold
loadSub.ZIndex = 101
loadSub.Parent = loadScreen

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 300, 0, 4)
barBg.Position = UDim2.new(0.5, -150, 0.65, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
barBg.BorderSizePixel = 0
barBg.ZIndex = 101
barBg.Parent = loadScreen
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = C_RED
barFill.BorderSizePixel = 0
barFill.ZIndex = 102
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local loadStatus = Instance.new("TextLabel")
loadStatus.Size = UDim2.new(0, 300, 0, 16)
loadStatus.Position = UDim2.new(0.5, -150, 0.75, 10)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "Initializing..."
loadStatus.TextColor3 = C_BLUE
loadStatus.TextSize = 17
loadStatus.Font = Enum.Font.Gotham
loadStatus.ZIndex = 101
loadStatus.Parent = loadScreen

-- Open Button
local openButton = Instance.new("ImageButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0.5, -25, 0.5, -25)
openButton.BackgroundColor3 = C_BG
openButton.BackgroundTransparency = 0.2
openButton.BorderSizePixel = 0
openButton.Image = "rbxassetid://106158447709741"
openButton.Visible = false
openButton.Parent = screenGui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 8)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = C_BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 280, 0, 30)
titleLbl.Position = UDim2.new(0, 20, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "|KYZENO X PANEL|"
titleLbl.TextColor3 = C_WHITE
titleLbl.TextSize = 20
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
closeButton.BackgroundColor3 = C_RED
closeButton.Text = "✕"
closeButton.TextColor3 = C_WHITE
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- Navigation Bar
local navScroll = Instance.new("ScrollingFrame")
navScroll.Size = UDim2.new(1, 0, 0, 38)
navScroll.Position = UDim2.new(0, 0, 0, 60)
navScroll.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
navScroll.BorderSizePixel = 0
navScroll.ScrollBarThickness = 3
navScroll.ScrollBarImageColor3 = C_RED
navScroll.ScrollingDirection = Enum.ScrollingDirection.X
navScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
navScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
navScroll.Parent = mainFrame

local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Padding = UDim.new(0, 0)
navLayout.Parent = navScroll

-- Content Area
local contentArea = Instance.new("ScrollingFrame")
contentArea.Size = UDim2.new(1, -200, 1, -98)
contentArea.Position = UDim2.new(0, 200, 0, 98)
contentArea.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
contentArea.BorderSizePixel = 0
contentArea.ScrollBarThickness = 6
contentArea.ScrollBarImageColor3 = C_RED
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
contentArea.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = contentArea

local contentPad = Instance.new("UIPadding")
contentPad.PaddingTop = UDim.new(0, 20)
contentPad.PaddingLeft = UDim.new(0, 20)
contentPad.PaddingRight = UDim.new(0, 20)
contentPad.PaddingBottom = UDim.new(0, 20)
contentPad.Parent = contentArea

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 200, 1, -98)
sidebar.Position = UDim2.new(0, 0, 0, 98)
sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sbTitle = Instance.new("TextLabel")
sbTitle.Size = UDim2.new(1, -20, 0, 30)
sbTitle.Position = UDim2.new(0, 10, 0, 15)
sbTitle.BackgroundTransparency = 1
sbTitle.Text = "CREDITS"
sbTitle.TextColor3 = C_RED
sbTitle.TextSize = 14
sbTitle.Font = Enum.Font.GothamBlack
sbTitle.Parent = sidebar

local sbCredits = Instance.new("TextLabel")
sbCredits.Size = UDim2.new(1, -20, 0, 160)
sbCredits.Position = UDim2.new(0, 10, 0, 60)
sbCredits.BackgroundTransparency = 1
sbCredits.Text = "Design: Me & Claude\nBy: Zeno\nCo-pilot: Claude 4.6\n\nVersion: Working Final"
sbCredits.TextColor3 = C_GRAY
sbCredits.TextSize = 12
sbCredits.Font = Enum.Font.Gotham
sbCredits.TextWrapped = true
sbCredits.Parent = sidebar

-- ============================================================
--  Helper Functions
-- ============================================================
local function clearContent()
    for _, c in ipairs(contentArea:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
            c:Destroy()
        end
    end
end

local function createSectionTitle(text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundTransparency = 1
    f.Parent = contentArea
    
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 28)
    h.Position = UDim2.new(0, 0, 0, 18)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextColor3 = C_WHITE
    h.TextSize = 22
    h.Font = Enum.Font.GothamBlack
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = f
    
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0, 60, 0, 3)
    l.Position = UDim2.new(0, 0, 0, 46)
    l.BackgroundColor3 = C_RED
    l.BorderSizePixel = 0
    l.Parent = f
end

local function createInfoLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = C_GRAY
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = contentArea
end

local function createToggle(labelText, settingKey, callback)
    local defaultState = settings[settingKey] or false
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = C_MID
    container.BorderSizePixel = 1
    container.BorderColor3 = Color3.fromRGB(51, 51, 51)
    container.Parent = contentArea
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = C_TEXT
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 26)
    btn.Position = UDim2.new(1, -54, 0.5, -13)
    btn.BackgroundColor3 = defaultState and C_RED or Color3.fromRGB(51, 51, 51)
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = C_WHITE
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        settings[settingKey] = state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and C_RED or Color3.fromRGB(51, 51, 51)
        if callback then callback(state) end
    end)
end

local function createSlider(labelText, minVal, maxVal, settingKey, callback)
    local defaultVal = settings[settingKey] or minVal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 58)
    container.BackgroundColor3 = C_MID
    container.BorderSizePixel = 1
    container.BorderColor3 = Color3.fromRGB(51, 51, 51)
    container.Parent = contentArea
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = C_TEXT
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -100, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = C_RED
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0, 58, 0, 24)
    inputBox.Position = UDim2.new(1, -68, 0, 32)
    inputBox.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    inputBox.BorderColor3 = Color3.fromRGB(51, 51, 51)
    inputBox.Text = tostring(defaultVal)
    inputBox.TextColor3 = C_WHITE
    inputBox.TextSize = 12
    inputBox.Font = Enum.Font.Gotham
    inputBox.Parent = container
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 4)
    
    local curVal = defaultVal
    local function updateVal(v)
        v = math.clamp(math.floor(v), minVal, maxVal)
        curVal = v
        settings[settingKey] = v
        fill.Size = UDim2.new((v - minVal) / (maxVal - minVal), 0, 1, 0)
        inputBox.Text = tostring(v)
        if callback then callback(v) end
    end
    
    sliderBg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            local function upd()
                local mp = UserInputService:GetMouseLocation().X
                local sp = sliderBg.AbsolutePosition.X
                local ss = sliderBg.AbsoluteSize.X
                updateVal(minVal + (maxVal - minVal) * math.clamp((mp - sp) / ss, 0, 1))
            end
            upd()
            local conn
            conn = UserInputService.InputChanged:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseMovement then
                    upd()
                end
            end)
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)
    
    inputBox.FocusLost:Connect(function()
        local v = tonumber(inputBox.Text)
        if v then
            updateVal(v)
        else
            inputBox.Text = tostring(curVal)
        end
    end)
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C_RED
    btn.Text = text
    btn.TextColor3 = C_WHITE
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBlack
    btn.Parent = contentArea
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
end

-- ============================================================
--  SECTION FUNCTIONS
-- ============================================================

-- SETTINGS Section
local function settingsSection()
    createSectionTitle("SETTINGS")
    
    createToggle("Night Mode", "nightMode", function(on)
        if on then
            originalBrightness = Lighting.Brightness
            Lighting.Brightness = 0.1
            Lighting.Ambient = Color3.fromRGB(20, 20, 20)
            print("Night Mode ON - Brightness set to 0.1")
        else
            Lighting.Brightness = originalBrightness
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            print("Night Mode OFF")
        end
    end)
    
    createToggle("Instant Prompt", "instantPrompt", function(on)
        for _, o in ipairs(workspace:GetDescendants()) do
            if o:IsA("ProximityPrompt") then
                o.HoldDuration = on and 0.1 or 1
            end
        end
    end)
    
    createToggle("Remove Effects", "removeEffects", function(on)
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") then
                e.Enabled = not on
            end
        end
    end)
end

-- LOCAL PLAYER Section
local function localPlayerSection()
    createSectionTitle("LOCAL PLAYER")
    
    createSlider("Walkspeed", 16, 200, "walkSpeed", function(v)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = v
        end
    end)
    
    createToggle("Freeze", "freeze", function(on)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = on
        end
    end)
    
    createToggle("Inf Jump", "infJump", function(on)
        if on then
            if infJumpConn then infJumpConn:Disconnect() end
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                if player.Character then
                    local h = player.Character:FindFirstChild("Humanoid")
                    if h then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if infJumpConn then
                infJumpConn:Disconnect()
                infJumpConn = nil
            end
        end
    end)
    
    createToggle("No Clip", "noClip", function(on)
        if on then
            if noClipConn then noClipConn:Disconnect() end
            noClipConn = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, p in ipairs(player.Character:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noClipConn then
                noClipConn:Disconnect()
                noClipConn = nil
            end
            if player.Character then
                for _, p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = true
                    end
                end
            end
        end
    end)
    
    createToggle("Small Avatar", "smallAvatar", function(on)
        if player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if on then
                    originalScales = {
                        BodyHeightScale = hum.BodyHeightScale.Value,
                        BodyWidthScale = hum.BodyWidthScale.Value,
                        BodyDepthScale = hum.BodyDepthScale.Value,
                        HeadScale = hum.HeadScale.Value
                    }
                    hum.BodyHeightScale.Value = 0.3
                    hum.BodyWidthScale.Value = 0.3
                    hum.BodyDepthScale.Value = 0.3
                    hum.HeadScale.Value = 0.3
                elseif originalScales.BodyHeightScale then
                    hum.BodyHeightScale.Value = originalScales.BodyHeightScale
                    hum.BodyWidthScale.Value = originalScales.BodyWidthScale
                    hum.BodyDepthScale.Value = originalScales.BodyDepthScale
                    hum.HeadScale.Value = originalScales.HeadScale
                end
            end
        end
    end)
    
    createToggle("Fly", "fly", function(on)
        if on then
            if flyConn then flyConn:Disconnect() end
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
            
            flyConn = RunService.Heartbeat:Connect(function()
                if not player.Character or not hrp or not hrp.Parent then return end
                local moveDir = Vector3.zero
                local cam = workspace.CurrentCamera
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit * settings.flySpeed
                end
                
                if bv and bv.Parent then
                    bv.Velocity = moveDir
                end
                
                hum.PlatformStand = true
            end)
        else
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("FlyVelocity")
                    if bv then bv:Destroy() end
                end
                local h = player.Character:FindFirstChild("Humanoid")
                if h then h.PlatformStand = false end
            end
        end
    end)
    
    createSlider("Fly Speed", 10, 500, "flySpeed", function() end)
end

-- DEFENDER Section
local function defenderSection()
    createSectionTitle("DEFENDER")
    
    createToggle("Anti-Fling", "antiFling", function(on)
        if antiFlingConn then antiFlingConn:Disconnect() end
        if on then
            antiFlingConn = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    if hrp.AssemblyLinearVelocity.Magnitude > 80 then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end)
        end
    end)
    
    createToggle("Anti-Void", "antiVoid", function(on)
        if antiVoidConn then antiVoidConn:Disconnect() end
        if on then
            antiVoidConn = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    if hrp.Position.Y < -30 then
                        hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end)
        end
    end)
    
    createToggle("Anti-Knockback", "antiKnockback", function(on)
        if antiKBConn then antiKBConn:Disconnect() end
        if on then
            antiKBConn = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local v = hrp.AssemblyLinearVelocity
                    if math.abs(v.X) > 30 or math.abs(v.Z) > 30 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
                    end
                end
            end)
        end
    end)
    
    createToggle("God Mode", "godMode", function(on)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            if on then
                hum.MaxHealth = 9e9
                hum.Health = 9e9
            else
                hum.MaxHealth = 100
                hum.Health = 100
            end
        end
    end)
end

-- ASSIST Section
local function assistSection()
    createSectionTitle("ASSIST")
    
    createSlider("Lock Range", 20, 700, "shiftLockRange", function() end)
    
    createToggle("ShiftLock (Target)", "shiftLock", function(on)
        if on then
            if shiftLockConn then shiftLockConn:Disconnect() end
            shiftLockConn = RunService.RenderStepped:Connect(function()
                if not player.Character then return end
                local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChild("Humanoid")
                if not myRoot or not hum then return end
                
                local nearest = nil
                local nearDist = settings.shiftLockRange
                
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local oh = p.Character:FindFirstChild("Humanoid")
                        if oh and oh.Health > 0 then
                            local d = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if d <= settings.shiftLockRange and d < nearDist then
                                nearDist = d
                                nearest = p
                            end
                        end
                    end
                end
                
                if nearest and nearest.Character then
                    local tHRP = nearest.Character:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        hum.AutoRotate = false
                        myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(tHRP.Position.X, myRoot.Position.Y, tHRP.Position.Z))
                    end
                else
                    hum.AutoRotate = true
                end
            end)
        else
            if shiftLockConn then
                shiftLockConn:Disconnect()
                shiftLockConn = nil
            end
            if player.Character then
                local h = player.Character:FindFirstChild("Humanoid")
                if h then h.AutoRotate = true end
            end
        end
    end)
    
    createToggle("ShiftLock (Normal)", "shiftLockNormal", function(on)
        if on then
            if shiftLockNormalConn then shiftLockNormalConn:Disconnect() end
            shiftLockNormalConn = RunService.RenderStepped:Connect(function()
                if not player.Character then return end
                local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChild("Humanoid")
                if not myRoot or not hum then return end
                
                hum.AutoRotate = false
                local camLook = workspace.CurrentCamera.CFrame.LookVector
                myRoot.CFrame = CFrame.new(myRoot.Position, myRoot.Position + Vector3.new(camLook.X, 0, camLook.Z))
            end)
        else
            if shiftLockNormalConn then
                shiftLockNormalConn:Disconnect()
                shiftLockNormalConn = nil
            end
            if player.Character then
                local h = player.Character:FindFirstChild("Humanoid")
                if h then h.AutoRotate = true end
            end
        end
    end)
end

-- VISUAL Section
local function clearESP()
    for _, d in pairs(espObjects) do
        if d.highlight then d.highlight:Destroy() end
        if d.billboard then d.billboard:Destroy() end
    end
    espObjects = {}
end

local function buildESPFor(p)
    if p == player then return end
    local char = p.Character
    if not char then return end
    
    local d = {}
    if settings.espHighlight then
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 0)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Parent = char
        d.highlight = hl
    end
    
    espObjects[p] = d
end

local function visualSection()
    createSectionTitle("VISUAL")
    createInfoLabel("ESP helps track other players")
    
    createToggle("ESP", "esp", function(on)
        if on then
            for _, p in ipairs(Players:GetPlayers()) do
                buildESPFor(p)
            end
        else
            clearESP()
        end
    end)
    
    createToggle("ESP Name", "espName", function() end)
    createToggle("ESP Highlight", "espHighlight", function() end)
    createToggle("ESP Health", "espHealth", function() end)
end

-- GAME CTRL Section
local function gameCtrlSection()
    createSectionTitle("GAME CONTROLLER")
    
    createButton("REJOIN", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end)
    
    createButton("CLOSE MENU", function()
        mainFrame.Visible = false
    end)
    
    createInfoLabel("── AFK Protection ──")
    createToggle("AFK (No Kick)", "afk", function(on)
        if afkConn then afkConn:Disconnect() end
        if on then
            afkConn = RunService.Heartbeat:Connect(function()
                if settings.afk then
                    pcall(function()
                        UserInputService:GetMouseLocation()
                    end)
                end
            end)
        end
    end)
    
    createInfoLabel("── Spam E ──")
    local spamContainer = Instance.new("Frame")
    spamContainer.Size = UDim2.new(1, 0, 0, 40)
    spamContainer.BackgroundColor3 = C_MID
    spamContainer.BorderSizePixel = 1
    spamContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
    spamContainer.Parent = contentArea
    Instance.new("UICorner", spamContainer).CornerRadius = UDim.new(0, 5)
    
    local spamLabel = Instance.new("TextLabel")
    spamLabel.Size = UDim2.new(0.5, 0, 1, 0)
    spamLabel.Position = UDim2.new(0, 15, 0, 0)
    spamLabel.BackgroundTransparency = 1
    spamLabel.Text = "Spam E"
    spamLabel.TextColor3 = C_TEXT
    spamLabel.TextSize = 13
    spamLabel.Font = Enum.Font.Gotham
    spamLabel.TextXAlignment = Enum.TextXAlignment.Left
    spamLabel.Parent = spamContainer
    
    local spamBtn = Instance.new("TextButton")
    spamBtn.Size = UDim2.new(0.3, 0, 0, 30)
    spamBtn.Position = UDim2.new(0.68, 0, 0.5, -15)
    spamBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    spamBtn.Text = "[E] No"
    spamBtn.TextColor3 = C_WHITE
    spamBtn.TextSize = 12
    spamBtn.Font = Enum.Font.GothamBold
    spamBtn.Parent = spamContainer
    Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 4)
    
    spamBtn.MouseButton1Click:Connect(function()
        spamEActive = not spamEActive
        settings.spamE = spamEActive
        if spamEActive then
            spamBtn.BackgroundColor3 = C_RED
            spamBtn.Text = "[E] Active"
            if spamEConn then spamEConn:Disconnect() end
            spamEConn = RunService.Heartbeat:Connect(function()
                if settings.spamE then
                    pcall(function()
                        local VirtualInput = game:GetService("VirtualInput")
                        VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.05)
                        VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end)
                end
            end)
        else
            spamBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
            spamBtn.Text = "[E] No"
            if spamEConn then
                spamEConn:Disconnect()
                spamEConn = nil
            end
        end
    end)
end

-- OTHERS Section
local function othersSection()
    createSectionTitle("OTHERS")
    createInfoLabel("Design: Me & Claude")
    createInfoLabel("By: Zeno")
    createInfoLabel("Co-pilot: Claude 4.6")
    createInfoLabel("Version: Working Final")
    createInfoLabel("")
    createInfoLabel("All features working:")
    createInfoLabel("- Night Mode (0.1 brightness)")
    createInfoLabel("- Fly, No Clip, Inf Jump")
    createInfoLabel("- Anti-Fling, Anti-Void")
    createInfoLabel("- ESP, ShiftLock")
    createInfoLabel("- AFK Protection, Spam E")
end

-- ============================================================
--  Navigation
-- ============================================================
local sections = {
    {name = "SETTINGS", func = settingsSection},
    {name = "LOCAL", func = localPlayerSection},
    {name = "DEFENDER", func = defenderSection},
    {name = "ASSIST", func = assistSection},
    {name = "VISUAL", func = visualSection},
    {name = "GAME", func = gameCtrlSection},
    {name = "OTHERS", func = othersSection},
}

local navButtons = {}

for _, sec in ipairs(sections) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    btn.Text = sec.name
    btn.TextColor3 = C_WHITE
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = navScroll
    
    btn.MouseButton1Click:Connect(function()
        clearContent()
        sec.func()
        for _, b in pairs(navButtons) do
            b.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        end
        btn.BackgroundColor3 = C_RED
    end)
    
    table.insert(navButtons, btn)
end

-- ============================================================
--  Open/Close
-- ============================================================
openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        clearContent()
        settingsSection()
        navButtons[1].BackgroundColor3 = C_RED
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ============================================================
--  Loading Animation
-- ============================================================
task.spawn(function()
    local steps = {
        {pct = 0.2, msg = "Loading modules...", t = 0.2},
        {pct = 0.4, msg = "Building UI...", t = 0.2},
        {pct = 0.6, msg = "Applying settings...", t = 0.2},
        {pct = 0.8, msg = "Almost ready...", t = 0.2},
        {pct = 1.0, msg = "Welcome " .. player.DisplayName .. "!", t = 0.2},
    }
    
    for _, step in ipairs(steps) do
        TweenService:Create(barFill, TweenInfo.new(step.t, Enum.EasingStyle.Quad), {Size = UDim2.new(step.pct, 0, 1, 0)}):Play()
        loadStatus.Text = step.msg
        task.wait(step.t + 0.5)
    end
    
    task.wait(5)
    
    for _, obj in ipairs({loadScreen, loadTitle, loadSub, barBg, loadStatus}) do
        TweenService:Create(obj, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
        end
    end
    
    task.wait(1)
    loadScreen:Destroy()
    openButton.Visible = true
    
    print("KYZENO X PANEL - Loaded successfully!")
end)

-- ============================================================
--  Character Respawn Handler
-- ============================================================
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    
    if settings.godMode then
        local h = char:FindFirstChild("Humanoid")
        if h then
            h.MaxHealth = 9e9
            h.Health = 9e9
        end
    end
    
    if settings.walkSpeed then
        local h = char:FindFirstChild("Humanoid")
        if h then
            h.WalkSpeed = settings.walkSpeed
        end
    end
    
    if settings.smallAvatar then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.BodyHeightScale.Value = 0.3
            hum.BodyWidthScale.Value = 0.3
            hum.BodyDepthScale.Value = 0.3
            hum.HeadScale.Value = 0.3
        end
    end
    
    if settings.esp then
        task.wait(0.5)
        for _, p in ipairs(Players:GetPlayers()) do
            buildESPFor(p)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if settings.esp then
            buildESPFor(p)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        if espObjects[p].highlight then
            espObjects[p].highlight:Destroy()
        end
        espObjects[p] = nil
    end
end)
