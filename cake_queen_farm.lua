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
local travelSpeed = 150 

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

-- Lógica de Server Hop Persistente
local function serverHop()
    updateStatus("Hop Persistente...")
    
    local function tryTeleport()
        local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local function ListServers(cursor)
            local success, raw = pcall(function() return game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or "")) end)
            if success then return HttpService:JSONDecode(raw) end
        end

        local Next = nil
        local data = ListServers(Next)
        
        if data and data.data then
            -- Tenta vários servidores da lista para aumentar a chance
            for i = 1, #data.data do
                local s = data.data[i]
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    updateStatus("Tentando Server...")
                    local success, err = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    end)
                    
                    task.wait(3) -- Espera um pouco para ver se o teleporte inicia
                    
                    if not success then
                        warn("Falha ao teleportar para " .. s.id .. ": " .. tostring(err))
                    end
                end
            end
        end
    end

    -- Loop infinito até o jogador sair do servidor
    while task.wait(5) do
        tryTeleport()
        updateStatus("Retentando Hop...")
    end
end

local function smoothMove(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (targetPos - hrp.Position).Magnitude
    local duration = distance / travelSpeed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
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
        serverHop()
        return
    end
    
    local islandPos = island:IsA("Model") and island:GetPivot().Position or island.Position
    smoothMove(islandPos + Vector3.new(0, 50, 0))
    
    task.wait(2)
    
    updateStatus("Procurando Boss...")
    local boss = workspace.Enemies:FindFirstChild(bossName)
    
    if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
        updateStatus("Matando Queen!")
        
        while boss and boss.Parent and boss.Humanoid.Health > 0 do
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
            LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
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
