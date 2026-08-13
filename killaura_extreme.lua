--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - KILL AURA EXTREME V3      ║
    ║        RANGE: 30,000 METROS | AUTO-HIT | AUTO-EQUIP      ║
    ║          100% COMPATÍVEL COM MOBILE / DELTA              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

print("-----------------------------------------")
print("[REYZIM] KillAura Extreme V3 - INICIADO")
print("-----------------------------------------")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimKillExtreme") then CoreGui.ReyzimKillExtreme:Destroy() end

-- [ CONFIGURAÇÕES ]
_G.KillAuraEnabled = false
_G.KillAuraRange = 500
_G.AttackNPCs = true
_G.AttackPlayers = false
_G.AutoEquip = true

-- Remotes extraídos do rspy do usuário e pesquisa
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local AttackRemote = Net:WaitForChild("RE/RegisterAttack")
local HitRemote = Net:FindFirstChild("RE/RegisterHit") -- Tentativa de encontrar o Hit

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
local StatusDisplay = Instance.new("TextLabel")

FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Parent = ScreenGui
FloatingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.Position = UDim2.new(0.1, 0, 0.3, 0)
FloatingContainer.Size = UDim2.new(0, 60, 0, 85)

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = FloatingContainer
FloatingLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingLogo.Size = UDim2.new(0, 60, 0, 60)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo
FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

StatusDisplay.Name = "StatusDisplay"
StatusDisplay.Parent = FloatingContainer
StatusDisplay.Position = UDim2.new(0, -20, 0, 65)
StatusDisplay.Size = UDim2.new(0, 100, 0, 20)
StatusDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusDisplay.BackgroundTransparency = 0.5
StatusDisplay.Text = "KillAura: OFF"
StatusDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusDisplay.Font = Enum.Font.GothamBold
StatusDisplay.TextSize = 9
Instance.new("UICorner", StatusDisplay).CornerRadius = UDim.new(0, 5)

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "KILL AURA EXTREME V3"
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

-- Funções de Toggle
local function createToggle(name, pos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = default and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

createToggle("KillAura", UDim2.new(0, 10, 0, 50), false, function(s) 
    _G.KillAuraEnabled = s 
    StatusDisplay.Text = s and "KillAura: ON" or "KillAura: OFF"
end)
createToggle("Atacar NPCs", UDim2.new(0, 10, 0, 95), true, function(s) _G.AttackNPCs = s end)
createToggle("Atacar Players", UDim2.new(0, 10, 0, 140), false, function(s) _G.AttackPlayers = s end)
createToggle("Auto Equipar", UDim2.new(0, 10, 0, 185), true, function(s) _G.AutoEquip = s end)

-- Controle de Range
local RangeInput = Instance.new("TextBox")
RangeInput.Parent = MainFrame
RangeInput.Position = UDim2.new(0, 10, 0, 230)
RangeInput.Size = UDim2.new(1, -20, 0, 30)
RangeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RangeInput.Text = "500"
RangeInput.PlaceholderText = "Range (Max 30000)"
RangeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeInput.Font = Enum.Font.GothamBold
RangeInput.TextSize = 12
Instance.new("UICorner", RangeInput).CornerRadius = UDim.new(0, 8)

RangeInput.FocusLost:Connect(function()
    local val = tonumber(RangeInput.Text)
    if val then
        _G.KillAuraRange = math.clamp(val, 1, 30000)
        RangeInput.Text = tostring(_G.KillAuraRange)
        print("[REYZIM] Range: " .. _G.KillAuraRange)
    end
end)

-- [ LÓGICA DE AUTO-EQUIP ]
local function equipWeapon()
    if not _G.AutoEquip then return end
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Se já estiver segurando algo, não faz nada
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then return end
    end
    
    -- Tenta equipar Espada ou Estilo de Luta da mochila
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == "Sword" or v.ToolTip == "Melee") then
            char.Humanoid:EquipTool(v)
            break
        end
    end
end

-- [ LÓGICA DE ATAQUE V3 ]
local function getTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    local myPos = char.HumanoidRootPart.Position
    
    -- Busca otimizada
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
            local targetChar = v.Parent
            if targetChar ~= char then
                local dist = (myPos - targetChar.HumanoidRootPart.Position).Magnitude
                if dist <= _G.KillAuraRange then
                    local isPlayer = Players:GetPlayerFromCharacter(targetChar)
                    if (isPlayer and _G.AttackPlayers) or (not isPlayer and _G.AttackNPCs) then
                        table.insert(targets, targetChar)
                    end
                end
            end
        end
        if #targets >= 15 then break end -- Limite para evitar kick
    end
    
    return targets
end

task.spawn(function()
    while true do
        task.wait(0.05) -- Ataque ultra rápido
        if _G.KillAuraEnabled then
            equipWeapon()
            local targets = getTargets()
            
            if #targets > 0 then
                for _, target in pairs(targets) do
                    if not _G.KillAuraEnabled then break end
                    
                    pcall(function()
                        -- 1. Inicia o ataque (Baseado no seu rspy)
                        AttackRemote:FireServer(0.5, 1)
                        
                        -- 2. Registra o Hit (Essencial para dar dano)
                        if HitRemote then
                            local head = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
                            if head then
                                HitRemote:FireServer(head, {})
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- [ INTERAÇÃO UI ]
FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

FloatingLogo.Changed:Connect(function()
    FloatingContainer.Position = FloatingLogo.Position
end)

print("[REYZIM] KillAura Extreme V3 - PRONTO!")
