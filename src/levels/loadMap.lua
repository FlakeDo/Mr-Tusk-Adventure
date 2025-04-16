function loadMap(mapName, destX, destY)
    --destroyAll()

    if destX and destY then
        player:setPosition(destX, destY)
    end

    loadedMap = mapName
    gameMap = sti('maps/' .. mapName .. '.lua')

    if gameMap.layers['walls'] then
        for i, obj in pairs(gameMap.layers['walls'].objects) do
            spawnWalls(obj.x, obj.y, obj.width, obj.height, obj.name, obj.type)
        end
    end

    if gameMap.layers['wave'] then
        -- waveObj = gameMap.layers['wave'].objects
        for i, obj in pairs(gameMap.layers['wave'].objects) do
            waveInit(obj.x, obj.y, obj.width, obj.height, obj.name, obj.type)
        end
        
    end

    if #enemies == 0 then
        spawnEnemy(1000, 384, 'droplet')
    end
end