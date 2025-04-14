return function()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local player = Players.LocalPlayer
    local gui = player:WaitForChild("PlayerGui")

    local savedWebhooks = isfile("guild_webhooks.json") and HttpService:JSONDecode(readfile("guild_webhooks.json")) or {}

    local screen = Instance.new("ScreenGui", gui)
    screen.Name = "GuildRankingPanel"
    screen.ResetOnSpawn = false

    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(0, 450, 0, 300)
    frame.Position = UDim2.new(0.5, -225, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Text = "🏆 Enviar Rank da Guilda
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20

    local abaWebhooks = Instance.new("Frame", frame)
    abaWebhooks.Size = UDim2.new(1, -20, 0, 180)
    abaWebhooks.Position = UDim2.new(0, 10, 0, 40)
    abaWebhooks.BackgroundTransparency = 1

    local webhookBox = Instance.new("TextBox", abaWebhooks)
    webhookBox.PlaceholderText = "Cole a URL da Webhook"
    webhookBox.Size = UDim2.new(0.65, -5, 0, 30)
    webhookBox.Position = UDim2.new(0, 0, 0, 0)
    webhookBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    webhookBox.TextColor3 = Color3.new(1, 1, 1)
    webhookBox.ClearTextOnFocus = false

    local nomeBox = Instance.new("TextBox", abaWebhooks)
    nomeBox.PlaceholderText = "Nome"
    nomeBox.Size = UDim2.new(0.35, -5, 0, 30)
    nomeBox.Position = UDim2.new(0.65, 5, 0, 0)
    nomeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    nomeBox.TextColor3 = Color3.new(1, 1, 1)
    nomeBox.ClearTextOnFocus = false

    local salvarBtn = Instance.new("TextButton", abaWebhooks)
    salvarBtn.Text = "Salvar Webhook"
    salvarBtn.Size = UDim2.new(1, 0, 0, 30)
    salvarBtn.Position = UDim2.new(0, 0, 0, 40)
    salvarBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    salvarBtn.TextColor3 = Color3.new(1, 1, 1)

    local botoesFrame = Instance.new("Frame", abaWebhooks)
    botoesFrame.Position = UDim2.new(0, 0, 0, 80)
    botoesFrame.Size = UDim2.new(1, 0, 1, -90)
    botoesFrame.BackgroundTransparency = 1

    local uiList = Instance.new("UIListLayout", botoesFrame)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 5)

    local function enviarRank(webhook)
        local root = gui:FindFirstChild("__Disable") or gui:FindFirstChild("_Disable") or gui
        local listaGuilda = root:FindFirstChild("Menus")
        if not listaGuilda then return end

        local playerList = listaGuilda:FindFirstChild("Guilds"):FindFirstChild("PlayerList"):FindFirstChild("List")
        if not playerList then return end

        local jogadores = {}

        for _, id in pairs(playerList:GetChildren()) do
            local main = id:FindFirstChild("Main")
            if main and not string.find(main.Name, "hypesubs") then
                local nomeObj = main:FindFirstChild("PlayerName")
                local gemsObj = main:FindFirstChild("GemsLabel") and main:FindFirstChild("GemsLabel"):FindFirstChild("Value")
                local expObj = main:FindFirstChild("ExpLabel") and main:FindFirstChild("ExpLabel"):FindFirstChild("Value")

                local nome = nomeObj and nomeObj.Text or "???"
                local gems = gemsObj and gemsObj.Text or "0"
                local exp = expObj and expObj.Text or "0"

                table.insert(jogadores, {
                    nome = nome,
                    gemas = gems,
                    exp = exp
                })
            end
        end

        local function formatar(n)
            return "`" .. tostring(n) .. "`"
        end

        local function getEmoji(i)
            return ({ "🥇", "🥈", "🥉" })[i] or "💠"
        end

        table.sort(jogadores, function(a, b)
            return tonumber(a.gemas:match("%d+")) > tonumber(b.gemas:match("%d+"))
        end)

        local gemsText = {}
        for i, j in ipairs(jogadores) do
            table.insert(gemsText, string.format("%s %s — 💎 %s", getEmoji(i), j.nome, formatar(j.gemas)))
        end

        table.sort(jogadores, function(a, b)
            return tonumber(a.exp) > tonumber(b.exp)
        end)

        local expText = {}
        for i, j in ipairs(jogadores) do
            table.insert(expText, string.format("%s %s — 🧪 %s", getEmoji(i), j.nome, formatar(j.exp)))
        end

        local data = os.date("*t")
        local hora = string.format("%02d:%02d:%02d", data.hour, data.min, data.sec)
        local dataStr = string.format("%02d/%02d/%04d", data.day, data.month, data.year)
        local footerText = "Última atualização do rank - " .. dataStr .. " às " .. hora

        local payload = {
            embeds = {
                {
                    title = "💎 Top Donos de Gemas",
                    description = table.concat(gemsText, "\n"),
                    color = 0x00ffcc,
                    footer = { text = footerText }
                },
                {
                    title = "🧪 Top Experiência",
                    description = table.concat(expText, "\n"),
                    color = 0xffcc00,
                    footer = { text = footerText }
                }
            }
        }

        http_request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end

    local function atualizarBotoes()
        for _, v in pairs(botoesFrame:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end

        for nome, link in pairs(savedWebhooks) do
            local btn = Instance.new("TextButton", botoesFrame)
            btn.Text = "Enviar para: " .. nome
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.MouseButton1Click:Connect(function()
                enviarRank(link)
            end)
        end
    end

    salvarBtn.MouseButton1Click:Connect(function()
        local nome = nomeBox.Text
        local url = webhookBox.Text
        if nome ~= "" and url ~= "" then
            savedWebhooks[nome] = url
            writefile("guild_webhooks.json", HttpService:JSONEncode(savedWebhooks))
            atualizarBotoes()
        end
    end)

    atualizarBotoes()

    local minimizar = Instance.new("TextButton", frame)
    minimizar.Text = "-"
    minimizar.Size = UDim2.new(0, 30, 0, 30)
    minimizar.Position = UDim2.new(1, -30, 0, 0)
    minimizar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizar.TextColor3 = Color3.new(1, 1, 1)

    local botaoAbrir = Instance.new("TextButton", screen)
    botaoAbrir.Text = "📋"
    botaoAbrir.Size = UDim2.new(0, 40, 0, 40)
    botaoAbrir.Position = UDim2.new(0, 10, 1, -50)
    botaoAbrir.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    botaoAbrir.TextColor3 = Color3.new(1, 1, 1)
    botaoAbrir.Visible = false

    minimizar.MouseButton1Click:Connect(function()
        frame.Visible = false
        botaoAbrir.Visible = true
    end)

    botaoAbrir.MouseButton1Click:Connect(function()
        frame.Visible = true
        botaoAbrir.Visible = false
    end)
end
