--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TELEGRAM LOG              ║
    ║        ENVIA INFORMAÇÕES DE EXECUÇÃO PARA O BOT          ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- [ CONFIGURAÇÕES ]
local TOKEN = "8500284543:AAGzMLvtIBmRVPzgMYEo9tdqd2GHoW6TUPI"
local CHAT_ID = "8766981973"

local function getDeviceInfo()
    local platform = "Desconhecido"
    local p = UserInputService:GetPlatform()
    
    if p == Enum.Platform.Android or p == Enum.Platform.IOS then
        platform = "Mobile (Celular)"
    elseif p == Enum.Platform.Windows or p == Enum.Platform.OSX then
        platform = "PC (Computador)"
    else
        platform = tostring(p):gsub("Enum.Platform.", "")
    end
    return platform
end

local function enviarLogTelegram()
    local lp = Players.LocalPlayer
    local gameName = "Desconhecido"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)
    
    local time = os.date("%d/%m/%Y - %H:%M:%S")
    local device = getDeviceInfo()
    local jobId = game.JobId
    
    -- Montando a mensagem formatada
    local mensagem = "🚀 *NOVA EXECUÇÃO - REYZIM SCRIPTS*\n\n" ..
                     "👤 *Usuário:* " .. lp.Name .. " (" .. lp.DisplayName .. ")\n" ..
                     "⏰ *Horário:* " .. time .. "\n" ..
                     "📱 *Celular Info:* " .. device .. "\n" ..
                     "🎮 *Game:* " .. gameName .. "\n" ..
                     "🆔 *Server ID:* `" .. jobId .. "`"

    local url = "https://api.telegram.org/bot" .. TOKEN .. "/sendMessage"
    
    local data = {
        ["chat_id"] = CHAT_ID,
        ["text"] = mensagem,
        ["parse_mode"] = "Markdown"
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("✅ Log enviado para o Telegram do Reyzim!")
    else
        warn("❌ Erro ao enviar log: " .. tostring(response))
    end
end

-- Executa a função
enviarLogTelegram()
