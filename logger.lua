--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TELEGRAM LOG V2           ║
    ║        USANDO REQUEST PARA BYPASS DE BLOQUEIO            ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

-- [ CONFIGURAÇÕES ]
local TOKEN = "8500284543:AAGzMLvtIBmRVPzgMYEo9tdqd2GHoW6TUPI"
local CHAT_ID = "8766981973"

-- Função universal de request para executores (Delta, Fluxus, etc)
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function getDeviceInfo()
    local platform = "Desconhecido"
    pcall(function()
        local p = UserInputService:GetPlatform()
        if p == Enum.Platform.Android or p == Enum.Platform.IOS then
            platform = "Mobile (Celular)"
        elseif p == Enum.Platform.Windows or p == Enum.Platform.OSX then
            platform = "PC (Computador)"
        else
            platform = tostring(p):gsub("Enum.Platform.", "")
        end
    end)
    return platform
end

local function enviarLogTelegram()
    task.spawn(function()
        local lp = Players.LocalPlayer
        local gameName = "Desconhecido"
        
        -- Pega o nome do jogo com segurança
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)
        
        local time = os.date("%d/%m/%Y - %H:%M:%S")
        local device = getDeviceInfo()
        local jobId = game.JobId or "N/A"
        
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
        
        if httpRequest then
            local success, response = pcall(function()
                return httpRequest({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(data)
                })
            end)
            
            if success then
                print("✅ Log enviado com sucesso via Executor Request!")
            else
                warn("❌ Erro ao enviar log via Request: " .. tostring(response))
            end
        else
            warn("❌ Seu executor não suporta a função 'request'.")
        end
    end)
end

-- Executa a função
enviarLogTelegram()
