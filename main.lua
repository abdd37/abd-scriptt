local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local MenuOpen = true
local AimTargetPart = "Head" 
local FpsBoostEnabled = false

local Theme = {
    BG = Color3.fromRGB(10, 25, 15),          
    Sidebar = Color3.fromRGB(14, 35, 20),     
    Accent = Color3.fromRGB(220, 30, 40),     
    AccentGreen = Color3.fromRGB(20, 180, 70),
    Text = Color3.fromRGB(255, 255, 255),     
    TextDim = Color3.fromRGB(160, 180, 160),  
    Element = Color3.fromRGB(20, 45, 28),     
}

-- ================= 1. ECRAN DE CHARGEMENT =================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = CoreGui

local Bg = Instance.new("Frame")
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.BackgroundColor3 = Color3.fromRGB(5, 15, 8)
Bg.Parent = LoadingGui

local LogoTitle = Instance.new("TextLabel")
LogoTitle.Size = UDim2.new(1, 0, 0, 60)
LogoTitle.Position = UDim2.new(0, 0, 0.4, 0)
LogoTitle.BackgroundTransparency = 1
LogoTitle.Text = "🎄 ABD SCRIPT 🎄"
LogoTitle.TextColor3 = Theme.Text
LogoTitle.Font = Enum.Font.GothamBlack
LogoTitle.TextSize = 42
LogoTitle.Parent = Bg

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 400, 0, 8)
BarBg.Position = UDim2.new(0.5, -200, 0.6, 50)
BarBg.BackgroundColor3 = Color3.fromRGB(15, 35, 22)
BarBg.Parent = Bg
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Theme.Accent
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

for i = 1, 100 do
    task.wait(0.02)
    TweenService:Create(BarFill, TweenInfo.new(0.1), {Size = UDim2.new(i / 100, 0, 1, 0)}):Play()
end
LoadingGui:Destroy()

-- ================= 2. MENU =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChristmasMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ReopenBtn = Instance.new("TextButton")
ReopenBtn.Size = UDim2.new(0, 80, 0, 35)
ReopenBtn.Position = UDim2.new(0, 20, 0, 20)
ReopenBtn.BackgroundColor3 = Theme.Accent
ReopenBtn.Text = "ABD"
ReopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ReopenBtn.Font = Enum.Font.GothamBlack
ReopenBtn.TextSize = 14
ReopenBtn.Visible = false
ReopenBtn.Parent = ScreenGui
Instance.new("UICorner", ReopenBtn).CornerRadius = UDim.new(0, 6)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Theme.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.AccentGreen
MainStroke.Thickness = 2
MainStroke.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Theme.Accent
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 100, 0, 30)
HideBtn.Position = UDim2.new(1, -150, 0, 10)
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
HideBtn.Text = "Cacher"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Parent = Main
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 6)

local espObjects = {}
local EspEnabled = false

local function DisableAllCheats()
    MenuOpen = false
    EspEnabled = false
    FpsBoostEnabled = false
    for _, hl in pairs(espObjects) do if hl then hl:Destroy() end end
    espObjects = {}
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
    end
    Camera.FieldOfView = 70
    pcall(function() setfpscap(60) end)
end

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    DisableAllCheats()
end)

HideBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    ReopenBtn.Visible = true
end)

ReopenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    ReopenBtn.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarTitle = Instance.new("TextLabel")
SidebarTitle.Size = UDim2.new(1, -20, 0, 40)
SidebarTitle.Position = UDim2.new(0, 15, 0, 15)
SidebarTitle.BackgroundTransparency = 1
SidebarTitle.Text = "🎅 ABD MENU"
SidebarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SidebarTitle.Font = Enum.Font.GothamBlack
SidebarTitle.TextSize = 18
SidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
SidebarTitle.Parent = Sidebar

local SidebarSub = Instance.new("TextLabel")
SidebarSub.Size = UDim2.new(1, -20, 0, 15)
SidebarSub.Position = UDim2.new(0, 15, 0, 40)
SidebarSub.BackgroundTransparency = 1
SidebarSub.Text = "EMERGENCY PORT MARIE"
SidebarSub.TextColor3 = Theme.Accent
SidebarSub.Font = Enum.Font.GothamBold
SidebarSub.TextSize = 10
SidebarSub.TextXAlignment = Enum.TextXAlignment.Left
SidebarSub.Parent = Sidebar

local function CreateNavBtn(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Theme.Sidebar
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Theme.AccentGreen then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Sidebar}):Play()
        end
    end)
    return btn
end

local TabMain = CreateNavBtn("Main / Cheats", 80)
local TabAimbot = CreateNavBtn("Aimbot", 125)

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -160, 1, -80)
Pages.Position = UDim2.new(0, 160, 0, 60)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local function CreateToggle(parent, text, yPos, isLocked)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Theme.Element
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    if isLocked then
        local lockBg = Instance.new("Frame")
        lockBg.Size = UDim2.new(0, 75, 0, 25)
        lockBg.Position = UDim2.new(1, -85, 0.5, -12)
        lockBg.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
        lockBg.Parent = frame
        Instance.new("UICorner", lockBg).CornerRadius = UDim.new(0, 4)
        local lockTxt = Instance.new("TextLabel")
        lockTxt.Size = UDim2.new(1, 0, 1, 0)
        lockTxt.BackgroundTransparency = 1
        lockTxt.Text = "🔒 LOCKED"
        lockTxt.TextColor3 = Theme.Accent
        lockTxt.Font = Enum.Font.GothamBold
        lockTxt.TextSize = 11
        lockTxt.Parent = lockBg
        return frame, function() return false end
    end

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -10)
    toggleBg.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = UDim2.new(0, 2, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.Parent = toggleBg
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        if not MenuOpen then return end
        isOn = not isOn
        if isOn then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 60, 40)}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
    end)
    
    return frame, function() return isOn end
end

local function CreateSlider(parent, text, min, max, default, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Theme.Element
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -30, 0, 10)
    slider.Position = UDim2.new(0, 15, 0, 32)
    slider.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
    slider.Text = ""
    slider.Parent = frame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.AccentGreen
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(1, -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = fill
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local value = default
    
    local function update(input)
        local relX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
    end
    
    slider.InputBegan:Connect(function(input)
        if not MenuOpen then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    
    return function() return value end
end

local PageMain = Instance.new("ScrollingFrame")
PageMain.Size = UDim2.new(1, 0, 1, 0)
PageMain.BackgroundTransparency = 1
PageMain.ScrollBarThickness = 2
PageMain.ScrollBarImageColor3 = Theme.AccentGreen
PageMain.CanvasSize = UDim2.new(0, 0, 0, 500)
PageMain.Visible = true
PageMain.Parent = Pages

local EspFrame, GetEsp = CreateToggle(PageMain, "ESP (Voir les joueurs)", 10, false)

EspFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    task.wait(0.1)
    EspEnabled = GetEsp()
end)

local _, GetSpeed = CreateToggle(PageMain, "Speed Hack", 65, false)
local _, GetFly = CreateToggle(PageMain, "Fly", 120, false)
local _, GetAutoTaze = CreateToggle(PageMain, "Auto-Tazer", 175, false)
local _, GetTpPlayer = CreateToggle(PageMain, "Teleport to Player", 230, false)
local _, GetRapidArrest = CreateToggle(PageMain, "Rapid Arrest (Menottes)", 285, false)
local BoostFrame, GetBoost = CreateToggle(PageMain, "FPS Boost (Anti-Lag)", 340, false)

BoostFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    task.wait(0.1)
    FpsBoostEnabled = GetBoost()
    
    if FpsBoostEnabled then
        pcall(function() setfpscap(144) end)
        Lighting.GlobalShadows = false
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end
    else
        pcall(function() setfpscap(60) end)
        Lighting.GlobalShadows = true
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = true
            end
        end
    end
end)

local PageAimbot = Instance.new("ScrollingFrame")
PageAimbot.Size = UDim2.new(1, 0, 1, 0)
PageAimbot.BackgroundTransparency = 1
PageAimbot.ScrollBarThickness = 2
PageAimbot.ScrollBarImageColor3 = Theme.AccentGreen
PageAimbot.CanvasSize = UDim2.new(0, 0, 0, 350)
PageAimbot.Visible = false
PageAimbot.Parent = Pages

local _, GetAim = CreateToggle(PageAimbot, "Activer l'Aimbot (Clic Droit)", 10, false)
local GetSmooth = CreateSlider(PageAimbot, "Smooth (Vitesse)", 1, 10, 5, 65)
local GetFov = CreateSlider(PageAimbot, "FOV (Champ de vision)", 50, 500, 150, 130)

local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(1, 0, 0, 45)
TargetBtn.Position = UDim2.new(0, 0, 0, 185)
TargetBtn.BackgroundColor3 = Theme.Element
TargetBtn.Text = "  Cible : Tête"
TargetBtn.TextColor3 = Theme.Text
TargetBtn.Font = Enum.Font.GothamMedium
TargetBtn.TextSize = 14
TargetBtn.TextXAlignment = Enum.TextXAlignment.Left
TargetBtn.Parent = PageAimbot
Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 6)

TargetBtn.MouseButton1Click:Connect(function()
    if AimTargetPart == "Head" then
        AimTargetPart = "Torso"
        TargetBtn.Text = "  Cible : Torse"
    else
        AimTargetPart = "Head"
        TargetBtn.Text = "  Cible : Tête"
    end
end)

local function UpdateTabs(activeTab)
    for _, tab in pairs({TabMain, TabAimbot}) do
        TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Sidebar, TextColor3 = Theme.TextDim}):Play()
    end
    TweenService:Create(activeTab, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.AccentGreen}):Play()
end

TabMain.MouseButton1Click:Connect(function()
    if not MenuOpen then return end
    PageMain.Visible = true
    PageAimbot.Visible = false
    UpdateTabs(TabMain)
end)

TabAimbot.MouseButton1Click:Connect(function()
    if not MenuOpen then return end
    PageMain.Visible = false
    PageAimbot.Visible = true
    UpdateTabs(TabAimbot)
end)

UpdateTabs(TabMain)

-- ================= 3. LOGIQUE DES CHEATS =================
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hl = Instance.new("Highlight", char)
    hl.FillColor = Theme.Accent
    hl.OutlineColor = Theme.AccentGreen
    espObjects[player] = hl
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if EspEnabled then
            createESP(player)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if not MenuOpen then return end

    local char = LocalPlayer.Character
    
    if GetEsp() then
        EspEnabled = true
        for _, p in pairs(Players:GetPlayers()) do
            if not espObjects[p] then createESP(p) end
        end
    else
        EspEnabled = false
        for _, hl in pairs(espObjects) do if hl then hl:Destroy() end end
        espObjects = {}
    end

    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = GetSpeed() and 60 or 16
        end
    end

    if GetFly() and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            hrp.Velocity = moveDir * 50
        end
    end

    if GetTpPlayer() and char then
        local myHrp = char:FindFirstChild("HumanoidRootPart")
        if myHrp then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp and (targetHrp.Position - myHrp.Position).Magnitude < 50 then
                        myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
                        break
                    end
                end
            end
        end
    end

    if GetAim() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            local isWeapon = false
            
            if tool then
                local tName = string.lower(tool.Name)
                if not (string.find(tName, "tool") or string.find(tName, "med") or string.find(tName, "kit") or string.find(tName, "radio") or string.find(tName, "flashlight") or string.find(tName, "torch") or string.find(tName, "cuff")) then
                    isWeapon = true
                end
            end

            if isWeapon then
                local closest, shortestDist = nil, GetFov()
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local targetPart = p.Character:FindFirstChild(AimTargetPart) or p.Character:FindFirstChild("UpperTorso")
                        if targetPart then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closest = targetPart
                                end
                            end
                        end
                    end
                end
                
                if closest and mousemoverel then
                    local screenPos = Camera:WorldToViewportPoint(closest.Position)
                    mousemoverel((screenPos.X - center.X) / GetSmooth(), (screenPos.Y - center.Y) / GetSmooth())
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if MenuOpen and GetAutoTaze() then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and string.find(string.lower(tool.Name), "taze") then
                    local closestPlayer, shortestDist = nil, 15
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            local myHrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp and myHrp then
                                local dist = (hrp.Position - myHrp.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                    
                    if closestPlayer then
                        local targetHrp = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHrp.Position)
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do 
        if MenuOpen and GetRapidArrest() then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local tName = string.lower(tool.Name)
                    if string.find(tName, "cuff") or string.find(tName, "arrest") or string.find(tName, "menotte") then
                        
                        local closestPlayer, shortestDist = nil, 6 
                        
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                                local myHrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp and myHrp then
                                    local dist = (hrp.Position - myHrp.Position).Magnitude
                                    if dist < shortestDist then
                                        shortestDist = dist
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                        
                        if closestPlayer then
                            local targetHrp = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if targetHrp then
                                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHrp.Position)
                                local vMouse = game:GetService("VirtualUser")
                                vMouse:Button1Down(Vector2.new(0,0))
                                vMouse:Button1Up(Vector2.new(0,0))
                                pcall(function() tool:Activate() end)
                            end
                        end
                    end
                end
            end
        end
    end
end)
