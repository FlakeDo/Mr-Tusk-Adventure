transition = {}

function triggerTransition(mapId, destx, desty)
    
    gamestate = 1
    player.x = destx
    player.y = desty

    loadMap(mapId)
end