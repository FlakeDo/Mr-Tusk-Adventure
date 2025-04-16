mainMenu = {}

function mainMenu:draw()
    if gamestate == 0 then
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.printf('Press space to start !', love.graphics.getWidth() / 2 - 140, love.graphics.getHeight() / 2 - 40, 150, "center")

    end
end

function mainMenu:select(key)
    if gamestate == 0 then
        if key ~= 'space' then return end

        startFresh(1)

        if data.map and string.len(data.map) > 0 then
            curtain:call(data.map, data.playerx, data.playery)
        end
    end
end