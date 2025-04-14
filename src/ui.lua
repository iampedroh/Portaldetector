
local FluentLike = require(script.Parent.fluentlike)

local Abas = {"Principal", "Ranking", "Detector", "Webhook", "Testes", "Infos Jogo", "nada"}
local Player = game.Players.LocalPlayer
local Gui = Player:WaitForChild("PlayerGui"):WaitForChild("UIbonita")
local MainFrame = Gui:WaitForChild("MainFrame")

local Tabs = {}

for _, nome in ipairs(Abas) do
    local frame = MainFrame:FindFirstChild(nome .. "Frame")
    local botao = MainFrame:FindFirstChild("Btn" .. nome:gsub(" ", ""))
    if frame and botao then
        local aba = FluentLike.new(frame)
        Tabs[nome] = aba

        botao.MouseButton1Click:Connect(function()
            for _, other in pairs(MainFrame:GetChildren()) do
                if other:IsA("Frame") and other.Name:match("Frame$") then
                    other.Visible = false
                end
            end
            frame.Visible = true

            local ok, fn = pcall(function()
                return require(script.Parent.pages[nome:lower():gsub(" ", "")])
            end)
            if ok and fn then
                fn(aba)
            end
        end)
    end
end

MainFrame:FindFirstChild("PrincipalFrame").Visible = true
require(script.Parent.pages.principal)(Tabs["Principal"])

return Tabs
