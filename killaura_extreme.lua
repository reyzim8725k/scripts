--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - KILL AURA V1.0            ║
    ║        TEMA: SUPER RED | VERSÃO ORIGINAL FUNCIONAL       ║
    ║          100% COMPATÍVEL COM MOBILE / DELTA              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimKillExtreme") then CoreGui.ReyzimKillExtreme:Destroy() end

-- [ CONFIGURAÇÕES ]
_G.KillAuraEnabled = false
_G.KillAuraRange = 20
_G.AttackNPCs = true
_G.AttackPlayers = false

local AttackRemote = game:GetService("ReplicatedStorage").Modules.Net["RE/RegisterAttack"]

-- [ CRIAÇÃO DA INTERFACE ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimKillExtreme"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Botão Flutuante (Logo)
local FloatingContainer = Instance.new("Frame")
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")

FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Parent = ScreenGui
FloatingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.Position = UDim2.new(0.1, 0, 0.4, 0)
FloatingContainer.Size = UDim2.new(0, 50, 0, 50)

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = FloatingContainer
FloatingLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingLogo.Size = UDim2.new(1, 0, 1, 0)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true

FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo

FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
MainFrame.Size = UDim2.new(0, 200, 0, 240)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KILL AURA V1.0"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1, -20)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Text = "Reyzim Scripts | @reyzim_dz"
Credits.TextColor3 = Color3.fromRGB(120, 0, 0)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 9
Credits.BackgroundTransparency = 1

-- Funções de Botão (Toggles)
local function createToggle(name, pos, default, callback)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    
    btn.Name = name
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = default and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

createToggle("KillAura", UDim2.new(0, 10, 0, 50), false, function(s) _G.KillAuraEnabled = s end)
createToggle("Atacar NPCs", UDim2.new(0, 10, 0, 90), true, function(s) _G.AttackNPCs = s end)
createToggle("Atacar Players", UDim2.new(0, 10, 0, 130), false, function(s) _G.AttackPlayers = s end)

-- [ LÓGICA DE ATAQUE ]
local function getTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    -- Procura NPCs
    if _G.AttackNPCs then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
                if not Players:GetPlayerFromCharacter(v) then
                    local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist <= _G.KillAuraRange and v.Humanoid.Health > 0 then
                        table.insert(targets, v)
                    end
                end
            end
        end
    end
    
    -- Procura Players
    if _G.AttackPlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= _G.KillAuraRange and p.Character.Humanoid.Health > 0 then
                    table.insert(targets, p.Character)
                end
            end
        end
    end
    
    return targets
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.KillAuraEnabled then
            local targets = getTargets()
            for _, target in pairs(targets) do
                pcall(function()
                    AttackRemote:FireServer(0.5, 1)
                end)
            end
        end
    end
end)

-- [ INTERAÇÃO UI ]
FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Arrastar container
FloatingLogo.Changed:Connect(function()
    FloatingContainer.Position = FloatingLogo.Position
end)

print("Reyzim KillAura V1.0 Restaurado!")
