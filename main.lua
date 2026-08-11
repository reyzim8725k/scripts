--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM HOLE MERGER - V3 ULTIMATE           ║
    ║        TEMA: RED EDITION | MULTIHUB SYSTEM               ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimHoleMergerUI") then CoreGui.ReyzimHoleMergerUI:Destroy() end

-- [ CONFIGURAÇÕES ]
local Config = {
    Enabled = false,
    Range = 50,
    SafeZoneVisible = true,
    AutoShield = true,
    FlyHeight = 20,
    ESPEnabled = false,
    ManualFly = false,
    FlySpeed = 50
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
local TabContainer = Instance.new("ScrollingFrame")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "REYZIM MULTIHUB V3"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.Size = UDim2.new(1, -20, 1, -70)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1, -25)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Text = "Reyzim Scripts | @reyzim_dz"
Credits.TextColor3 = Color3.fromRGB(150, 0, 0)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 10
Credits.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Helper Functions para UI
local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = TabContainer
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 0, 0)
        callback(enabled)
    end)
    return btn
end

local function createTextBox(placeholder, callback)
    local box = Instance.new("TextBox")
    local corner = Instance.new("UICorner")
    box.Size = UDim2.new(1, 0, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 0, 0)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Parent = TabContainer
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    box.FocusLost:Connect(function(enter)
        if enter then callback(box.Text) end
    end)
    return box
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = TabContainer
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [ LÓGICA DE FUNCIONAMENTO ]

-- ESP SYSTEM
local function createESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ReyzimESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Enabled = Config.ESPEnabled
    
    local function apply()
        if player.Character then
            highlight.Parent = player.Character
        end
    end
    apply()
    player.CharacterAdded:Connect(apply)
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- FLY SYSTEM
local flyPart = nil
local function toggleFly(enabled)
    Config.ManualFly = enabled
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if enabled then
        flyPart = Instance.new("BodyVelocity")
        flyPart.Velocity = Vector3.new(0,0,0)
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyPart.Parent = root
    else
        if flyPart then flyPart:Destroy() end
    end
end

-- AUTO MERGE LOGIC (HYBRID)
local SafeZonePart = Instance.new("Part")
SafeZonePart.Shape = Enum.PartType.Ball
SafeZonePart.Material = Enum.Material.ForceField
SafeZonePart.Color = Color3.fromRGB(255, 0, 0)
SafeZonePart.Transparency = 1
SafeZonePart.CanCollide = false
SafeZonePart.Anchored = true
SafeZonePart.Parent = workspace

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end

-- [ UI ELEMENTS ]

createToggle("AUTO MERGE (HYBRID)", function(v)
    Config.Enabled = v
    if v then
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

createTextBox("RAIO DA ÁREA (NÚMERO)", function(v)
    local n = tonumber(v)
    if n then 
        Config.Range = n 
        SafeZonePart.Size = Vector3.new(n * 2, n * 2, n * 2)
    end
end)

createToggle("ESP PLAYERS", function(v)
    Config.ESPEnabled = v
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("ReyzimESP") then
            p.Character.ReyzimESP.Enabled = v
        end
    end
end)

createToggle("MANUAL FLY", toggleFly)

local targetPlayer = ""
createTextBox("NOME DO JOGADOR", function(v) targetPlayer = v end)
createButton("TELEPORTAR PARA JOGADOR", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetPlayer:lower()) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = getRoot()
            if root then root.CFrame = p.Character.HumanoidRootPart.CFrame end
            break
        end
    end
end)

createToggle("AUTO SHIELD", function(v) Config.AutoShield = v end)

-- [ LOOPS ]

-- Loop do Escudo
task.spawn(function()
    while true do
        if Config.AutoShield then pcall(function() ShieldRemote:InvokeServer() end) end
        task.wait(10)
    end
end)

-- Loop do Merge
task.spawn(function()
    while true do
        if Config.Enabled and not Config.ManualFly then
            local root = getRoot()
            if root then
                local holesFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Holes")
                local foundPair = false
                if holesFolder then
                    local holes = {}
                    for _, h in pairs(holesFolder:GetChildren()) do
                        local dist = (h:GetPivot().Position - SafeZonePart.Position).Magnitude
                        if dist <= Config.Range then
                            local t = h:GetAttribute("Tier")
                            local id = h:GetAttribute("HoleId")
                            if t and id then
                                if not holes[t] then holes[t] = {} end
                                table.insert(holes[t], {obj = h, id = id})
                            end
                        end
                    end
                    for tier, list in pairs(holes) do
                        if #list >= 2 then
                            foundPair = true
                            pcall(function() HoleMoveRemote:InvokeServer(list[1].id, root.Position) end)
                            task.wait(0.2)
                            root.CFrame = list[1].obj:GetPivot()
                            task.wait(0.2)
                            root.CFrame = list[2].obj:GetPivot()
                            task.wait(0.3)
                            root.CFrame = CFrame.new(SafeZonePart.Position + Vector3.new(0, Config.FlyHeight, 0))
                            break
                        end
                    end
                end
                if not foundPair then
                    local flyPos = SafeZonePart.Position + Vector3.new(0, Config.FlyHeight, 0)
                    if (root.Position - flyPos).Magnitude > 5 then root.CFrame = CFrame.new(flyPos) end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Visibilidade do Menu
FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- FPS e Fly Control
local lastIteration, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastIteration >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastIteration = tick()
    end
    
    if Config.ManualFly and flyPart then
        local root = getRoot()
        if root then
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            -- Simplificado para mobile: voa para onde a camera olha
            flyPart.Velocity = camera.CFrame.LookVector * Config.FlySpeed
        end
    end
end)

print("Reyzim V3 Ultimate Loaded!")
