--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               SWORD MASTER PRO - ACTIVE SCAN             ║
    ║        TEMA: SUPER RED | SEM BIBLIOTECAS EXTERNAS        ║
    ║          100% COMPATÍVEL COM DELTA / MOBILE              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimHubCustom") then CoreGui.ReyzimHubCustom:Destroy() end

-- [ CONFIGURAÇÕES ]
local espadasConfig = {
    {nome = "Yama", meta = 350, selecionada = false, encontrada = false},
    {nome = "Tushita", meta = 350, selecionada = false, encontrada = false},
    {nome = "Saishi", meta = 300, selecionada = false, encontrada = false},
    {nome = "Shizu", meta = 300, selecionada = false, encontrada = false},
    {nome = "Oroshi", meta = 300, selecionada = false, encontrada = false}
}
_G.MasteryEnabled = false
local scanning = false

-- [ CRIAÇÃO DA INTERFACE ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimHubCustom"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Botão Flutuante (Logo + Progresso)
local FloatingContainer = Instance.new("Frame")
local FloatingLogo = Instance.new("ImageButton")
local FloatingCorner = Instance.new("UICorner")
local FloatingStroke = Instance.new("UIStroke")
local FloatingText = Instance.new("TextLabel")

FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Parent = ScreenGui
FloatingContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.Position = UDim2.new(0.1, 0, 0.2, 0)
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

FloatingText.Name = "ProgressText"
FloatingText.Parent = FloatingContainer
FloatingText.Position = UDim2.new(0, -20, 0, 65)
FloatingText.Size = UDim2.new(0, 100, 0, 20)
FloatingText.BackgroundTransparency = 0.5
FloatingText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingText.Text = "Aguardando..."
FloatingText.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingText.Font = Enum.Font.GothamBold
FloatingText.TextSize = 10
FloatingText.Visible = true

local TextCorner = Instance.new("UICorner", FloatingText)
TextCorner.CornerRadius = UDim.new(0, 5)

-- Painel Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Credits = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
MainFrame.Size = UDim2.new(0, 260, 0, 360)
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
Title.Text = "SWORD MASTER PRO"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Clique em Verificar"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

Credits.Parent = MainFrame
Credits.Position = UDim2.new(0, 0, 1, -20)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Text = "Reyzim Scripts | @reyzim_dz"
Credits.TextColor3 = Color3.fromRGB(100, 0, 0)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 9
Credits.BackgroundTransparency = 1

local ActionFrame = Instance.new("Frame")
ActionFrame.Parent = MainFrame
ActionFrame.Position = UDim2.new(0, 10, 0, 65)
ActionFrame.Size = UDim2.new(1, -20, 0, 35)
ActionFrame.BackgroundTransparency = 1

local CheckBtn = Instance.new("TextButton")
local CheckCorner = Instance.new("UICorner")
CheckBtn.Name = "CheckBtn"
CheckBtn.Parent = ActionFrame
CheckBtn.Size = UDim2.new(0.48, 0, 1, 0)
CheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CheckBtn.Text = "VERIFICAR"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 11
CheckCorner.CornerRadius = UDim.new(0, 8)
CheckCorner.Parent = CheckBtn

local StartBtn = Instance.new("TextButton")
local StartCorner = Instance.new("UICorner")
StartBtn.Name = "StartBtn"
StartBtn.Parent = ActionFrame
StartBtn.Position = UDim2.new(0.52, 0, 0, 0)
StartBtn.Size = UDim2.new(0.48, 0, 1, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StartBtn.Text = "COMEÇAR"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 11
StartCorner.CornerRadius = UDim.new(0, 8)
StartCorner.Parent = StartBtn

Container.Name = "Container"
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 110)
Container.Size = UDim2.new(1, -20, 1, -140)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 5)

-- [ FUNÇÕES DE LÓGICA ]

local function updateUI()
    for _, child in pairs(Container:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local count = 0
    for i, espada in ipairs(espadasConfig) do
        if espada.encontrada then
            count = count + 1
            local ItemFrame = Instance.new("Frame")
            local ItemCorner = Instance.new("UICorner")
            local ItemLabel = Instance.new("TextLabel")
            local SelectToggle = Instance.new("TextButton")
            local SelectCorner = Instance.new("UICorner")

            ItemFrame.Size = UDim2.new(1, -5, 0, 35)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ItemFrame.Parent = Container
            ItemCorner.CornerRadius = UDim.new(0, 8)
            ItemCorner.Parent = ItemFrame

            ItemLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ItemLabel.Position = UDim2.new(0, 10, 0, 0)
            ItemLabel.BackgroundTransparency = 1
            ItemLabel.Text = "⚔️ " .. espada.nome
            ItemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ItemLabel.Font = Enum.Font.Gotham
            ItemLabel.TextSize = 11
            ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
            ItemLabel.Parent = ItemFrame

            SelectToggle.Size = UDim2.new(0, 60, 0, 25)
            SelectToggle.Position = UDim2.new(1, -70, 0.5, -12)
            SelectToggle.BackgroundColor3 = espada.selecionada and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
            SelectToggle.Text = espada.selecionada and "SIM" or "NÃO"
            SelectToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectToggle.Font = Enum.Font.GothamBold
            SelectToggle.TextSize = 10
            SelectToggle.Parent = ItemFrame
            SelectCorner.CornerRadius = UDim.new(0, 5)
            SelectCorner.Parent = SelectToggle

            SelectToggle.MouseButton1Click:Connect(function()
                espada.selecionada = not espada.selecionada
                SelectToggle.BackgroundColor3 = espada.selecionada and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
                SelectToggle.Text = espada.selecionada and "SIM" or "NÃO"
            end)
        end
    end
    Container.CanvasSize = UDim2.new(0, 0, 0, count * 40)
    if count == 0 then
        StatusLabel.Text = "Status: Nenhuma espada encontrada."
    else
        StatusLabel.Text = "Status: " .. count .. " espadas prontas."
    end
end

local function checkInventory()
    if scanning then return end
    scanning = true
    CheckBtn.Text = "VARRENDO..."
    CheckBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.spawn(function()
        for _, espada in ipairs(espadasConfig) do
            StatusLabel.Text = "Status: Testando " .. espada.nome .. "..."
            FloatingText.Text = "Testando " .. espada.nome
            
            -- Tenta equipar ativamente
            pcall(function() 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", espada.nome) 
            end)
            task.wait(1.5) -- Espera o servidor processar
            
            local item = LocalPlayer.Backpack:FindFirstChild(espada.nome) or LocalPlayer.Character:FindFirstChild(espada.nome)
            if item then
                espada.encontrada = true
            else
                espada.encontrada = false
            end
        end
        
        scanning = false
        CheckBtn.Text = "VERIFICAR"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        FloatingText.Text = "Varredura Concluída"
        updateUI()
    end)
end

-- [ LÓGICA DE INTERAÇÃO ]
FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CheckBtn.MouseButton1Click:Connect(function()
    checkInventory()
end)

StartBtn.MouseButton1Click:Connect(function()
    if scanning then return end
    if not _G.MasteryEnabled then
        local hasSelection = false
        for _, e in ipairs(espadasConfig) do if e.selecionada and e.encontrada then hasSelection = true break end end
        
        if not hasSelection then
            StatusLabel.Text = "Status: Selecione uma espada!"
            return
        end
        
        _G.MasteryEnabled = true
        StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        StartBtn.Text = "PARAR"
        StatusLabel.Text = "Status: Farm Iniciado!"
    else
        _G.MasteryEnabled = false
        StartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        StartBtn.Text = "COMEÇAR"
        StatusLabel.Text = "Status: Farm Parado."
        FloatingText.Text = "Parado"
    end
end)

-- [ LOOP DE FARM ]
task.spawn(function()
    while true do
        task.wait(1)
        if _G.MasteryEnabled then
            for _, espada in ipairs(espadasConfig) do
                if not _G.MasteryEnabled then break end
                
                if espada.encontrada and espada.selecionada then
                    local nome = espada.nome
                    local meta = espada.meta
                    
                    StatusLabel.Text = "Status: Equipando " .. nome
                    FloatingText.Text = "Upar " .. nome
                    
                    pcall(function() 
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", nome) 
                    end)
                    task.wait(2.5)
                    
                    local item = LocalPlayer.Character:FindFirstChild(nome) or LocalPlayer.Backpack:FindFirstChild(nome)
                    
                    if item then
                        local level = item:GetAttribute("Level") or 0
                        if level < meta then
                            while level < meta and _G.MasteryEnabled do
                                if not LocalPlayer.Character:FindFirstChild(nome) then
                                    pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", nome) end)
                                end
                                level = item:GetAttribute("Level") or 0
                                
                                FloatingText.Text = nome .. ": " .. level .. "/" .. meta
                                StatusLabel.Text = "Status: Upando " .. nome
                                task.wait(3)
                            end
                        end
                    end
                end
            end
            if _G.MasteryEnabled then
                FloatingText.Text = "Finalizado ✅"
                _G.MasteryEnabled = false
                StartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                StartBtn.Text = "COMEÇAR"
                StatusLabel.Text = "Status: Concluído!"
            end
        end
    end
end)

-- Arrastar o container inteiro
FloatingLogo.Changed:Connect(function()
    FloatingContainer.Position = FloatingLogo.Position
end)

-- Inicia pedindo para verificar
StatusLabel.Text = "Status: Clique em Verificar para escanear."
