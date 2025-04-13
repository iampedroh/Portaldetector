-- teleport.lua
local RunService = game:GetService("RunService")

local function teleportToPortal(obj)
    if not obj or not obj:IsA("Part") then return end
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1, 5 do
        hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
        RunService.Heartbeat:Wait()
    end
end

return {
    teleportToPortal = teleportToPortal
}
