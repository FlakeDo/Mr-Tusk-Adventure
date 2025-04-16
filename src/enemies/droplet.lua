local function initDroplet(enemy, x, y)
    enemy.collider = world:newCircleCollider(x, y, 15)
    enemy.collider:setCollisionClass('Enemy')
    enemy.collider:setFixedRotation(true)
    enemy.collider:setLinearDamping(2)
    enemy.collider.parent = enemy

    enemy.form = 1
    enemy.sprite = sprites.enemies.dropletIner
    enemy.aura = sprites.enemies.dropletOuter

    enemy.health = 5
    enemy.prize = 10 -- Le nombre de points accordé au joueur en cas de victoire sur l'ennemi.
    enemy.speed = 0
    enemy.maxSpeed = 400
    enemy.damage = 10
    enemy.magnitude = 500
    enemy.dir = vector(0,1)

    enemy.weakspot = false
    enemy.weakspotFreq = 5 -- Le temps entre d'attente entre deux points faibles.
    enemy.weakspotTimer = enemy.weakspotFreq
    enemy.weakspotStart = 0 -- Contient l'angle défini aléatoirement lors de l'initialisation du point faible.
    enemy.weakspotEnd = 0 -- Contient l'angle défini par weakspotStart + la valeur de tolérance du point faible.

    enemy.spriteGrid = anim8.newGrid(32, 32, enemy.sprite:getWidth(), enemy.sprite:getHeight())
    enemy.auraGrid = anim8.newGrid(32, 32, enemy.aura:getWidth(), enemy.aura:getHeight())

    enemy.animations = {}
    enemy.animations.neutral = anim8.newAnimation(enemy.spriteGrid('1-2', 1), 0.2)
    enemy.animations.hurt = anim8.newAnimation(enemy.spriteGrid('3-4', 1), 0.2)

    enemy.animations.auraNeutral = anim8.newAnimation(enemy.auraGrid('1-2', 1), 0.2)
    enemy.animations.auraHurt = anim8.newAnimation(enemy.auraGrid('3-4', 1), 0.2)
    enemy.anim = enemy.animations.neutral
    enemy.auraAnim = enemy.animations.auraNeutral

    function enemy:update(dt)
        enemy:movePattern(dt)

        if enemy.weakspotTimer > 0 and not enemy.weakspot then
            enemy.weakspotTimer = enemy.weakspotTimer - dt
        end
        if enemy.weakspotTimer < 0 then
            local variation = math.random()
            enemy.weakspotTimer = enemy.weakspotFreq + 4 * variation - 2
            enemy:initWeakSpot()
        end
    end
    
    function enemy:draw()
        ex, ey = enemy.collider:getPosition()
        love.graphics.draw(sprites.enemies.shadow, ex, ey + 20, nil, nil, nil, 16, 16)
        enemy.auraAnim:draw(enemy.aura, ex, ey, nil, 1, 1, 16, 16)
        enemy.anim:draw(enemy.sprite, ex, ey, nil, 1, 1, 16, 16)
    end

    return enemy

end

return initDroplet
