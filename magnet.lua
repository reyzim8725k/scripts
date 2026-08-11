--[[
    ╔══════════════════════════════════════════════════════════╗
    ║                 REYZIM MAGNET PRO - V1.1                 ║
    ║        TEMA: RED EDITION | OBJECT ATTRACTION SYSTEM      ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Remove versões antigas
if CoreGui:FindFirstChild("ReyzimMagnetUI") then CoreGui.ReyzimMagnetUI:Destroy() end

-- [ CONFIGURAÇÕES ]
local Config = {
    Enabled = false,
}

-- [ INTERFACE CUSTOMIZADA ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyzimMagnetUI"
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
Title.Text = "MAGNET PRO V1.1"
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

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Text = "MAGNET: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14

ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

-- [ LÓGICA DE FUNCIONAMENTO ]

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    ToggleBtn.Text = Config.Enabled and "MAGNET: ON" or "MAGNET: OFF"
    ToggleBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
end)

FloatingLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Main Loop (Magnet Logic)
task.spawn(function()
    while true do
        if Config.Enabled then
            local root = getRoot()
            local eatable = workspace:FindFirstChild("Eatable")
            
            if root and eatable then
                for _, item in pairs(eatable:GetChildren()) do
                    if item:IsA("BasePart") then
                        item.CFrame = root.CFrame
                        item.Velocity = Vector3.new(0,0,0)
                    elseif item:IsA("Model") then
                        item:PivotTo(root.CFrame)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- FPS Counter
local lastIteration, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastIteration >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastIteration = tick()
    end
end)

print("Reyzim Magnet Pro V1.1 Loaded!")
