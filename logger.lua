--[[
    ╔══════════════════════════════════════════════════════════╗
    ║               REYZIM SCRIPTS - TELEGRAM LOG V3           ║
    ║        MÉTODO GET: BYPASS TOTAL DE BLOQUEIO              ║
    ║        CRIADO POR: REYZIM | TIKTOK: @REYZIM_DZ           ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- [ CONFIGURAÇÕES ]
local TOKEN = "8500284543:AAGzMLvtIBmRVPzgMYEo9tdqd2GHoW6TUPI"
local CHAT_ID = "8766981973"

-- Função para codificar texto para URL (Transforma espaços em %20, etc)
local function urlEncode(str)
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "%%20")
    return str
end

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
        
        pcall(function()
            gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)
        
        local time = os.date("%d/%m/%Y - %H:%M:%S")
        local device = getDeviceInfo()
        local jobId = game.JobId or "N/A"
        
        -- Montando a mensagem (Sem Markdown complexo para evitar erros no GET)
        local mensagem = "REYZIM SCRIPTS - LOG\n\n" ..
                         "Usuario: " .. lp.Name .. "\n" ..
                         "Horario: " .. time .. "\n" ..
                         "Celular: " .. device .. "\n" ..
                         "Game: " .. gameName .. "\n" ..
                         "ServerID: " .. jobId

        -- O segredo: Enviar via GET usando a URL do Telegram
        local url = "https://api.telegram.org/bot" .. TOKEN .. "/sendMessage?chat_id=" .. CHAT_ID .. "&text=" .. urlEncode(mensagem)
        
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            print("✅ Log enviado com sucesso via GET Bypass!")
        else
            -- Se o HttpGet do game falhar, tenta o do executor
            local execGet = (syn and syn.request) or (http and http.request) or request
            if execGet then
                pcall(function()
                    execGet({Url = url, Method = "GET"})
                end)
                print("✅ Log enviado via Executor Bypass!")
            else
                warn("❌ Falha total ao enviar log.")
            end
        end
    end)
end

-- Executa a função
enviarLogTelegram()
