-- Shadow Detector de Portais | Main Loader
-- by: impedroh | Carrega todos os módulos organizados

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 🧩 Carrega módulos locais
local teleportar = loadstring(readfile("teleport.lua"))()
local webhook = loadstring(readfile("webhook.lua"))()
local detector = loadstring(readfile("detector.lua"))()
local config = loadstring(readfile("config.lua"))()
local historico = loadstring(readfile("historico.lua"))()
local ui = loadstring(readfile("ui.lua"))()

-- 🔁 Salva variáveis globais entre módulos
_G.setWebhook = webhook.set
_G.testWebhook = webhook.test
_G.sendToWebhook = webhook.enviar
_G.toggleAutoTeleport = detector.toggle
_G.updateHistorico = historico.atualizar
_G.historico = historico -- para .pegar()

-- 🚀 Inicializa sistema
task.spawn(detector.iniciar)
ui()
