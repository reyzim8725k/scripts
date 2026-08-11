--[[
    ╔══════════════════════════════════════════════════════════╗
    ║             REYZIM HOLE MERGER - TELEKINESIS             ║
    ║        TEMA: RED EDITION | REMOTE MOVE SYSTEM            ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimHoleMergerUI") then CoreGui.ReyzimHoleMergerUI:Destroy() end

-- [ CONFIGURAÇÕES ]
local Config = {
    Enabled = false,
    Range = 50,
    AutoShield = true,
}

-- [ REMOTES ]
local ShieldRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_knit@1.7.0"].knit.Services.ShieldService.RF.ActivateShield
local HoleMoveRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_knit@1.7.0"].knit.Services.HoleService.RF.RequestMove

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
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -125)
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Visible = false

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HOLE TELEKINESIS"
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

-- Botões e Inputs
local function createButton(text, pos, parent)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = pos
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local ToggleBtn = createButton("TELEKINESIS: OFF", UDim2.new(0.1, 0, 0.2, 0), MainFrame)
local ShieldBtn = createButton("AUTO SHIELD: ON", UDim2.new(0.1, 0, 0.38, 0), MainFrame)
ShieldBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local RangeLabel = Instance.new("TextLabel")
RangeLabel.Parent = MainFrame
RangeLabel.Position = UDim2.new(0.1, 0, 0.58, 0)
RangeLabel.Size = UDim2.new(0.5, 0, 0, 20)
RangeLabel.Text = "RAIO DA ÁREA:"
RangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.TextSize = 12
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.BackgroundTransparency = 1

local RangeInput = Instance.new("TextBox")
RangeInput.Parent = MainFrame
RangeInput.Position = UDim2.new(0.6, 0, 0.58, 0)
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
SafeZonePart.Transparency = 1
SafeZonePart.CanCollide = false
SafeZonePart.Anchored = true
SafeZonePart.Parent = workspace

-- [ LÓGICA DE FUNCIONAMENTO ]

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function findHoles()
    local holesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Holes")
    if not holesFolder then return {} end
    
    local found = {}
    for _, hole in pairs(holesFolder:GetChildren()) do
        local pos = hole:GetPivot().Position
        local dist = (pos - SafeZonePart.Position).Magnitude
        
        if dist <= Config.Range then
            local tier = hole:GetAttribute("Tier")
            local id = hole:GetAttribute("HoleId")
            if tier and id then
                if not found[tier] then found[tier] = {} end
                table.insert(found[tier], {obj = hole, id = id, pos = pos})
            end
        end
    end
    return found
end

-- Toggles
ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    ToggleBtn.Text = Config.Enabled and "TELEKINESIS: ON" or "TELEKINESIS: OFF"
    ToggleBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
    
    if Config.Enabled then
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

ShieldBtn.MouseButton1Click:Connect(function()
    Config.AutoShield = not Config.AutoShield
    ShieldBtn.Text = Config.AutoShield and "AUTO SHIELD: ON" or "AUTO SHIELD: OFF"
    ShieldBtn.BackgroundColor3 = Config.AutoShield and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
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

-- Loop do Escudo (10 segundos)
task.spawn(function()
    while true do
        if Config.AutoShield then
            pcall(function() ShieldRemote:InvokeServer() end)
        end
        task.wait(10)
    end
end)

-- Main Loop (Telekinesis: Move Holes to each other)
task.spawn(function()
    while true do
        if Config.Enabled then
            local allHoles = findHoles()
            
            for tier, list in pairs(allHoles) do
                if #list >= 2 then
                    local h1 = list[1]
                    local h2 = list[2]
                    
                    -- Move o primeiro Hole para a posição do segundo Hole
                    pcall(function()
                        HoleMoveRemote:InvokeServer(h1.id, h2.pos)
                    end)
                    
                    task.wait(0.3) -- Pequeno delay para processar a fusão
                end
            end
        end
        task.wait(0.2)
    end
end)

-- FPS
local lastIteration, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastIteration >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastIteration = tick()
    end
end)

print("Reyzim Hole Merger Telekinesis Loaded!")
