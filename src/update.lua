function updateAll(dt)
    updateGame(dt)
end

function updateGame(dt)

    globalStunUpdate(dt)
    if globalStun > 0 then return end

    flux.update(dt)

    player:update(dt)
    world:update(dt)
    enemies:update(dt)
    -- walls:update(dt)
    if wave then wave:update(dt) end
    
    cam:update(dt)

end