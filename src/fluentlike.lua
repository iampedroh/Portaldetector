
local FluentLike = {}
FluentLike.__index = FluentLike

function FluentLike.new(frame)
    local self = setmetatable({}, FluentLike)
    self.Frame = frame
    self.Elements = {}
    return self
end

function FluentLike:AddButton(config)
    local button = Instance.new("TextButton")
    button.Name = config.Name or config.Title:gsub(" ", "")
    button.Text = config.Title
    button.Size = UDim2.new(0, 200, 0, 30)
    button.Position = UDim2.new(0, 10, 0, #self.Elements * 35 + 10)
    button.Parent = self.Frame
    button.MouseButton1Click:Connect(config.Callback)
    table.insert(self.Elements, button)
    return button
end

function FluentLike:AddToggle(config)
    local toggle = Instance.new("TextButton")
    toggle.Name = config.Name or config.Title:gsub(" ", "")
    toggle.Text = config.Title .. ": OFF"
    toggle.Size = UDim2.new(0, 200, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, #self.Elements * 35 + 10)
    toggle.Parent = self.Frame

    local state = config.Default or false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = config.Title .. ": " .. (state and "ON" or "OFF")
        if config.Callback then config.Callback(state) end
    end)

    table.insert(self.Elements, toggle)
    return toggle
end

return FluentLike
