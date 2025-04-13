-- coletar_info.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local function coletarInfoDungeon()
    local gui = PlayerGui:FindFirstChild("Dungeon")
    if not gui then return nil end

    local info = { Nome = "Desconhecido", Rank = "???" }
    for _, desc in ipairs(gui:GetDescendants()) do
        if desc:IsA("TextLabel") then
            if desc.Text:find("RANK") then
                info.Rank = desc.Text
            elseif desc.Text:find("Dungeon") then
                info.Nome = desc.Text
            end
        end
    end
    return info
end

return {
    coletarInfoDungeon = coletarInfoDungeon
}
