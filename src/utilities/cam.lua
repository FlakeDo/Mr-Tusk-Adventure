camera = require "libraries/hump/camera"
cam = camera(0, 0, scale)

function cam:update(dt)
    local camX, camY = player:getPosition()

    -- On réccupère les dimensions de la fenetre :
    local windowW = love.graphics.getWidth() / scale
    local windowH = love.graphics.getHeight() / scale

    -- Puis les dimensions de la carte chargée :
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Bord gauche :
    if camX < windowW / 2 then
        camX = windowW / 2
    end

    -- Bord droit :
    if camX > (mapW - windowW / 2 - 200) then
        camX = (mapW - windowW / 2 - 200)
    end

    -- Bord haut :
    if camY < windowH / 2 then
        camY = windowH / 2
    end

    -- Bord bas :
    if camY > (mapH - windowH / 2) then
        camY = (mapH - windowH / 2)
    end

    -- La camera est bloquée sur la position du joueur.
    cam:lockPosition(camX, camY)

    -- Les deux variables suivantes contiennent la position de la camera en cas de besoin.
    cam.x, cam.y = cam:position()
end