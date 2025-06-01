local version = "1.0"
local tag = "multiControllerConfig"

-- Import touchpoint API
dofile("/usr/apis/touchpoint.lua")

-- =================== GLOBAL VARIABLES ===================
local mon, monSide
local sizex, sizey
local t -- touchpoint instance
local currentPage = "home" -- Page actuelle
local navBarHeight = 4 -- Hauteur de la barre de navigation

-- Pages disponibles
local pages = {
    { id = "home", name = "Home", color = colors.blue },
    { id = "reactor", name = "Reactor", color = colors.green },
    { id = "storage", name = "Storage", color = colors.orange },
    { id = "power", name = "Power", color = colors.red }
}

-- =================== UTILITY FUNCTIONS ===================

-- Dessiner une boîte
local function drawBox(size, xoff, yoff, color)
    if (monSide == nil) then return end
    local x,y = mon.getCursorPos()
    mon.setBackgroundColor(color)
    local horizLine = string.rep(" ", size[1])
    mon.setCursorPos(xoff + 1, yoff + 1)
    mon.write(horizLine)
    mon.setCursorPos(xoff + 1, yoff + size[2])
    mon.write(horizLine)

    for i=0, size[2] - 1 do
        mon.setCursorPos(xoff + 1, yoff + i + 1)
        mon.write(" ")
        mon.setCursorPos(xoff + size[1], yoff + i +1)
        mon.write(" ")
    end
    mon.setCursorPos(x,y)
    mon.setBackgroundColor(colors.black)
end

-- Dessiner une boîte remplie
local function drawFilledBox(size, xoff, yoff, colorOut, colorIn)
    if (monSide == nil) then return end
    local horizLine = string.rep(" ", size[1] - 2)
    drawBox(size, xoff, yoff, colorOut)
    local x,y = mon.getCursorPos()
    mon.setBackgroundColor(colorIn)
    for i=2, size[2] - 1 do
        mon.setCursorPos(xoff + 2, yoff + i)
        mon.write(horizLine)
    end
    mon.setBackgroundColor(colors.black)
    mon.setCursorPos(x,y)
end

-- Dessiner du texte
local function drawText(text, x1, y1, backColor, textColor)
    if (monSide == nil) then return end
    local x, y = mon.getCursorPos()
    mon.setCursorPos(x1, y1)
    mon.setBackgroundColor(backColor)
    mon.setTextColor(textColor)
    mon.write(text)
    mon.setTextColor(colors.white)
    mon.setBackgroundColor(colors.black)
    mon.setCursorPos(x,y)
end

-- Réinitialiser le moniteur
local function resetMon()
    if (monSide == nil) then return end
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setTextScale(0.5)
    mon.setCursorPos(1,1)
end

-- =================== NAVIGATION SYSTEM ===================

-- Changer de page
local function switchToPage(pageId)
    currentPage = pageId
    resetMon()
    drawScene()
end

-- Dessiner la barre de navigation fixe en bas
local function drawNavigationBar()
    if (monSide == nil) then return end
    
    local navY = sizey - navBarHeight + 1
    local buttonWidth = math.floor(sizex / #pages)
    local startX = math.floor((sizex - (buttonWidth * #pages)) / 2) + 1
    
    -- Fond de la barre de navigation
    drawFilledBox({sizex, navBarHeight}, 0, navY - 1, colors.gray, colors.lightGray)
    
    -- Dessiner les boutons de navigation
    for i, page in ipairs(pages) do
        local buttonX = startX + (i - 1) * buttonWidth
        local isActive = (currentPage == page.id)
        local bgColor = isActive and page.color or colors.gray
        local textColor = isActive and colors.white or colors.black
        
        -- Dessiner le bouton
        drawFilledBox({buttonWidth - 1, navBarHeight - 2}, buttonX - 1, navY, 
                     bgColor, bgColor)
        
        -- Centrer le texte dans le bouton
        local textX = buttonX + math.floor((buttonWidth - #page.name) / 2)
        drawText(page.name, textX, navY + 1, bgColor, textColor)
    end
end

-- Ajouter les boutons de navigation
local function addNavigationButtons()
    if (monSide == nil) then return end
    
    local navY = sizey - navBarHeight + 1
    local buttonWidth = math.floor(sizex / #pages)
    local startX = math.floor((sizex - (buttonWidth * #pages)) / 2) + 1
    
    for i, page in ipairs(pages) do
        local buttonX = startX + (i - 1) * buttonWidth
        
        t:add(page.id .. "_nav", 
              function() switchToPage(page.id) end,
              buttonX, navY,
              buttonX + buttonWidth - 1, navY + navBarHeight - 2,
              colors.gray, page.color)
    end
end

-- =================== PAGE CONTENT ===================

-- Page principale (vide pour l'instant)
local function drawHomePage()
    local contentHeight = sizey - navBarHeight - 2
    
    -- Titre de la page
    drawBox({sizex - 2, 4}, 1, 1, colors.blue)
    drawText(" Multi-Controller Dashboard ", 3, 3, colors.black, colors.blue)
    
    -- Zone de contenu principale (vide pour l'instant)
    drawBox({sizex - 2, contentHeight - 6}, 1, 6, colors.lightBlue)
    drawText(" Page principale - Contenu à venir ", 3, 8, colors.black, colors.lightBlue)
    
    -- Message d'information
    local infoY = math.floor(contentHeight / 2) + 3
    drawText("Cette page sera remplie plus tard", math.floor(sizex/2) - 15, infoY, 
             colors.black, colors.cyan)
end

-- Page réacteur (placeholder pour l'instant)
local function drawReactorPage()
    local contentHeight = sizey - navBarHeight - 2
    
    drawBox({sizex - 2, 4}, 1, 1, colors.green)
    drawText(" Reactor Controller ", 3, 3, colors.black, colors.green)
    
    drawBox({sizex - 2, contentHeight - 6}, 1, 6, colors.lightGreen)
    drawText(" Interface réacteur sera intégrée ici ", 3, 8, colors.black, colors.lightGreen)
end

-- Page stockage (placeholder)
local function drawStoragePage()
    local contentHeight = sizey - navBarHeight - 2
    
    drawBox({sizex - 2, 4}, 1, 1, colors.orange)
    drawText(" Storage Management ", 3, 3, colors.black, colors.orange)
    
    drawBox({sizex - 2, contentHeight - 6}, 1, 6, colors.yellow)
    drawText(" Gestion du stockage - À implémenter ", 3, 8, colors.black, colors.yellow)
end

-- Page énergie (placeholder)
local function drawPowerPage()
    local contentHeight = sizey - navBarHeight - 2
    
    drawBox({sizex - 2, 4}, 1, 1, colors.red)
    drawText(" Power Management ", 3, 3, colors.black, colors.red)
    
    drawBox({sizex - 2, contentHeight - 6}, 1, 6, colors.pink)
    drawText(" Gestion de l'énergie - À implémenter ", 3, 8, colors.black, colors.pink)
end

-- Dessiner le contenu selon la page actuelle
local function drawPageContent()
    if currentPage == "home" then
        drawHomePage()
    elseif currentPage == "reactor" then
        drawReactorPage()
    elseif currentPage == "storage" then
        drawStoragePage()
    elseif currentPage == "power" then
        drawPowerPage()
    end
end

-- =================== MAIN DRAWING FUNCTION ===================

-- Dessiner toute la scène
function drawScene()
    if (monSide == nil) then return end
    
    -- Dessiner le contenu de la page
    drawPageContent()
    
    -- Dessiner la barre de navigation (toujours en bas)
    drawNavigationBar()
    
    -- Dessiner les boutons
    t:draw()
end

-- =================== INITIALIZATION ===================

-- Détecter le périphérique
local function getPeripheral(name)
    for i,v in pairs(peripheral.getNames()) do
        if (peripheral.getType(v) == name) then
            return v
        end
    end
    return ""
end

-- Initialiser le moniteur
local function initMon()
    monSide = getPeripheral("monitor")
    if (monSide == nil or monSide == "") then
        monSide = nil
        return
    end

    mon = peripheral.wrap(monSide)
    if mon == nil then
        monSide = nil
        return
    end

    resetMon()
    t = touchpoint.new(monSide)
    sizex, sizey = mon.getSize()
    
    -- Ajouter les boutons de navigation
    addNavigationButtons()
end

-- =================== MAIN LOOP ===================

local function loop()
    local function handleClick(event)
        if (event[1] == "button_click") then
            t.buttonList[event[2]].func()
            resetMon()
            drawScene()
        end
    end
    
    local function handleResize(event)
        if (event[1] == "monitor_resize") then
            initMon()
            resetMon()
            drawScene()
        end
    end
    
    while true do
        local event = (monSide == nil) and { os.pullEvent() } or { t:handleEvents() }
        
        handleClick(event)
        handleResize(event)
    end
end

-- =================== ENTRY POINT ===================

local function main()
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    
    print("Multi-Controller Version "..version)
    print("Initializing monitor...")
    
    initMon()
    
    if monSide == nil then
        print("No monitor detected! Running in terminal mode...")
        print("Current page: " .. currentPage)
        while true do
            sleep(1)
        end
    else
        print("Monitor initialized! Starting interface...")
        sleep(1)
        resetMon()
        drawScene()
        loop()
    end
end

main()