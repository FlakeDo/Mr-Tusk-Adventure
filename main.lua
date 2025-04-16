function love.load()
    math.randomseed(os.time())

    toggleColliders = false

    require "src/startup/gameStart"
    gameStart()
    createNewSave()

    loadMap('mainMenu')

end



function love.update(dt)
    updateAll(dt)
end



function love.draw()
    drawBeforeCamera()

    cam:attach()
        drawCamera()
    cam:detach()

    drawAfterCamera()
end



function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == 'f11' then
        if isFullscreen then
            newWidth = 1000
            newHeight = 700
            setWindowSize(false, newWidth, newHeight)
        else
            setWindowSize(true)
        end
    end


    if key == 'a' then
        player:roll()
    end

    if key == 'e' then
        player:kick()
    end

    if key == 'r' then
        mx, my = cam:mousePosition()
        spawnEnemy(mx, my, 'droplet')
    end

    -- (Provisoire) Permet de subir -10 HP
    if key == 'b' then
        takeDamage = true
        player.dmg = player.dmg + 10
        player.health = player.health - 10
    end

    -- (Provisoire) Permet de regagner 20 HP
    if key == 'v' then
        recover = true
        heal = 20
    end

    --(PROVISOIRE) Permet de voir/cacher les hitboxes.
    if key == 'h' then
        toggleColliders = not toggleColliders
    end

    mainMenu:select(key)
end


function love.keyreleased(key)

end



function love.mousepressed(x, y, button)
    
end


function love.mousereleased(x, y, button)

end