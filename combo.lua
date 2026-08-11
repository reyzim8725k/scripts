--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM COMBO MASTER - V1.3                 ║
    ║        TEMA: RED EDITION | COMBAT & COMBO SYSTEM         ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

print("-----------------------------------------")
print("Reyzim Combo Master V1.3 Carregando...")
print("-----------------------------------------")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimComboUI") then CoreGui.ReyzimComboUI:Destroy() end

-- [ CONFIGURAÇÕES ]
local ComboData = {
    Sequence = {},
}
local Config = {
    AimbotEnabled = false,
    AimbotSensitivity = 0.5,
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

-- [ FUNÇÕES DE SISTEMA ]
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

-- Função para encontrar o jogador mais próximo
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

-- [ INTERFACE CUSTOMIZADA ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimComboUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Botão Flutuante Principal (Logo)
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = ScreenGui
FloatingLogo.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
FloatingLogo.Position = UDim2.new(0.1, 0, 0.3, 0)
FloatingLogo.Size = UDim2.new(0, 50, 0, 50)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true

FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo

FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

-- Botão de Execução de Combo (Separado)
local ExecButton = Instance.new("TextButton")
local ExecCorner = Instance.new("UICorner")
local ExecStroke = Instance.new("UIStroke")

ExecButton.Name = "ExecButton"
ExecButton.Parent = ScreenGui
ExecButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ExecButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ExecButton.Size = UDim2.new(0, 60, 0, 60)
ExecButton.Text = "COMBO"
ExecButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecButton.Font = Enum.Font.GothamBold
ExecButton.TextSize = 12
ExecButton.Draggable = true
ExecButton.Active = true

ExecCorner.CornerRadius = UDim.new(1, 0)
ExecCorner.Parent = ExecButton

ExecStroke.Color = Color3.fromRGB(255, 255, 255)
ExecStroke.Thickness = 2
ExecStroke.Parent = ExecButton

-- Botão de Aimbot (Separado)
local AimButton = Instance.new("TextButton")
local AimCorner = Instance.new("UICorner")
local AimStroke = Instance.new("UIStroke")

AimButton.Name = "AimButton"
AimButton.Parent = ScreenGui
AimButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
AimButton.Position = UDim2.new(0.1, 0, 0.6, 0)
AimButton.Size = UDim2.new(0, 60, 0, 60)
AimButton.Text = "AIM: OFF"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.Font = Enum.Font.GothamBold
AimButton.TextSize = 12
AimButton.Draggable = true
AimButton.Active = true

AimCorner.CornerRadius = UDim.new(1, 0)
AimCorner.Parent = AimButton

AimStroke.Color = Color3.fromRGB(255, 0, 0)
AimStroke.Thickness = 2
AimStroke.Parent = AimButton

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
Title.Text = "COMBO MASTER V1.3"
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

-- Container da Sequência
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

-- Botões de Controle
local ControlFrame = Instance.new("Frame")
ControlFrame.Parent = MainFrame
ControlFrame.Position = UDim2.new(0, 10, 0, 260)
ControlFrame.Size = UDim2.new(1, -20, 0, 35)
ControlFrame.BackgroundTransparency = 1

local SaveBtn = Instance.new("TextButton")
local SaveCorner = Instance.new("UICorner")
SaveBtn.Parent = ControlFrame
SaveBtn.Size = UDim2.new(0.48, 0, 1, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SaveBtn.Text = "SALVAR COMBO"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 12
SaveCorner.CornerRadius = UDim.new(0, 8)
SaveCorner.Parent = SaveBtn

local ClearBtn = Instance.new("TextButton")
local ClearCorner = Instance.new("UICorner")
ClearBtn.Parent = ControlFrame
ClearBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ClearBtn.Text = "LIMPAR"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 12
ClearCorner.CornerRadius = UDim.new(0, 8)
ClearCorner.Parent = ClearBtn

-- [ LOGICA DE INTERFACE ]

local function updateSeqUI()
    for _, child in pairs(SeqScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for i, item in ipairs(ComboData.Sequence) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        frame.Parent = SeqScroll
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 1, 0)
        label.Text = item.key
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local delayBox = Instance.new("TextBox")
        delayBox.Size = UDim2.new(0.4, 0, 0.8, 0)
        delayBox.Position = UDim2.new(0.35, 0, 0.1, 0)
        delayBox.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        delayBox.Text = tostring(item.delay)
        delayBox.TextColor3 = Color3.fromRGB(255, 0, 0)
        delayBox.Font = Enum.Font.GothamBold
        delayBox.TextSize = 12
        delayBox.Parent = frame
        
        delayBox.FocusLost:Connect(function()
            local val = tonumber(delayBox.Text)
            if val then ComboData.Sequence[i].delay = val end
        end)
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.2, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.78, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        delBtn.Text = "X"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Parent = frame
        
        delBtn.MouseButton1Click:Connect(function()
            table.remove(ComboData.Sequence, i)
            updateSeqUI()
        end)
    end
    SeqScroll.CanvasSize = UDim2.new(0, 0, 0, #ComboData.Sequence * 35)
end

for _, k in pairs(keys) do
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.Text = k
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = KeyContainer
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        table.insert(ComboData.Sequence, {key = k, delay = 0.0})
        updateSeqUI()
    end)
end

SaveBtn.MouseButton1Click:Connect(function()
    saveCombo()
end)

ClearBtn.MouseButton1Click:Connect(function()
    ComboData.Sequence = {}
    updateSeqUI()
end)

FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

ExecButton.MouseButton1Click:Connect(function()
    executeCombo()
end)

AimButton.MouseButton1Click:Connect(function()
    Config.AimbotEnabled = not Config.AimbotEnabled
    AimButton.Text = Config.AimbotEnabled and "AIM: ON" or "AIM: OFF"
    AimButton.BackgroundColor3 = Config.AimbotEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 0, 0)
end)

-- [ LOOPS ]

-- Loop do Aimbot Câmera
RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
end)

-- Inicialização
loadCombo()
updateSeqUI()

print("Reyzim Combo Master V1.3 Carregado com Sucesso!")
