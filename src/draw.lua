function drawBeforeCamera()
    mainMenu:draw()
end



function drawCamera()

    if gamestate == 0 then return end

    if gameMap.layers['ground z = 0'] then
        gameMap:drawLayer(gameMap.layers['ground z = 0'])
    end

    if gameMap.layers['details'] then
        gameMap:drawLayer(gameMap.layers['details'])
    end

    for _,foe in ipairs(enemies) do
        if foe.weakspot then
            --wsx, wsy = vector.fromPolar(foe.weakspotStart, 100):unpack()
            --wex, wey = vector.fromPolar(foe.weakspotEnd, 100):unpack()
            ex, ey = foe.collider:getPosition()
            love.graphics.setColor(1, 0, 0)
            --love.graphics.line(ex, ey, ex - wsx, ey - wsy)
            --love.graphics.line(ex, ey, ex - wex, ey - wey)
            love.graphics.arc('line', 'open', ex, ey, 25, foe.weakspotStart + math.pi, foe.weakspotEnd + math.pi)
            love.graphics.setColor(1, 1, 1)
        end
    end
    enemies:draw()
    wave:draw()

    if gameMap.layers['ground z = 1'] then
        gameMap:drawLayer(gameMap.layers['ground z = 1'])
    end

    if gameMap.layers['ground z = 2'] then
        gameMap:drawLayer(gameMap.layers['ground z = 2'])
    end

    if gameMap.layers['details z = 2'] then
        gameMap:drawLayer(gameMap.layers['details z = 2'])
    end

    if gameMap.layers['ground z = 3'] then
        gameMap:drawLayer(gameMap.layers['ground z = 3'])
    end

    player:draw()
    
    if toggleColliders then world:draw() end
end



function drawAfterCamera()

    if gamestate == 0 then return end
    love.graphics.print(player.x, 0, 120)
    love.graphics.print(player.y, 0, 160)
    drawHUD()
end