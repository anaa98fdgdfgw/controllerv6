-- Installer simple pour ReactorController (sans Pastebin)
-- Place les fichiers nécessaires et configure le startup

print("Installation du ReactorController...")

-- Vérifier que les fichiers nécessaires sont présents
local requiredFiles = {
    "reactorController.lua",
    "touchpoint.lua"
}

local missingFiles = {}
for _, file in ipairs(requiredFiles) do
    if not fs.exists(file) then
        table.insert(missingFiles, file)
    end
end

if #missingFiles > 0 then
    print("ERREUR: Fichiers manquants:")
    for _, file in ipairs(missingFiles) do
        print("  - " .. file)
    end
    print("Veuillez placer tous les fichiers nécessaires avant l'installation.")
    return
end

-- Créer le fichier startup
local file = fs.open("startup.lua", "w")
file.writeLine("-- Startup automatique pour ReactorController")
file.writeLine("print(\"Démarrage du ReactorController...\")")
file.writeLine("")
file.writeLine("while true do")
file.writeLine("    local success, error = pcall(function()")
file.writeLine("        shell.run(\"reactorController.lua\")")
file.writeLine("    end)")
file.writeLine("    ")
file.writeLine("    if not success then")
file.writeLine("        print(\"Erreur: \" .. tostring(error))")
file.writeLine("        print(\"Redémarrage dans 5 secondes...\")")
file.writeLine("        sleep(5)")
file.writeLine("    else")
file.writeLine("        sleep(2)")
file.writeLine("    end")
file.writeLine("end")
file.close()

print("Installation terminée!")
print("Le ReactorController démarrera automatiquement au prochain redémarrage.")
print("Pour démarrer maintenant: shell.run('startup.lua')")