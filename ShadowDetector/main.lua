-- Shadow Detector de Portais | Main Loader
-- by: impedroh | Carrega todos os módulos organizados diretamente do GitHub

local teleportar = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampedroh/Portaldetector/main/ShadowDetector/teleport.lua"))()
local webhook = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampedroh/Portaldetector/main/ShadowDetector/webhook.lua"))()
local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampedroh/Portaldetector/main/ShadowDetector/config.lua"))()
local historico = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampedroh/Portaldetector/main/ShadowDetector/historico.lua"))()
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampedroh/Portaldetector/main/ShadowDetector/ui.lua"))()

-- 🌐 Salva variáveis globais entre módulos
_G.setWebhook = webhook.set
_G.testWebhook = webhook.test
_G.sendToWebhook = webhook.enviar
_G.updateHistorico = historico.atualizar
_G.historico = historico

-- 🚀 Inicializa sistema
-- task.spawn(detector.iniciar) -- REMOVIDO: detector.lua não existe
ui()

