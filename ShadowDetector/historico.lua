local historicoRanks = {}

local function adicionarAoHistorico(ilha, rank)
  local hora = os.date("%H:%M:%S")
  table.insert(historicoRanks, 1, string.format("[%s] %s - Rank %s", hora, ilha, rank))
  if #historicoRanks > 5 then
    table.remove(historicoRanks, 6)
  end
  if _G.updateHistorico then
    _G.updateHistorico()
  end
end

local function getHistorico()
  return historicoRanks
end

return {
  adicionar = adicionarAoHistorico,
  pegar = getHistorico
}
