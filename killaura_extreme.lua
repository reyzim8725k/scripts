--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - KILL AURA V5              ║
    ║        FAST ATTACK | NO DELAY | OTIMIZADO MOBILE         ║
    ║          100% COMPATÍVEL COM MOBILE / DELTA              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

print("-----------------------------------------")
print("[REYZIM] KillAura Fast V5 - INICIADO")
print("-----------------------------------------")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimKillExtreme") then CoreGui.ReyzimKillExtreme:Destroy() end

-- [ CONFIGURAÇÕES ]
_G.KillAuraEnabled = false
_G.KillAuraRange = 60
_G.AutoEquip = true
_G.FastAttack = true

-- Remotes
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local AttackRemote = Net:WaitForChild("RE/RegisterAttack")
local HitRemote = Net:FindFirstChild("RE/RegisterHit")

-- [ CRIAÇÃO DA INTERFACE ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimKillExtreme"
ScreenGui.Parent = CoreGui

-- Botão Flutuante (Logo)
local FloatingContainer = Instance.new("Frame")
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")
local StatusLabel = Instance.new("TextLabel")

FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Parent = ScreenGui
FloatingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.Position = UDim2.new(0.1, 0, 0.4, 0)
FloatingContainer.Size = UDim2.new(0, 50, 0, 70)

FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Parent = FloatingContainer
FloatingLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingLogo.Size = UDim2.new(0, 50, 0, 50)
FloatingLogo.Image = "https://raw.githubusercontent.com/gtzimooo/raw-poder-remove/refs/heads/main/file_000000007644720ea092ead937d3b54d.png"
FloatingLogo.Draggable = true
FloatingLogo.Active = true
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingLogo
FloatingStroke.Color = Color3.fromRGB(255, 0, 0)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingLogo

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = FloatingContainer
StatusLabel.Position = UDim2.new(0, -25, 0, 55)
StatusLabel.Size = UDim2.new(0, 100, 0, 15)
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Text = "FAST: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 8
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 4)

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -100)
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Visible = false

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "KILL AURA V5"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12

-- Funções de Toggle
local function createToggle(name, pos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = default and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

createToggle("KillAura", UDim2.new(0, 10, 0, 45), false, function(s) 
    _G.KillAuraEnabled = s 
    StatusLabel.Text = s and "FAST: ON" or "FAST: OFF"
end)
createToggle("Auto Equipar", UDim2.new(0, 10, 0, 85), true, function(s) _G.AutoEquip = s end)
createToggle("Fast Attack", UDim2.new(0, 10, 0, 125), true, function(s) _G.FastAttack = s end)

-- Range
local RangeBtn = Instance.new("TextButton")
RangeBtn.Parent = MainFrame
RangeBtn.Position = UDim2.new(0, 10, 0, 165)
RangeBtn.Size = UDim2.new(1, -20, 0, 30)
RangeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RangeBtn.Text = "Range: " .. _G.KillAuraRange
RangeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeBtn.Font = Enum.Font.GothamBold
RangeBtn.TextSize = 10
Instance.new("UICorner", RangeBtn).CornerRadius = UDim.new(0, 6)

RangeBtn.MouseButton1Click:Connect(function()
    _G.KillAuraRange = _G.KillAuraRange + 20
    if _G.KillAuraRange > 200 then _G.KillAuraRange = 40 end
    RangeBtn.Text = "Range: " .. _G.KillAuraRange
end)

-- [ LÓGICA OTIMIZADA V5 ]
local function getTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    local myPos = char.HumanoidRootPart.Position
    
    -- Busca otimizada: Apenas em pastas conhecidas primeiro
    local enemyFolders = {workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("NPCs")}
    
    for _, folder in pairs(enemyFolders) do
        if folder then
            for _, v in pairs(folder:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    local dist = (myPos - v.HumanoidRootPart.Position).Magnitude
                    if dist <= _G.KillAuraRange then
                        table.insert(targets, v)
                    end
                end
            end
        end
    end
    
    -- Fallback rápido se não achar nada nas pastas (apenas arredores imediatos)
    if #targets == 0 then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
                if not Players:GetPlayerFromCharacter(v) then
                    local dist = (myPos - v.HumanoidRootPart.Position).Magnitude
                    if dist <= _G.KillAuraRange and v.Humanoid.Health > 0 then
                        table.insert(targets, v)
                    end
                end
            end
        end
    end
    
    return targets
end

task.spawn(function()
    while true do
        -- Velocidade ajustável
        if _G.FastAttack then
            task.wait(0.01)
        else
            task.wait(0.1)
        end
        
        if _G.KillAuraEnabled then
            -- Auto Equip
            if _G.AutoEquip then
                local char = LocalPlayer.Character
                if char and not char:FindFirstChildOfClass("Tool") then
                    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then char.Humanoid:EquipTool(tool) end
                end
            end
            
            local targets = getTargets()
            for _, target in pairs(targets) do
                if not _G.KillAuraEnabled then break end
                pcall(function()
                    AttackRemote:FireServer(0.5, 1)
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
end)

-- [ INTERAÇÃO ]
FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

FloatingLogo.Changed:Connect(function()
    FloatingContainer.Position = FloatingLogo.Position
end)
