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

-- // НАСТРОЙКИ (связаны с меню)
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
-- // МЕНЮ ОТ CHATGPT (вставлено целиком)
-- // ================================================

-- (здесь ВЕСЬ код меню, который дал ChatGPT, включая CreateToggle, CreateTextBox и т.д.)
-- (я не буду повторять его полностью, чтобы не тратить место, но ты вставляешь его сюда)

-- // ================================================
-- // ПРИВЯЗКА КНОПОК МЕНЮ К НАСТРОЙКАМ
-- // ================================================

-- ЭТОТ БЛОК ТЫ ДОБАВЛЯЕШЬ В КОНЦЕ МЕНЮ (перед print)

-- Привязка переключателей
local function FindToggle(name)
    for _, btn in pairs(Content:GetDescendants()) do
        if btn:IsA("TextButton") and btn.Text:find(name) then
            return btn
        end
    end
end

-- Привязка полей ввода
local function FindTextBox(name)
    for _, box in pairs(Content:GetDescendants()) do
        if box:IsA("TextBox") and box.Parent:FindFirstChild("TextLabel") and box.Parent.TextLabel.Text == name then
            return box
        end
    end
end

-- ESP
local espToggle = FindToggle("ESP")
if espToggle then
    espToggle.MouseButton1Click:Connect(function()
        Settings.ESP = not Settings.ESP
    end)
end

-- Aimbot
local aimToggle = FindToggle("Aimbot")
if aimToggle then
    aimToggle.MouseButton1Click:Connect(function()
        Settings.Aimbot = not Settings.Aimbot
    end)
end

-- Fly
local flyToggle = FindToggle("Fly")
if flyToggle then
    flyToggle.MouseButton1Click:Connect(function()
        Settings.Fly = not Settings.Fly
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = Settings.Fly
        end
    end)
end

-- Noclip
local noclipToggle = FindToggle("Noclip")
if noclipToggle then
    noclipToggle.MouseButton1Click:Connect(function()
        Settings.Noclip = not Settings.Noclip
    end)
end

-- Поля ввода
local speedBox = FindTextBox("Fly speed")
if speedBox then
    speedBox.FocusLost:Connect(function()
        local val = tonumber(speedBox.Text)
        if val then Settings.FlySpeed = val end
    end)
end

local thicknessBox = FindTextBox("ESP line thickness")
if thicknessBox then
    thicknessBox.FocusLost:Connect(function()
        local val = tonumber(thicknessBox.Text)
        if val then Settings.ESPLineThickness = val end
    end)
end

local textSizeBox = FindTextBox("ESP text size")
if textSizeBox then
    textSizeBox.FocusLost:Connect(function()
        local val = tonumber(textSizeBox.Text)
        if val then Settings.ESPTextSize = val end
    end)
end

-- Кнопки выбора цвета (привязываем через переопределение)
for _, btn in pairs(Content:GetDescendants()) do
    if btn:IsA("TextButton") and btn.Text:find("Blue") then
        btn.MouseButton1Click:Connect(function() Settings.ESPColor = "Blue" end)
    elseif btn:IsA("TextButton") and btn.Text:find("Red") then
        btn.MouseButton1Click:Connect(function() Settings.ESPColor = "Red" end)
    elseif btn:IsA("TextButton") and btn.Text:find("Green") then
        btn.MouseButton1Click:Connect(function() Settings.ESPColor = "Green" end)
    end
end

-- Кнопки выбора части тела
for _, btn in pairs(Content:GetDescendants()) do
    if btn:IsA("TextButton") and btn.Text == "Head" then
        btn.MouseButton1Click:Connect(function() Settings.AimPart = "Head" end)
    elseif btn:IsA("TextButton") and btn.Text == "Torso" then
        btn.MouseButton1Click:Connect(function() Settings.AimPart = "Torso" end)
    elseif btn:IsA("TextButton") and btn.Text:find("Legs") then
        btn.MouseButton1Click:Connect(function() Settings.AimPart = "HumanoidRootPart" end)
    end
end

-- Кнопки выбора профессии
for _, btn in pairs(Content:GetDescendants()) do
    if btn:IsA("TextButton") and btn.Text:find("Civilian") then
        btn.MouseButton1Click:Connect(function() Settings.Profession = "Civilian" end)
    elseif btn:IsA("TextButton") and btn.Text:find("Border Patrol") then
        btn.MouseButton1Click:Connect(function() Settings.Profession = "BorderPatrol" end)
    elseif btn:IsA("TextButton") and btn.Text:find("Police") then
        btn.MouseButton1Click:Connect(function() Settings.Profession = "Police" end)
    end
end

-- // ================================================
-- // ESP (СИСТЕМА ВИЗУАЛЬНЫХ ПОДСКАЗОК)
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
-- // АВТОФАРМ (ПРОФЕССИИ)
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
