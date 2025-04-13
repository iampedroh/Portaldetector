-- abrir_menu.lua
local function abrirMenuPortal(obj)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then fireproximityprompt(prompt) end
end

return {
    abrirMenuPortal = abrirMenuPortal
}
