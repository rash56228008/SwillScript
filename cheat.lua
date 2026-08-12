--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║   SWILL TRAINING v7.0 (FULL)                              ║
    ║   Меню от ChatGPT + ESP + Aimbot + Fly + Noclip + Фарм   ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // НАСТРОЙКИ
local Settings = {
    ESP = false,
    Aimbot = false,
    Fly = false,
    Noclip = false,
    FlySpeed = 50,
    ESPLineThickness = 1.5,
    ESPTextSize = 14,
    ESPColor = "Blue",
    AimPart = "Head",
    Profession = "Civilian"
}

-- // ================================================
-- // МЕНЮ (ПОЛНОСТЬЮ ОТ CHATGPT)
-- // ================================================

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwillTrainingV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 390, 0, 650)
Main.Position = UDim2.new(0.5, -195, 0.5, -325)
Main.BackgroundColor3 = Color3.fromRGB(17, 20, 29)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 75, 100)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(27, 32, 46)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 15)
HeaderFix.Position = UDim2.new(0, 0, 1, -15)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -30, 0, 32)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "SWILL TRAINING v7.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -30, 0, 20)
Subtitle.Position = UDim2.new(0, 15, 0, 40)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Training interface • Settings"
Subtitle.TextColor3 = Color3.fromRGB(145, 155, 175)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -84)
Content.Position = UDim2.new(0, 12, 0, 78)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(80, 95, 125)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 4)
ContentPadding.PaddingBottom = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 5)
ContentPadding.PaddingRight = UDim.new(0, 5)
ContentPadding.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

-- // HELPERS
local function CreateSection(Text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 28)
    Section.BackgroundTransparency = 1
    Section.Text = Text
    Section.TextColor3 = Color3.fromRGB(90, 180, 255)
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 13
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = Content
    return Section
end

local function CreateButton(Text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(34, 40, 55)
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(235, 238, 245)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(65, 75, 95)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.35
    Stroke.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(48, 57, 76)
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(34, 40, 55)
    end)

    return Button
end

local function CreateToggle(Name, InitialValue)
    local Button = CreateButton("")
    local Value = InitialValue

    local function Update()
        if Value then
            Button.Text = Name .. "    [ ON ]"
            Button.BackgroundColor3 = Color3.fromRGB(35, 92, 70)
        else
            Button.Text = Name .. "    [ OFF ]"
            Button.BackgroundColor3 = Color3.fromRGB(34, 40, 55)
        end
    end

    Button.MouseButton1Click:Connect(function()
        Value = not Value
        Settings[Name] = Value
        Update()
    end)

    Update()
    return Button
end

local function CreateTextBox(LabelText, DefaultValue)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 52)
    Container.BackgroundColor3 = Color3.fromRGB(28, 34, 47)
    Container.BorderSizePixel = 0
    Container.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.55, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = LabelText
    Label.TextColor3 = Color3.fromRGB(220, 225, 235)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 105, 0, 32)
    Box.Position = UDim2.new(1, -117, 0.5, -16)
    Box.BackgroundColor3 = Color3.fromRGB(18, 22, 31)
    Box.BorderSizePixel = 0
    Box.Text = tostring(DefaultValue)
    Box.PlaceholderText = tostring(DefaultValue)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 13
    Box.ClearTextOnFocus = false
    Box.Parent = Container

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = Box

    return Box
end

local function CreateOptionButton(Text, GroupName, Value)
    local Button = CreateButton(Text)
    Button.MouseButton1Click:Connect(function()
        Settings[GroupName] = Value
    end)
    return Button
end

-- // СОЗДАНИЕ ЭЛЕМЕНТОВ МЕНЮ
CreateSection("VISUAL ASSISTANT")
CreateToggle("ESP", false)
CreateToggle("Aimbot", false)

CreateTextBox("ESP line thickness", 1.5)
CreateTextBox("ESP text size", 14)

CreateSection("ESP COLOR")
CreateOptionButton("🔵  Blue", "ESPColor", "Blue")
CreateOptionButton("🔴  Red", "ESPColor", "Red")
CreateOptionButton("🟢  Green", "ESPColor", "Green")

CreateSection("MOVEMENT")
CreateToggle("Fly", false)
CreateToggle("Noclip", false)
CreateTextBox("Fly speed", 50)

CreateSection("AIM TARGET")
CreateOptionButton("Head", "AimPart", "Head")
CreateOptionButton("Torso", "AimPart", "Torso")
CreateOptionButton("Legs", "AimPart", "Legs")

CreateSection("PROFESSION")
CreateOptionButton("👤  Civilian", "Profession", "Civilian")
CreateOptionButton("🛡️  Border Patrol", "Profession", "BorderPatrol")
CreateOptionButton("👮  Police", "Profession", "Police")

CreateSection("CURRENT SETTINGS")
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 45)
Status.BackgroundColor3 = Color3.fromRGB(24, 29, 40)
Status.BorderSizePixel = 0
Status.TextColor3 = Color3.fromRGB(150, 160, 180)
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextWrapped = true
Status.Text = "Interface loaded"
Status.Parent = Content

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = Status

-- // DRAG SYSTEM
local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

Header.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

-- // ================================================
-- // ESP
-- // ================================================

local ESPObjects = {}

local function GetESPColor()
    if Settings.ESPColor == "Blue" then return Color3.fromRGB(0, 200, 255)
    elseif Settings.ESPColor == "Red" then return Color3.fromRGB(255, 0, 0)
    elseif Settings.ESPColor == "Green" then return Color3.fromRGB(0, 255, 0)
    else return Color3.fromRGB(0, 200, 255) end
end

local function UpdateESP()
    if not Settings.ESP then
        for _, data in pairs(ESPObjects) do
            data.line.Visible = false
            data.label.Visible = false
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
            
            if onScreen then
                if not ESPObjects[player] then
                    local line = Drawing.new("Line")
                    line.Thickness = Settings.ESPLineThickness
                    line.Color = GetESPColor()
                    line.Visible = true
                    
                    local label = Drawing.new("Text")
                    label.Size = Settings.ESPTextSize
                    label.Center = true
                    label.Outline = true
                    label.OutlineColor = Color3.fromRGB(0, 0, 0)
                    label.Color = Color3.fromRGB(255, 255, 255)
                    label.Visible = true
                    
                    ESPObjects[player] = {line = line, label = label}
                end
                
                local data = ESPObjects[player]
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                data.line.From = center
                data.line.To = Vector2.new(pos.X, pos.Y)
                data.line.Thickness = Settings.ESPLineThickness
                data.line.Color = GetESPColor()
                data.line.Visible = true
                
                local hum = player.Character:FindFirstChild("Humanoid")
                local health = hum and math.floor(hum.Health) or 100
                data.label.Text = player.Name .. " | " .. health .. " HP"
                data.label.Position = Vector2.new(pos.X, pos.Y - 35)
                data.label.Size = Settings.ESPTextSize
                data.label.Visible = true
            else
                if ESPObjects[player] then
                    ESPObjects[player].line.Visible = false
                    ESPObjects[player].label.Visible = false
                end
            end
        end
    end
end

-- // ================================================
-- // AIMBOT
-- // ================================================

local aimActive = false

local function GetAimPart(char)
    if Settings.AimPart == "Head" then return char:FindFirstChild("Head") end
    if Settings.AimPart == "Torso" then return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") end
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetClosestTarget()
    local closest, minDist = nil, 200
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local part = GetAimPart(plr.Character)
            if part then
                local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(input)
    if Settings.Aimbot and input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimActive = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimActive = false
    end
end)

-- // ================================================
-- // FLY + NOCLIP
-- // ================================================

local function SetNoclip(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        Settings.Fly = not Settings.Fly
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = Settings.Fly
        end
    end
    if input.KeyCode == Enum.KeyCode.G then
        Settings.Noclip = not Settings.Noclip
        SetNoclip(Settings.Noclip)
    end
end)

-- // ================================================
-- // ОСНОВНОЙ ЦИКЛ
-- // ================================================

local lastUpdate = 0
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate > 0.05 then
        lastUpdate = now
        
        -- ESP
        UpdateESP()
        
        -- Aimbot
        if Settings.Aimbot and aimActive then
            local target = GetClosestTarget()
            if target and target.Character then
                local part = GetAimPart(target.Character)
                if part then
                    local targetPos = part.Position
                    local camPos = Camera.CFrame.Position
                    local dir = (targetPos - camPos).unit
                    local newCF = CFrame.lookAt(camPos, camPos + dir)
                    Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.25)
                end
            end
        end
        
        -- Fly
        if Settings.Fly then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local move = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * Settings.FlySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * Settings.FlySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector * Settings.FlySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector * Settings.FlySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, Settings.FlySpeed, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, Settings.FlySpeed, 0) end
                root.AssemblyLinearVelocity = move
            end
        end
        
        -- Noclip
        if Settings.Noclip then
            SetNoclip(true)
        end
    end
end)

-- // ================================================
-- // АВТОФАРМ
-- // ================================================

local function FindObject(NamePattern)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find(NamePattern) then
            return obj
        end
    end
    return nil
end

local function CivilianFarm()
    while Settings.Profession == "Civilian" do
        local char = LocalPlayer.Character
        if not char then break end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then break end
        
        local target = FindObject("delivery") or FindObject("cargo")
        if target then
            hum:MoveTo(target.Position)
            task.wait(2)
            local click = target:FindFirstChild("ClickDetector")
            if click then fireclickdetector(click) end
            local prompt = target:FindFirstChild("ProximityPrompt")
            if prompt then prompt:InputHoldBegin() task.wait(0.5) prompt:InputHoldEnd() end
            task.wait(4)
        else
            local spawns = Workspace:FindFirstChild("Spawns")
            if spawns then
                local parts = spawns:GetChildren()
                if #parts > 0 then hum:MoveTo(parts[math.random(#parts)].Position) end
            end
        end
        task.wait(1)
    end
end

local function BorderPatrolFarm()
    while Settings.Profession == "BorderPatrol" do
        local char = LocalPlayer.Character
        if not char then break end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then break end
        
        local target = nil
        local minDist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local dist = (char.Head.Position - plr.Character.Head.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = plr
                end
            end
        end
        
        if target then
            hum:MoveTo(target.Character.Head.Position)
            task.wait(2)
            local check = ReplicatedStorage:FindFirstChild("CheckPlayer")
            if check then check:FireServer(target) end
            task.wait(6)
        else
            local border = Workspace:FindFirstChild("BorderPoints")
            if border then
                local pts = border:GetChildren()
                if #pts > 0 then hum:MoveTo(pts[math.random(#pts)].Position) end
            end
        end
        task.wait(1)
    end
end

local function PoliceFarm()
    while Settings.Profession == "Police" do
        local char = LocalPlayer.Character
        if not char then break end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then break end
        
        local target = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local wanted = plr:FindFirstChild("Wanted")
                if wanted and wanted.Value == true then
                    target = plr
                    break
                end
            end
        end
        
        if target then
            hum:MoveTo(target.Character.Head.Position)
            task.wait(2)
            local arrest = ReplicatedStorage:FindFirstChild("ArrestPlayer")
            if arrest then arrest:FireServer(target) end
            task.wait(4)
            local fine = ReplicatedStorage:FindFirstChild("FinePlayer")
            if fine then fine:FireServer(target, 500) end
            task.wait(3)
        else
            local city = Workspace:FindFirstChild("CityPoints")
            if city then
                local pts = city:GetChildren()
                if #pts > 0 then hum:MoveTo(pts[math.random(#pts)].Position) end
            end
        end
        task.wait(1)
    end
end

spawn(function()
    while true do
        if Settings.Profession == "Civilian" then
            CivilianFarm()
        elseif Settings.Profession == "BorderPatrol" then
            BorderPatrolFarm()
        elseif Settings.Profession == "Police" then
            PoliceFarm()
        end
        task.wait(0.5)
    end
end)

print("🎓 SWILL TRAINING v7.0 (FULL) загружена!")
print("📌 F - полёт, G - ноклип, ПКМ - аимбот")
