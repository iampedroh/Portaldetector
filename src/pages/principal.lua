
return function(tab)
    tab:AddButton({
        Title = "Executar Ação",
        Callback = function()
            print("Ação executada na aba Principal")
        end
    })

    tab:AddToggle({
        Title = "Modo Turbo",
        Default = false,
        Callback = function(state)
            print("Modo Turbo:", state)
        end
    })
end
