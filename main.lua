--[[
    ╔══════════════════════════════════════════════════════════╗
    ║                 REYZIM HOLE MERGER - PRO                 ║
    ║        TEMA: RED EDITION | SEM BIBLIOTECAS EXTERNAS      ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimHoleMergerUI") then CoreGui.ReyzimHoleMergerUI:Destroy() end

-- [ CONFIGURAÇÕES ]
local Config = {
    Enabled = false,
    Range = 50,
    Speed = 50,
    SafeZoneVisible = true
}

-- [ INTERFACE CUSTOMIZADA ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimHoleMergerUI"
ScreenGui.Parent = CoreGui

-- Botão Flutuante (Logo)
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")
local FPSLabel = Instance.new("TextLabel")

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = ScreenGui
FloatingLogo.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
FloatingLogo.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatingLogo.Size = UDim2.new(0, 55, 0, 55)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true

FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo

FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

FPSLabel.Parent = FloatingLogo
FPSLabel.Size = UDim2.new(1, 0, 0, 20)
FPSLabel.Position = UDim2.new(0, 0, 1, 5)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 12

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Visible = false

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HOLE MERGER"
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

-- Botão Toggle
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ToggleBtn.Text = "AUTO MERGE: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14

ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Slider de Range
local RangeLabel = Instance.new("TextLabel")
local RangeInput = Instance.new("TextBox")

RangeLabel.Parent = MainFrame
RangeLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
RangeLabel.Size = UDim2.new(0.5, 0, 0, 20)
RangeLabel.Text = "RAIO DA ÁREA:"
RangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.TextSize = 12
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.BackgroundTransparency = 1

RangeInput.Parent = MainFrame
RangeInput.Position = UDim2.new(0.6, 0, 0.5, 0)
RangeInput.Size = UDim2.new(0.3, 0, 0, 20)
RangeInput.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
RangeInput.Text = tostring(Config.Range)
RangeInput.TextColor3 = Color3.fromRGB(255, 0, 0)
RangeInput.Font = Enum.Font.GothamBold
RangeInput.TextSize = 12

-- Esfera Visual (Safe Zone)
local SafeZonePart = Instance.new("Part")
SafeZonePart.Name = "ReyzimSafeZone"
SafeZonePart.Shape = Enum.PartType.Ball
SafeZonePart.Material = Enum.Material.ForceField
SafeZonePart.Color = Color3.fromRGB(255, 0, 0)
SafeZonePart.Transparency = 0.8
SafeZonePart.CanCollide = false
SafeZonePart.Anchored = true
SafeZonePart.Parent = workspace

-- [ LÓGICA DE FUNCIONAMENTO ]

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function moveTo(targetCFrame)
    local root = getRoot()
    if not root then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / Config.Speed
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local function findHoles()
    local holesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Holes")
    if not holesFolder then return {} end
    
    local found = {}
    local root = getRoot()
    if not root then return {} end
    
    for _, hole in pairs(holesFolder:GetChildren()) do
        if hole:IsA("Model") or hole:IsA("BasePart") then
            local pos = hole:GetPivot().Position
            local dist = (pos - SafeZonePart.Position).Magnitude
            
            if dist <= Config.Range then
                local tier = hole:GetAttribute("Tier")
                if tier then
                    if not found[tier] then found[tier] = {} end
                    table.insert(found[tier], hole)
                end
            end
        end
    end
    return found
end

-- Toggle Logic
ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    ToggleBtn.Text = Config.Enabled and "AUTO MERGE: ON" or "AUTO MERGE: OFF"
    ToggleBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
    
    if Config.Enabled then
        -- Fixa a Safe Zone onde o player ligou o script
        local root = getRoot()
        if root then
            SafeZonePart.Position = root.Position
            SafeZonePart.Size = Vector3.new(Config.Range * 2, Config.Range * 2, Config.Range * 2)
            SafeZonePart.Transparency = 0.8
        end
    else
        SafeZonePart.Transparency = 1
    end
end)

RangeInput.FocusLost:Connect(function()
    local val = tonumber(RangeInput.Text)
    if val then
        Config.Range = val
        SafeZonePart.Size = Vector3.new(val * 2, val * 2, val * 2)
    else
        RangeInput.Text = tostring(Config.Range)
    end
end)

FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Main Loop
task.spawn(function()
    while true do
        if Config.Enabled then
            local allHoles = findHoles()
            local foundPair = false
            
            for tier, list in pairs(allHoles) do
                if #list >= 2 then
                    foundPair = true
                    local h1 = list[1]
                    local h2 = list[2]
                    
                    -- Move para o primeiro Hole
                    moveTo(h1:GetPivot())
                    task.wait(0.5) -- Espera "grudar"
                    
                    -- Move para o segundo Hole para fundir
                    moveTo(h2:GetPivot())
                    task.wait(0.5) -- Espera fusão
                    
                    break -- Processa um par por vez
                end
            end
            
            if not foundPair then
                task.wait(1) -- Espera novos Holes nascerem
            end
        end
        task.wait(0.1)
    end
end)

-- FPS e Update Esfera
local lastIteration, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastIteration >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastIteration = tick()
    end
    
    if not Config.Enabled then
        SafeZonePart.Transparency = 1
    end
end)

print("Reyzim Hole Merger Loaded!")
