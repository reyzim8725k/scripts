--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM COMBO MASTER - V1.5                 ║
    ║        TEMA: RED EDITION | COMBAT & COMBO SYSTEM         ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ║                                                          ║
    ║   DESCRIÇÃO: Script profissional para mobile com combos, ║
    ║   delays ajustáveis, Aimbot de Player e Aimbot de NPC.   ║
    ╚══════════════════════════════════════════════════════════╝
]]

-- Mensagem de inicialização no console
print("-----------------------------------------")
print("Reyzim Combo Master V1.5 Carregando...")
print("-----------------------------------------")

-- [ SERVIÇOS DO ROBLOX ]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove versões antigas da interface
if CoreGui:FindFirstChild("ReyzimComboUI") then CoreGui.ReyzimComboUI:Destroy() end

-- [ VARIÁVEIS DE CONFIGURAÇÃO ]
local ComboData = {
    Sequence = {},
}
local Config = {
    PlayerAimEnabled = false,
    NPCAimEnabled = false,
}
local SaveFile = "ReyzimComboSave.json"

-- Mapeamento de teclas para Enum.KeyCode
local KeyMapping = {
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["Z"] = Enum.KeyCode.Z,
    ["X"] = Enum.KeyCode.X,
    ["V"] = Enum.KeyCode.V,
    ["F"] = Enum.KeyCode.F,
    ["C"] = Enum.KeyCode.C
}

-- [ SISTEMA DE SALVAMENTO ]
local function saveCombo()
    pcall(function()
        local data = HttpService:JSONEncode(ComboData.Sequence)
        writefile(SaveFile, data)
    end)
end

local function loadCombo()
    pcall(function()
        if isfile(SaveFile) then
            local data = readfile(SaveFile)
            ComboData.Sequence = HttpService:JSONDecode(data)
        end
    end)
end

-- [ LÓGICA DE EXECUÇÃO DO COMBO ]
local function executeCombo()
    for _, item in ipairs(ComboData.Sequence) do
        local keyStr = tostring(item.key)
        local keyCode = KeyMapping[keyStr]
        local delayTime = tonumber(item.delay) or 0
        
        if keyCode then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
            end)
        end
        
        if delayTime > 0 then
            task.wait(delayTime)
        end
    end
end

-- [ LÓGICA DO AIMBOT ]

-- Jogador mais próximo
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- NPC mais próximo em workspace.Enemies
local function getClosestNPC()
    local closestNPC = nil
    local shortestDistance = math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    
    if enemiesFolder then
        for _, npc in pairs(enemiesFolder:GetChildren()) do
            local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("PrimaryPart")
            local hum = npc:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local distance = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestNPC = npc
                    shortestDistance = distance
                end
            end
        end
    end
    return closestNPC
end

-- [ INTERFACE GRÁFICA (UI) ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimComboUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Helper para botões flutuantes
local function createFloatingButton(name, text, pos, color)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    local stroke = Instance.new("UIStroke")
    
    btn.Name = name
    btn.Parent = ScreenGui
    btn.BackgroundColor3 = color
    btn.Position = pos
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Draggable = true
    btn.Active = true
    
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = btn
    
    return btn
end

-- Botão Logo (Menu)
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = ScreenGui
FloatingLogo.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
FloatingLogo.Position = UDim2.new(0.1, 0, 0.25, 0)
FloatingLogo.Size = UDim2.new(0, 50, 0, 50)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo
FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

-- Botões de Ação
local ExecButton = createFloatingButton("ExecButton", "COMBO", UDim2.new(0.1, 0, 0.4, 0), Color3.fromRGB(255, 0, 0))
local AimPlayerBtn = createFloatingButton("AimPlayerBtn", "P-AIM: OFF", UDim2.new(0.1, 0, 0.55, 0), Color3.fromRGB(40, 0, 0))
local AimNPCBtn = createFloatingButton("AimNPCBtn", "N-AIM: OFF", UDim2.new(0.1, 0, 0.7, 0), Color3.fromRGB(40, 0, 0))

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -160)
MainFrame.Size = UDim2.new(0, 300, 0, 320)
MainFrame.Visible = false
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "COMBO MASTER V1.5"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1, -25)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Text = "Reyzim Scripts | @reyzim_dz"
Credits.TextColor3 = Color3.fromRGB(150, 0, 0)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 10
Credits.BackgroundTransparency = 1

-- Seletor de Teclas
local KeyContainer = Instance.new("Frame")
KeyContainer.Name = "KeyContainer"
KeyContainer.Parent = MainFrame
KeyContainer.Position = UDim2.new(0, 10, 0, 45)
KeyContainer.Size = UDim2.new(1, -20, 0, 80)
KeyContainer.BackgroundTransparency = 1

local keys = {"1", "2", "3", "4", "5", "6", "Z", "X", "V", "F", "C"}
local UIListLayoutKeys = Instance.new("UIGridLayout")
UIListLayoutKeys.Parent = KeyContainer
UIListLayoutKeys.CellSize = UDim2.new(0, 35, 0, 35)
UIListLayoutKeys.CellPadding = UDim2.new(0, 5, 0, 5)

-- Lista da Sequência
local SeqScroll = Instance.new("ScrollingFrame")
SeqScroll.Name = "SeqScroll"
SeqScroll.Parent = MainFrame
SeqScroll.Position = UDim2.new(0, 10, 0, 130)
SeqScroll.Size = UDim2.new(1, -20, 0, 120)
SeqScroll.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
SeqScroll.BorderSizePixel = 0
SeqScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
SeqScroll.ScrollBarThickness = 3
SeqScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
local UIListLayoutSeq = Instance.new("UIListLayout")
UIListLayoutSeq.Parent = SeqScroll
UIListLayoutSeq.Padding = UDim.new(0, 5)

-- Lógica da Lista
local function updateSeqUI()
    for _, child in pairs(SeqScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, item in ipairs(ComboData.Sequence) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        frame.Parent = SeqScroll
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.2, 0, 1, 0)
        label.Text = item.key
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local minusBtn = Instance.new("TextButton")
        minusBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
        minusBtn.Position = UDim2.new(0.25, 0, 0.1, 0)
        minusBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        minusBtn.Text = "-"
        minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minusBtn.Parent = frame
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)
        
        local delayBox = Instance.new("TextBox")
        delayBox.Size = UDim2.new(0.25, 0, 0.8, 0)
        delayBox.Position = UDim2.new(0.42, 0, 0.1, 0)
        delayBox.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        delayBox.Text = string.format("%.1f", item.delay)
        delayBox.TextColor3 = Color3.fromRGB(255, 0, 0)
        delayBox.Font = Enum.Font.GothamBold
        delayBox.TextSize = 12
        delayBox.Parent = frame
        
        local plusBtn = Instance.new("TextButton")
        plusBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
        plusBtn.Position = UDim2.new(0.69, 0, 0.1, 0)
        plusBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        plusBtn.Text = "+"
        plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        plusBtn.Parent = frame
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.12, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.86, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        delBtn.Text = "X"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Parent = frame
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
        
        minusBtn.MouseButton1Click:Connect(function() item.delay = math.max(0, item.delay - 0.1) delayBox.Text = string.format("%.1f", item.delay) end)
        plusBtn.MouseButton1Click:Connect(function() item.delay = item.delay + 0.1 delayBox.Text = string.format("%.1f", item.delay) end)
        delayBox.FocusLost:Connect(function() local val = tonumber(delayBox.Text) if val then item.delay = math.max(0, val) end delayBox.Text = string.format("%.1f", item.delay) end)
        delBtn.MouseButton1Click:Connect(function() table.remove(ComboData.Sequence, i) updateSeqUI() end)
    end
    SeqScroll.CanvasSize = UDim2.new(0, 0, 0, #ComboData.Sequence * 35)
end

-- Botões do Seletor
for _, k in pairs(keys) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.Text = k
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = KeyContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() table.insert(ComboData.Sequence, {key = k, delay = 0.0}) updateSeqUI() end)
end

-- Controles Inferiores
local ControlFrame = Instance.new("Frame")
ControlFrame.Parent = MainFrame
ControlFrame.Position = UDim2.new(0, 10, 0, 260)
ControlFrame.Size = UDim2.new(1, -20, 0, 35)
ControlFrame.BackgroundTransparency = 1

local SaveBtn = Instance.new("TextButton")
SaveBtn.Parent = ControlFrame
SaveBtn.Size = UDim2.new(0.48, 0, 1, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SaveBtn.Text = "SALVAR COMBO"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 12
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Parent = ControlFrame
ClearBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ClearBtn.Text = "LIMPAR"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 12
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

-- [ EVENTOS ]
SaveBtn.MouseButton1Click:Connect(saveCombo)
ClearBtn.MouseButton1Click:Connect(function() ComboData.Sequence = {} updateSeqUI() end)
FloatingLogo.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
ExecButton.MouseButton1Click:Connect(executeCombo)

AimPlayerBtn.MouseButton1Click:Connect(function()
    Config.PlayerAimEnabled = not Config.PlayerAimEnabled
    Config.NPCAimEnabled = false -- Desliga o outro
    AimPlayerBtn.Text = Config.PlayerAimEnabled and "P-AIM: ON" or "P-AIM: OFF"
    AimNPCBtn.Text = "N-AIM: OFF"
    AimPlayerBtn.BackgroundColor3 = Config.PlayerAimEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 0, 0)
    AimNPCBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
end)

AimNPCBtn.MouseButton1Click:Connect(function()
    Config.NPCAimEnabled = not Config.NPCAimEnabled
    Config.PlayerAimEnabled = false -- Desliga o outro
    AimNPCBtn.Text = Config.NPCAimEnabled and "N-AIM: ON" or "N-AIM: OFF"
    AimPlayerBtn.Text = "P-AIM: OFF"
    AimNPCBtn.BackgroundColor3 = Config.NPCAimEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 0, 0)
    AimPlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
end)

-- [ LOOP DO AIMBOT ]
RunService.RenderStepped:Connect(function()
    if Config.PlayerAimEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    elseif Config.NPCAimEnabled then
        local target = getClosestNPC()
        if target then
            local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("PrimaryPart")
            if root then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            end
        end
    end
end)

-- Inicialização
loadCombo()
updateSeqUI()
print("Reyzim Combo Master V1.5 Carregado com Sucesso!")
