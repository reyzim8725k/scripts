--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - CAKE QUEEN FARM           ║
    ║        AUTO TRAVEL | BOSS CHECK | KILL AURA | HOP        ║
    ║        TEMA: SUPER RED | OTIMIZADO PARA MOBILE           ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimCakeFarm") then CoreGui.ReyzimCakeFarm:Destroy() end

-- [ CONFIGURAÇÕES ]
local islandName = "Ice Cream Island"
local bossName = "Cake Queen"
local attackRemote = game:GetService("ReplicatedStorage").Modules.Net["RE/RegisterAttack"]
local travelSpeed = 150 -- Velocidade de viagem (ajustável para não bugar)

-- [ CRIAÇÃO DA INTERFACE ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimCakeFarm"
ScreenGui.Parent = CoreGui

-- Botão Flutuante (Logo + Status)
local FloatingContainer = Instance.new("Frame")
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")
local StatusText = Instance.new("TextLabel")

FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Parent = ScreenGui
FloatingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.Position = UDim2.new(0.1, 0, 0.5, 0)
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

StatusText.Name = "StatusText"
StatusText.Parent = FloatingContainer
StatusText.Position = UDim2.new(0, -20, 0, 65)
StatusText.Size = UDim2.new(0, 100, 0, 20)
StatusText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusText.BackgroundTransparency = 0.5
StatusText.Text = "Iniciando..."
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 10
Instance.new("UICorner", StatusText).CornerRadius = UDim.new(0, 5)

-- [ FUNÇÕES DE MOVIMENTAÇÃO E LOGICA ]

local function updateStatus(txt)
    StatusText.Text = txt
    print("[REYZIM] " .. txt)
end

local function serverHop()
    updateStatus("Hop Server...")
    task.wait(1)
    local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local Server, Next = nil, nil
    local function ListServers(cursor)
        local success, raw = pcall(function() return game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or "")) end)
        if success then return HttpService:JSONDecode(raw) end
    end

    repeat
        local data = ListServers(Next)
        if data and data.data then
            Server = data.data[math.random(1, #data.data)]
            Next = data.nextPageCursor
        else
            task.wait(2)
        end
    until Server and Server.playing < Server.maxPlayers and Server.id ~= game.JobId

    TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
end

local function smoothMove(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (targetPos - hrp.Position).Magnitude
    local duration = distance / travelSpeed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
    -- Desativa gravidade temporariamente para não cair durante o voo
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp
    
    tween:Play()
    tween.Completed:Wait()
    bv:Destroy()
end

local function startFarm()
    updateStatus("Indo para Ilha...")
    
    local island = workspace.Map:FindFirstChild(islandName)
    if not island then
        updateStatus("Ilha não encontrada!")
        return
    end
    
    -- Pega a posição da ilha (tenta achar um ponto central ou parte)
    local islandPos = island:IsA("Model") and island:GetPivot().Position or island.Position
    smoothMove(islandPos + Vector3.new(0, 50, 0)) -- Vai para cima da ilha
    
    task.wait(2)
    
    updateStatus("Procurando Boss...")
    local boss = workspace.Enemies:FindFirstChild(bossName)
    
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
        updateStatus("Matando Queen!")
        
        -- Loop de ataque
        while boss and boss.Parent and boss.Humanoid.Health > 0 do
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
            
            -- Fica em cima da cabeça
            LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
            
            -- Ataca
            pcall(function()
                attackRemote:FireServer(0.5, 1)
            end)
            
            task.wait(0.1)
        end
        
        updateStatus("Boss Morta! Hopping...")
        task.wait(2)
        serverHop()
    else
        updateStatus("Boss ausente. Hop!")
        task.wait(1)
        serverHop()
    end
end

-- [ INÍCIO ]
task.spawn(function()
    task.wait(3)
    startFarm()
end)

-- Arrastar logo
FloatingLogo.Changed:Connect(function()
    FloatingContainer.Position = FloatingLogo.Position
end)
