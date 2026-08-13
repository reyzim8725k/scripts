--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - KILL AURA V6              ║
    ║        GOD RANGE (30KM) | NO LAG | TARGET COUNTER        ║
    ║          100% COMPATÍVEL COM MOBILE / DELTA              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

print("-----------------------------------------")
print("[REYZIM] KillAura God Range V6 - INICIADO")
print("-----------------------------------------")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimKillExtreme") then CoreGui.ReyzimKillExtreme:Destroy() end

-- [ CONFIGURAÇÕES ]
_G.KillAuraEnabled = false
_G.KillAuraRange = 500
_G.AutoEquip = true
_G.FastAttack = true
_G.TargetCount = 0

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
FloatingContainer.Size = UDim2.new(0, 60, 0, 80)

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

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = FloatingContainer
StatusLabel.Position = UDim2.new(0, -20, 0, 65)
StatusLabel.Size = UDim2.new(0, 100, 0, 20)
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Text = "Targets: 0"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 9
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 5)

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -130)
MainFrame.Size = UDim2.new(0, 200, 0, 260)
MainFrame.Visible = false

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "KILL AURA GOD V6"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

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

createToggle("KillAura", UDim2.new(0, 10, 0, 50), false, function(s) _G.KillAuraEnabled = s end)
createToggle("Auto Equipar", UDim2.new(0, 10, 0, 95), true, function(s) _G.AutoEquip = s end)
createToggle("Fast Attack", UDim2.new(0, 10, 0, 140), true, function(s) _G.FastAttack = s end)

-- Range God Mode
local RangeInput = Instance.new("TextBox")
RangeInput.Parent = MainFrame
RangeInput.Position = UDim2.new(0, 10, 0, 185)
RangeInput.Size = UDim2.new(1, -20, 0, 35)
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
        print("[REYZIM] God Range: " .. _G.KillAuraRange)
    end
end)

local Credits = Instance.new("TextLabel")
Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1, -25)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Text = "Reyzim Scripts | @reyzim_dz"
Credits.TextColor3 = Color3.fromRGB(120, 0, 0)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 9
Credits.BackgroundTransparency = 1

-- [ LÓGICA GOD RANGE V6 ]
local function getTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    local myPos = char.HumanoidRootPart.Position
    
    -- Busca otimizada em pastas específicas para performance extrema
    local folders = {workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("NPCs")}
    
    for _, folder in pairs(folders) do
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
    
    -- Fallback para NPCs soltos no workspace (apenas se não achar nada nas pastas)
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
        if _G.FastAttack then task.wait(0.01) else task.wait(0.1) end
        
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
            _G.TargetCount = #targets
            StatusLabel.Text = "Targets: " .. _G.TargetCount
            
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
        else
            StatusLabel.Text = "Targets: 0"
            task.wait(0.5)
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
