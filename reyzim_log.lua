--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TELEGRAM LOG V4           ║
    ║        ARQUIVO NOVO: BYPASS TOTAL DE CACHE E REDE        ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

print("[REYZIM LOG V4] - Iniciando envio...")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

-- [ CONFIGURAÇÕES ]
local TOKEN = "8500284543:AAGzMLvtIBmRVPzgMYEo9tdqd2GHoW6TUPI"
local CHAT_ID = "8766981973"

-- Detecta a função de request do executor (Delta/Fluxus/etc)
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
        local lp = Players.LocalPlayer
        local gameName = "Desconhecido"
        
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)
        
        local time = os.date("%d/%m/%Y - %H:%M:%S")
        local device = "Mobile (Delta)"
        local jobId = game.JobId or "N/A"
        
        local mensagem = "🚀 *NOVA EXECUÇÃO - REYZIM SCRIPTS*\n\n" ..
                         "👤 *Usuário:* " .. lp.Name .. " (" .. lp.DisplayName .. ")\n" ..
                         "⏰ *Horário:* " .. time .. "\n" ..
                         "📱 *Celular Info:* " .. device .. "\n" ..
                         "🎮 *Game:* " .. gameName .. "\n" ..
                         "🆔 *Server ID:* `" .. jobId .. "`"

        -- URL de envio
        local url = "https://api.telegram.org/bot" .. TOKEN .. "/sendMessage?chat_id=" .. CHAT_ID .. "&text=" .. urlEncode(mensagem) .. "&parse_mode=Markdown"
        
        -- Tenta primeiro com a função do EXECUTOR (Mais segura contra bloqueios)
        if requestFunc then
            local success, response = pcall(function()
                return requestFunc({
                    Url = url,
                    Method = "GET"
                })
            end)
            
            if success then
                print("[REYZIM LOG V4] ✅ Log enviado via Executor Request!")
                return
            end
        end
        
        -- Se falhar ou não existir, tenta o HttpGet do jogo como última opção
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            print("[REYZIM LOG V4] ✅ Log enviado via Game HttpGet!")
        else
            warn("[REYZIM LOG V4] ❌ Falha crítica no envio.")
        end
    end)
end

enviarLogTelegram()
