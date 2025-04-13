-- 🌌 Shadow Detector de Portais | Loader Oficial
local REPO = "https://raw.githubusercontent.com/SEU_USUARIO/seu-repo/main/"

local arquivos = {
    teleport = "teleport.lua",
    abrir_menu = "abrir_menu.lua",
    coletar_info = "coletar_info.lua",
    webhook = "webhook.lua",
    historico = "historico.lua",
    config = "config.lua",
    main = "main.lua"
}

for nome, caminho in pairs(arquivos) do
    local url = REPO .. caminho
    local success, result = pcall(function()
        local scriptCode = game:HttpGet(url)
        local module = loadstring(scriptCode)()
        getgenv()[nome] = module
    end)
    if success then
        print("✅ Módulo carregado:", nome)
    else
        warn("❌ Erro ao carregar:", nome, "->", result)
    end
end

if main then
    print("🚀 Executando script principal...")
    main()
end