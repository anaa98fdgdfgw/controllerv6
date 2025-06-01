-- Startup simple pour ReactorController
-- Démarre automatiquement le contrôleur de réacteur

print("Démarrage du ReactorController...")

-- Boucle principale pour redémarrer en cas de crash
while true do
    local success, error = pcall(function()
        shell.run("reactorController.lua")
    end)
    
    if not success then
        print("Erreur détectée: " .. tostring(error))
        print("Redémarrage dans 5 secondes...")
        sleep(5)
    else
        print("Programme fermé normalement. Redémarrage dans 2 secondes...")
        sleep(2)
    end
end