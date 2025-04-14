local HttpService = game:GetService("HttpService")
local config = _G.config

local module = {}

module.sendToWebhook = function(data)
    if not config.webhookURL or config.webhookURL == "" then return end

    local color = 0x00bfff
    local rank = data.Rank or "???"
    if rank:find("SS") then color = 0xff0000
    elseif rank:find("S") then color = 0xff9900
    elseif rank:find("A") then color = 0xffff00
    elseif rank:find("B") then color = 0x00ffcc
    elseif rank:find("C") then color = 0x3399ff
    elseif rank:find("D") then color = 0xbbbbff
    elseif rank:find("E") then color = 0xaaaaaa end

    local embed = {
        ["title"] = "🏴 Dungeon Encontrada!",
        ["description"] = string.format("📍 **Nome:** %s\n🏅 **Rank:** %s\n🕒 **Detectado:** %s",
            data.Nome or "???",
            rank,
            os.date("%d/%m/%Y %H:%M:%S")
        ),
        ["color"] = color,
        ["footer"] = { ["text"] = "Shadow Detector de Portais by: impedroh" }
    }

    local payload = {
        ["embeds"] = { embed },
        ["content"] = "<@&1358986277503897691>" .. ((rank:find("S")) and " <@&1358986026986504222>" or "")
    }

    local req = http_request or syn.request or request
    if req then
        req({
            Url = config.webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end
end

module.setWebhook = function(url)
    config.webhookURL = url
    if writefile then pcall(function() writefile("dungeon_webhook.txt", url) end) end
end

module.testWebhook = function(nome, rank)
    module.sendToWebhook({ Nome = nome or "Dungeon Teste", Rank = rank or "A" })
end

return module
