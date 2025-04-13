-- ui.lua
local historico = require("historico")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local function criarInterface(_G)
  local gui = Instance.new("ScreenGui", PlayerGui)
  gui.Name = "ShadowDetectorUI"
  gui.ResetOnSpawn = false

  local dragging, dragInput, dragStart, startPos
  local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
          if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
      end
    end)
    frame.InputChanged:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
      end
    end)
    UserInputService.InputChanged:Connect(function(input)
      if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
      end
    end)
  end

  local main = Instance.new("Frame", gui)
  main.Size = UDim2.new(0, 400, 0, 280)
  main.Position = UDim2.new(0.05, 0, 0.4, 0)
  main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
  main.BorderSizePixel = 0
  main.Visible = true
  makeDraggable(main)

  Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
  Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 170, 255)

  local title = Instance.new("TextLabel", main)
  title.Text = "Shadow Detector de Portais"
  title.Size = UDim2.new(1, 0, 0, 30)
  title.BackgroundTransparency = 1
  title.TextColor3 = Color3.new(1,1,1)
  title.Font = Enum.Font.GothamBold
  title.TextSize = 18
    -- Continuação do ui.lua...

    -- TABS
    local currentTab = "Scanner"
    local tabButtons = {}

    local function switchTab(tabName)
      currentTab = tabName
      for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 100, 180) or Color3.fromRGB(40, 40, 40)
      end
      for _, tab in ipairs(main:GetChildren()) do
        if tab:IsA("Frame") and tab.Name:find("Tab_") then
          tab.Visible = (tab.Name == "Tab_" .. tabName)
        end
      end
    end

    local tabNames = {"Scanner", "Histórico"}
    for i, name in ipairs(tabNames) do
      local btn = Instance.new("TextButton", main)
      btn.Size = UDim2.new(0, 100, 0, 25)
      btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 35)
      btn.Text = name
      btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
      btn.TextColor3 = Color3.new(1,1,1)
      btn.Font = Enum.Font.Gotham
      btn.TextSize = 14
      btn.Name = "TabButton_" .. name
      tabButtons[name] = btn
      btn.MouseButton1Click:Connect(function() switchTab(name) end)
    end

    -- SCANNER TAB
    local tabScanner = Instance.new("Frame", main)
    tabScanner.Name = "Tab_Scanner"
    tabScanner.Position = UDim2.new(0, 0, 0, 70)
    tabScanner.Size = UDim2.new(1, 0, 1, -70)
    tabScanner.BackgroundTransparency = 1

    local webhookBox = Instance.new("TextBox", tabScanner)
    webhookBox.PlaceholderText = "Webhook Discord aqui..."
    webhookBox.Text = ""
    webhookBox.Size = UDim2.new(0.9, 0, 0, 30)
    webhookBox.Position = UDim2.new(0.05, 0, 0, 0)
    webhookBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    webhookBox.TextColor3 = Color3.new(1,1,1)
    webhookBox.TextSize = 14
    webhookBox.Font = Enum.Font.Gotham
    Instance.new("UICorner", webhookBox).CornerRadius = UDim.new(0, 6)

    local saveBtn = Instance.new("TextButton", tabScanner)
    saveBtn.Text = "💾 Salvar Webhook"
    saveBtn.Size = UDim2.new(0.9, 0, 0, 30)
    saveBtn.Position = UDim2.new(0.05, 0, 0, 40)
    saveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
    saveBtn.TextColor3 = Color3.new(1,1,1)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 14
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
    saveBtn.MouseButton1Click:Connect(function()
      if webhookBox.Text ~= "" then
        _G.setWebhook(webhookBox.Text)
      end
    end)

    local toggleBtn = Instance.new("TextButton", tabScanner)
    toggleBtn.Text = "🚀 Iniciar Teleporte Automático"
    toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0.05, 0, 0, 80)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
      active = not active
      toggleBtn.Text = active and "⛔ Parar Teleporte" or "🚀 Iniciar Teleporte Automático"
      _G.toggleAutoTeleport(active)
    end)

    -- HISTÓRICO TAB
    local tabHist = Instance.new("Frame", main)
    tabHist.Name = "Tab_Histórico"
    tabHist.Position = UDim2.new(0, 0, 0, 70)
    tabHist.Size = UDim2.new(1, 0, 1, -70)
    tabHist.BackgroundTransparency = 1
    tabHist.Visible = false

    local histBox = Instance.new("TextBox", tabHist)
    histBox.MultiLine = true
    histBox.TextEditable = false
    histBox.ClearTextOnFocus = false
    histBox.TextWrapped = true
    histBox.TextYAlignment = Enum.TextYAlignment.Top
    histBox.Size = UDim2.new(0.9, 0, 0.7, 0)
    histBox.Position = UDim2.new(0.05, 0, 0, 0)
    histBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    histBox.TextColor3 = Color3.fromRGB(255,255,255)
    histBox.TextSize = 14
    histBox.Font = Enum.Font.Code
    Instance.new("UICorner", histBox).CornerRadius = UDim.new(0, 6)

    local copyBtn = Instance.new("TextButton", tabHist)
    copyBtn.Text = "📋 Copiar Histórico"
    copyBtn.Size = UDim2.new(0.9, 0, 0, 30)
    copyBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 14
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
    copyBtn.MouseButton1Click:Connect(function()
      setclipboard(histBox.Text)
    end)

    -- Atualizar histórico global
    _G.updateHistorico = function()
      local lines = {}
      for _, d in ipairs(historico.pegar()) do
        table.insert(lines, d)
      end
      histBox.Text = table.concat(lines, "\n")
    end

    -- Webhook tester
    local tester = Instance.new("Frame", gui)
    tester.Size = UDim2.new(0, 300, 0, 200)
    tester.Position = UDim2.new(0.4, 0, 0.5, -100)
    tester.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tester.Name = "WebhookTester"
    Instance.new("UICorner", tester).CornerRadius = UDim.new(0, 10)

    local nomeBox = Instance.new("TextBox", tester)
    nomeBox.PlaceholderText = "Nome fictício"
    nomeBox.Size = UDim2.new(0.9, 0, 0, 30)
    nomeBox.Position = UDim2.new(0.05, 0, 0.2, 0)
    nomeBox.Text = "Dungeon Teste"
    nomeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    nomeBox.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", nomeBox)

    local rankBox = Instance.new("TextBox", tester)
    rankBox.PlaceholderText = "Rank (ex: S, A)"
    rankBox.Size = UDim2.new(0.9, 0, 0, 30)
    rankBox.Position = UDim2.new(0.05, 0, 0.45, 0)
    rankBox.Text = "S"
    rankBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    rankBox.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", rankBox)

    local testBtn = Instance.new("TextButton", tester)
    testBtn.Size = UDim2.new(0.9, 0, 0, 30)
    testBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
    testBtn.Text = "📤 Testar Webhook"
    testBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    testBtn.TextColor3 = Color3.new(1,1,1)
    testBtn.Font = Enum.Font.GothamBold
    testBtn.TextSize = 14
    Instance.new("UICorner", testBtn)

    testBtn.MouseButton1Click:Connect(function()
      _G.testWebhook(nomeBox.Text, rankBox.Text)
    end)

    switchTab("Scanner")
  end

return {
    criarInterface = criarInterface,
    makeDraggable = makeDraggable,
    switchTab = switchTab
}
