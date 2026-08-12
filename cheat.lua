--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║   Тренировочная система для ролевых игр (обучение)         ║
    ║   Версия 5.0 (финальная, исправленная)                    ║
    ╚══════════════════════════════════════════════════════════════╝
]]

-- // СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // ИГРОК
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // НАСТРОЙКИ
local Settings = {
    Mode = "Civilian",
    ShowHints = false,
    ShowNames = true,
    ShowHealth = true,
    ShowLines = true,
    Assist = false,
    AssistPart = "Head",
    Smoothness = 0.3,
    Fly = false,
    FlySpeed = 50,
    Noclip = false
}

-- // ГРАФИЧЕСКИЙ ИНТЕРФЕЙС
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainingSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
Title.Text = "🎓 Тренировочный центр"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local function CreateButton(Text, Y, Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.85, 0, 0, 32)
    Button.Position = UDim2.new(0.075, 0, 0, Y)
    Button.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 13
    Button.Parent = MainFrame
    Button.MouseButton1Click:Connect(Callback)
    return Button
end

CreateButton("📦 Гражданский (доставка)", 45, function() Settings.Mode = "Civilian" end)
CreateButton("🛂 Пограничник (проверка)", 82, function() Settings.Mode = "BorderPatrol" end)
CreateButton("🚔 Полиция (патруль)", 119, function() Settings.Mode = "Police" end)
CreateButton("👁️ Подсказки (вкл/выкл)", 160, function() Settings.ShowHints = not Settings.ShowHints end)
CreateButton("🎯 Помощь прицеливанию", 197, function() Settings.Assist = not Settings.Assist end)
CreateButton("🎯 Цель: голова", 234, function() Settings.AssistPart = "Head" end)
CreateButton("🎯 Цель: корпус", 271, function() Settings.AssistPart = "Torso" end)
CreateButton("🎯 Цель: ноги", 308, function() Settings.AssistPart = "HumanoidRootPart" end)
CreateButton("✈️ Полёт (F)", 349, function() Settings.Fly = not Settings.Fly end)
CreateButton("👻 Проход сквозь стены (G)", 386, function() Settings.Noclip = not Settings.Noclip end)
CreateButton("⚡ Скорость 50", 423, function() Settings.FlySpeed = 50 end)
CreateButton("⚡ Скорость 100", 455, function() Settings.FlySpeed = 100 end)

-- // СИСТЕМА ВИЗУАЛЬНЫХ ПОДСКАЗОК
local HintLines = {}
local HintLabels = {}

local function CreateHint(TargetPlayer)
    if TargetPlayer == LocalPlayer then return end
    if HintLines[TargetPlayer] then return end
    
    local Line = Drawing.new("Line")
    Line.Thickness = 1.5
    Line.Color = Color3.fromRGB(0, 200, 255)
    Line.Visible = false
    
    local Label = Drawing.new("Text")
    Label.Size = 14
    Label.Center = true
    Label.Outline = true
    Label.OutlineColor = Color3.fromRGB(0, 0, 0)
    Label.Color = Color3.fromRGB(255, 255, 255)
    Label.Visible = false
    
    HintLines[TargetPlayer] = Line
    HintLabels[TargetPlayer] = Label
end

Players.PlayerRemoving:Connect(function(TargetPlayer)
    if HintLines[TargetPlayer] then
        HintLines[TargetPlayer]:Remove()
        HintLines[TargetPlayer] = nil
    end
    if HintLabels[TargetPlayer] then
        HintLabels[TargetPlayer]:Remove()
        HintLabels[TargetPlayer] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.ShowHints then
        for _, Line in pairs(HintLines) do Line.Visible = false end
        for _, Label in pairs(HintLabels) do Label.Visible = false end
        return
    end
    
    for _, TargetPlayer in ipairs(Players:GetPlayers()) do
        if TargetPlayer ~= LocalPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
            if not HintLines[TargetPlayer] then CreateHint(TargetPlayer) end
            
            local Head = TargetPlayer.Character.Head
            local Pos, OnScreen = Camera:WorldToScreenPoint(Head.Position)
            
            if OnScreen then
                local Line = HintLines[TargetPlayer]
                local Label = HintLabels[TargetPlayer]
                
                local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                Line.From = Center
                Line.To = Vector2.new(Pos.X, Pos.Y)
                Line.Visible = Settings.ShowLines
                
                local Humanoid = TargetPlayer.Character:FindFirstChild("Humanoid")
                local Health = Humanoid and math.floor(Humanoid.Health) or 100
                local Text = ""
                if Settings.ShowNames then Text = TargetPlayer.Name end
                if Settings.ShowHealth then
                    if Text ~= "" then Text = Text .. " | " end
                    Text = Text .. Health .. " HP"
                end
                Label.Text = Text
                Label.Position = Vector2.new(Pos.X, Pos.Y - 35)
                Label.Visible = Settings.ShowNames or Settings.ShowHealth
                
                if Health > 60 then
                    Label.Color = Color3.fromRGB(0, 255, 100)
                elseif Health > 30 then
                    Label.Color = Color3.fromRGB(255, 255, 0)
                else
                    Label.Color = Color3.fromRGB(255, 0, 0)
                end
            else
                if HintLines[TargetPlayer] then HintLines[TargetPlayer].Visible = false end
                if HintLabels[TargetPlayer] then HintLabels[TargetPlayer].Visible = false end
            end
        end
    end
end)

-- // СИСТЕМА ПРИЦЕЛИВАНИЯ
local AssistActive = false

local function GetAssistPart(Character)
    if Settings.AssistPart == "Head" then
        return Character:FindFirstChild("Head")
    elseif Settings.AssistPart == "Torso" then
        return Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
    else
        return Character:FindFirstChild("HumanoidRootPart")
    end
end

local function GetClosestTarget()
    local Closest = nil
    local MinDist = 9999
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, TargetPlayer in ipairs(Players:GetPlayers()) do
        if TargetPlayer ~= LocalPlayer and TargetPlayer.Character then
            local Part = GetAssistPart(TargetPlayer.Character)
            if Part then
                local Pos, OnScreen = Camera:WorldToScreenPoint(Part.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - Center).Magnitude
                    if Dist < MinDist then
                        MinDist = Dist
                        Closest = TargetPlayer
                    end
                end
            end
        end
    end
    return Closest
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Settings.Assist and Input.UserInputType == Enum.UserInputType.MouseButton2 then
        AssistActive = true
    end
end)

UserInputService.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        AssistActive = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.Assist or not AssistActive then return end
    
    local Target = GetClosestTarget()
    if Target and Target.Character then
        local Part = GetAssistPart(Target.Character)
        if Part then
            local TargetPos = Part.Position
            local CamPos = Camera.CFrame.Position
            local Direction = (TargetPos - CamPos).unit
            local NewCF = CFrame.lookAt(CamPos, CamPos + Direction)
            Camera.CFrame = Camera.CFrame:Lerp(NewCF, Settings.Smoothness)
        end
    end
end)

-- // ПОЛЁТ И НОКЛИП
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.F then
        Settings.Fly = not Settings.Fly
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.PlatformStand = Settings.Fly
        end
    end
    if Input.KeyCode == Enum.KeyCode.G then
        Settings.Noclip = not Settings.Noclip
    end
end)

local function SetNoclip(Character, Enabled)
    for _, Object in ipairs(Character:GetDescendants()) do
        if Object:IsA("BasePart") then
            Object.CanCollide = not Enabled
        end
    end
end

RunService.RenderStepped:Connect(function()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    if Settings.Fly then
        local Move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Move = Move + Camera.CFrame.LookVector * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Move = Move - Camera.CFrame.LookVector * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Move = Move - Camera.CFrame.RightVector * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Move = Move + Camera.CFrame.RightVector * Settings.FlySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Move = Move + Vector3.new(0, Settings.FlySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then Move = Move - Vector3.new(0, Settings.FlySpeed, 0) end
        Root.AssemblyLinearVelocity = Move
    end
    
    SetNoclip(Character, Settings.Noclip)
end)

-- // АВТОМАТИЧЕСКИЕ ДЕЙСТВИЯ
local function FindObject(NamePattern)
    for _, Object in pairs(Workspace:GetDescendants()) do
        if Object:IsA("Part") and Object.Name:lower():find(NamePattern) then
            return Object
        end
    end
    return nil
end

local function CivilianTask()
    while Settings.Mode == "Civilian" do
        local Character = LocalPlayer.Character
        if not Character then break end
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not Humanoid then break end
        
        local Target = FindObject("delivery") or FindObject("cargo")
        if Target then
            Humanoid:MoveTo(Target.Position)
            task.wait(2)
            local Click = Target:FindFirstChild("ClickDetector")
            if Click then fireclickdetector(Click) end
            local Prompt = Target:FindFirstChild("ProximityPrompt")
            if Prompt then Prompt:InputHoldBegin() task.wait(0.5) Prompt:InputHoldEnd() end
            task.wait(4)
        else
            local Spawns = Workspace:FindFirstChild("Spawns")
            if Spawns then
                local Parts = Spawns:GetChildren()
                if #Parts > 0 then Humanoid:MoveTo(Parts[math.random(#Parts)].Position) end
            end
        end
        task.wait(1)
    end
end

local function BorderPatrolTask()
    while Settings.Mode == "BorderPatrol" do
        local Character = LocalPlayer.Character
        if not Character then break end
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not Humanoid then break end
        
        local Target = nil
        local MinDist = math.huge
        for _, TargetPlayer in ipairs(Players:GetPlayers()) do
            if TargetPlayer ~= LocalPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
                local Dist = (Character.Head.Position - TargetPlayer.Character.Head.Position).Magnitude
                if Dist < MinDist then MinDist = Dist Target = TargetPlayer end
            end
        end
        
        if Target then
            Humanoid:MoveTo(Target.Character.Head.Position)
            task.wait(2)
            local CheckRemote = ReplicatedStorage:FindFirstChild("CheckPlayer")
            if CheckRemote then CheckRemote:FireServer(Target) end
            task.wait(6)
        else
            local Border = Workspace:FindFirstChild("BorderPoints")
            if Border then
                local Points = Border:GetChildren()
                if #Points > 0 then Humanoid:MoveTo(Points[math.random(#Points)].Position) end
            end
        end
        task.wait(1)
    end
end

local function PoliceTask()
    while Settings.Mode == "Police" do
        local Character = LocalPlayer.Character
        if not Character then break end
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not Humanoid then break end
        
        local Target = nil
        for _, TargetPlayer in ipairs(Players:GetPlayers()) do
            if TargetPlayer ~= LocalPlayer and TargetPlayer.Character then
                local Wanted = TargetPlayer:FindFirstChild("Wanted")
                if Wanted and Wanted.Value == true then Target = TargetPlayer break end
            end
        end
        
        if Target then
            Humanoid:MoveTo(Target.Character.Head.Position)
            task.wait(2)
            local ArrestRemote = ReplicatedStorage:FindFirstChild("ArrestPlayer")
            if ArrestRemote then ArrestRemote:FireServer(Target) end
            task.wait(4)
            local FineRemote = ReplicatedStorage:FindFirstChild("FinePlayer")
            if FineRemote then FineRemote:FireServer(Target, 500) end
            task.wait(3)
        else
            local City = Workspace:FindFirstChild("CityPoints")
            if City then
                local Points = City:GetChildren()
                if #Points > 0 then Humanoid:MoveTo(Points[math.random(#Points)].Position) end
            end
        end
        task.wait(1)
    end
end

spawn(function()
    while true do
        if Settings.Mode == "Civilian" then
            CivilianTask()
        elseif Settings.Mode == "BorderPatrol" then
            BorderPatrolTask()
        elseif Settings.Mode == "Police" then
            PoliceTask()
        end
        task.wait(0.5)
    end
end)

print("🎓 Тренировочная система загружена. Используйте меню для настройки.")
print("📌 F - полёт, G - проход сквозь стены, ПКМ - прицеливание")