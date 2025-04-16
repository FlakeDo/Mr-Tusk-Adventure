player = world:newCircleCollider(384, 3392, 25)
player.speed = 13000
player.x = 0 
player.y = 0 
player.walking = false
player.dirX = 1
player.dirY = 1
player.animSpeed = 0.075
player.health = 90
player.healthVisual = player.health
player.immunityTimer = 0
player.animTimer = 0
player.rollDelayTimer = 0
player.rollDir = 1
player.kickDelayTimer = 0
player.kickLR = 1
player.kickDir = vector(0, 1)
player.range = 35
player.dmg = 0
player.stunTimer = 0
player.flashTimer = 0
player.flashBool = 1

player.score = 0
player.combo = 0

angleToFoe = 0

-- Etats que peut avoir le joueur :
-- 0 : Normal
-- 0.1 : Roll
-- 1 : Kick
-- 10 : Damage stun
-- 12 : Transition
player.state = 0

player:setCollisionClass('Player')
player:setFixedRotation(true)

player.grid = anim8.newGrid(64, 64, sprites.MTusk:getWidth(), sprites.MTusk:getHeight())

player.animations = {}
player.animations.down = anim8.newAnimation(player.grid('1-8', 1), player.animSpeed)
player.animations.up = anim8.newAnimation(player.grid('1-8', 2), player.animSpeed)
player.animations.idleDown = anim8.newAnimation(player.grid('1-4', 3), player.animSpeed)
player.animations.idleUp = anim8.newAnimation(player.grid('5-8', 3), player.animSpeed)

player.animations.rollDown = anim8.newAnimation(player.grid('1-4', 4), player.animSpeed)
player.animations.rollUp = anim8.newAnimation(player.grid('5-8', 4), player.animSpeed)

player.animations.kickDown = anim8.newAnimation(player.grid('1-4', 5), player.animSpeed)
player.animations.kickUp = anim8.newAnimation(player.grid('5-8', 5), player.animSpeed)

player.anim = player.animations.idleDownRight

-- Si l'action ne peut pas être effectuée sur l'instant, elle est stockée dans le buffer et sera jouée dès l'action en cours finie.
player.buffer = {}

movementPing = {}
movementPing.animSpeed = player.animSpeed
movementPing.animTimer = 0
movementPing.grid = anim8.newGrid(32, 32, sprites.ui.movementPing:getWidth(), sprites.ui.movementPing:getHeight())
movementPing.anim = anim8.newAnimation(movementPing.grid('1-9', 1), movementPing.animSpeed)

kickEffect = {}
kickEffect.animSpeed = player.animSpeed
kickEffect.grid = anim8.newGrid(64, 64, sprites.ui.kickEffect:getWidth(), sprites.ui.kickEffect:getHeight())
kickEffect.anim = anim8.newAnimation(kickEffect.grid('1-4', 1), kickEffect.animSpeed)

function player:update(dt)

    if gamestate == 0 then return end

    -- Gère la durée de l'animation du ping de déplacement.
    if movementPing.animTimer > 0 then
        movementPing.animTimer = movementPing.animTimer - dt
    end
    if movementPing.animTimer < 0 then
        movementPing.animTimer = 0
    end

    -- Gère la durée du délai entre deux roulades.
    if player.rollDelayTimer > 0 then
        player.rollDelayTimer = player.rollDelayTimer - dt
    end

    -- Gère la durée du délai entre deux kicks.
    if player.kickDelayTimer > 0 then
        player.kickDelayTimer = player.kickDelayTimer - dt
    end

    -- Gère le stun après avoir subit une attaque.
    if player.stunTimer > 0 then
        player.stunTimer = player.stunTimer - dt
    end
    if player.stunTimer < 0 then
        player.stunTimer = 0
        if player.state == 10 then
            player.state = 0
            player:setLinearVelocity(0, 0)
        end
    end

    -- Gère l'invincibilité du joueur après avoir été touché.
    -- TODO : Ajouter un temps plus long entre les clignotements.
    if player.immunityTimer > 0 then
        player.immunityTimer = player.immunityTimer - dt
        if player.flashTimer > 0 then player.flashTimer = player.flashTimer - dt end
        if player.flashTimer <= 0 then
            player.flashTimer = 0.1
            player.flashBool = player.flashBool * -1
        end
    end
    if player.immunityTimer < 0 then
        player.immunityTimer = 0
    end

    if player.state == 0 then

        player:setLinearDamping(0)

        -- L'étincelle est déclenchée par le clic droit et est éteinte après avoir initié le mouvement.
        spark = false

        if love.mouse.isDown('2') then
            
            movementPing.animTimer = 8 * movementPing.animSpeed
            movementPing.anim:gotoFrame(1)

            player:setLinearVelocity(0, 0)

            oldx = player.x
            oldy = player.y
            newx, newy = cam:mousePosition()
            dist = math.sqrt((newx - oldx)^2 + (newy - oldy)^2)
            player.walking = true

            if newx > oldx then
                player.dirX = 1
            else
                player.dirX = -1
            end

            if newy > oldy then
                player.dirY = 1
            else
                player.dirY = -1
            end   
                
            spark = true
            
        end
        
        if spark then
            local dir = vector.new(newx - oldx, newy - oldy):normalized()
            local angle = dir:angleTo(u)
            local vx = 0
            local vy = 0

            vx = math.cos(angle) * player.speed * dt
            vy = math.sin(angle) * player.speed * dt

            player:setLinearVelocity(vx, vy)

            spark = false
        end

        if player.walking then
            
            player.x, player.y = player:getPosition()

            if math.sqrt((player.x - oldx)^2 + (player.y - oldy)^2) >= dist or player:enter('Wall')then
                player:setLinearVelocity(0, 0)
                player.walking = false
            end


            -- Si le joueur va vers le haut, l'idle correspondante se joue.
            if player.dirY == 1 then
                player.anim = player.animations.down
            else
                player.anim = player.animations.up
            end
        else

            -- Si le joueur finit sa course vers le haut, l'idle correspondante se joue.
                if player.dirY == 1 then
                    player.anim = player.animations.idleDown
                else
                    player.anim = player.animations.idleUp
                end
        end
        player.anim:update(dt)
        movementPing.anim:update(dt)

        player:checkDamage()



    elseif player.state == 0.1 then
        player.anim:update(dt)
        
        player.animTimer = player.animTimer - dt
        if player.animTimer < 0 then
            player:setLinearVelocity(0, 0)
            player.x, player.y = player:getPosition()
            player.walking = false
            player.state = 0
            player.animTimer = 0
            player.rollDelayTimer = 0.3
        end
    elseif player.state >= 1 and player.state < 2 then
        player.anim:update(dt)
        kickEffect.anim:update(dt)

        if player.state == 1 then 
            player:kickDamage()
            player.state = 1.1
        end

        player.animTimer = player.animTimer - dt
        if player.animTimer < 0 then
            player.walking = false
            player.kickDir = 1
            player.state = 0
            player.animTimer = 0
            player.kickDelayTimer = 0.25
        end
    end

    if takeDamage then
        if player.dmg > 0 then
            player.healthVisual = player.healthVisual - 20 * dt
            player.dmg = player.dmg - 20 * dt
        else
            takeDamage = false
        end
        if player.dmg < 0 then
            player.dmg = 0
        end
    end

    if recover then
        if heal > 0 and player.health < data.maxHealth then
            player.health = player.health + 50 * dt
            player.healthVisual = player.healthVisual + 50 * dt
            heal = heal - 50 * dt
        else
            recover = false
        end
    end

    player:processBuffer(dt)

end

function player:draw()

    local px, py = player:getPosition()

    if movementPing.animTimer > 0 then
        movementPing.anim:draw(sprites.ui.movementPing, newx, newy, nil, 1, 1, 16, 16)
    end

    -- Fait clignoter le personnage tant qu'il est immunisé aux dégats.
    if player.immunityTimer > 0 then
        local alpha = 1
        if player.flashBool < 0 then alpha = 0.2 end
        love.graphics.setColor(1, 1, 1, alpha)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(sprites.playerShadow, px, py + 25, nil, nil, nil, 32, 32)

    if player.state == 1 or player.state == 1.1 then
        local kickAngle = player.kickDir:angleTo(v) + player.kickLR * math.pi / 5 - math.pi / 2 + math.pi * (player.kickLR + 1) 
        player.anim:draw(sprites.MTusk, px, py - 5, nil, player.kickLR, 1, 32, 32)
        kickEffect.anim:draw(sprites.ui.kickEffect, px + player.kickDir.x, py + player.kickDir.y, kickAngle, 1, player.kickLR * -1, 44, 38)
        if toggleColliders then love.graphics.circle('line', px + range.x, py + range.y, 20) end
    elseif player.state == 0.1 then
        player.anim:draw(sprites.MTusk, px, py - 5, 2 * math.pi * (player.animTimer / 0.3)^2 * player.rollDir, player.dirX, 1, 32, 32)
    else
        player.anim:draw(sprites.MTusk, px, py - 5, nil, player.dirX, 1, 32, 32)
    end
    love.graphics.setColor(1, 1, 1, 1)
end


-- Fonction qui gère le déroulement d'une roulade.
function player:roll()
    if player.state ~= 0 or player.rollDelayTimer > 0 then
        player:addToBuffer('roll')
        return
    end

    local dir = playerToMouseVect()
    player.rollDir = - sign(dir.x)

    -- Dans le cas où le curseur et le joueur sont à la même position (pas de direction) :
    if dir.x == 0 and dir.y == 0 then return end

    -- Le joueur rentre en état de roulade.
    player.state = 0.1
    player.animTimer = 0.3

    if dir.y < 0 then
        player.anim = player.animations.rollUp
    else
        player.anim = player.animations.rollDown
    end
    player.anim:gotoFrame(1)

    player:setLinearDamping(1.5)
    player:setLinearVelocity(dir.x * 600, dir.y * 600)
end

-- Fonctions qui gère le kick.
function player:kick()
    if player.state ~= 0 or player.kickDelayTimer > 0 then
        player:addToBuffer('kick')
        return
    end

    player:setLinearVelocity(0, 0)

    local dir = playerToMouseVect()
    player.kickDir = dir * (player.range - 10)
    player.kickLR = sign(dir.x)

    -- Cas où le curseur n'a pas bougé (pas de direction).
    if dir.x == 0 and dir.y == 0 then return end

    player.state = 1
    player.animTimer = 0.3

    if dir.y < 0 then
        player.anim = player.animations.kickUp
    else
        player.anim = player.animations.kickDown
    end
    player.anim:gotoFrame(1)
    kickEffect.anim:gotoFrame(1)

end

function player:kickDamage()
    -- Sonde une zone circulaire dans la direction de la souris pour trouver de potentiels ennemies à blesser.

    range = playerToMouseVect() * player.range

    local hitEnemies = world:queryCircleArea(player:getX() + range.x, player:getY() + range.y, 20, {'Enemy'})
    for _, foe in ipairs(hitEnemies) do
        local knockbackDir = vector(foe:getX() - player:getX(), foe:getY() - player:getY())
        local angleToFoe = knockbackDir:angleTo(u)
        if angleToFoe <= 0 then
            angleToFoe = 2 * math.pi + angleToFoe
        elseif foe.parent.oddWeakspot and angleToFoe <= foe.parent.weakspotSize then 
            angleToFoe = 2 * math.pi + angleToFoe 
        end
        if foe.parent.weakspot and angleToFoe > foe.parent.weakspotStart and angleToFoe < foe.parent.weakspotEnd then
            foe.parent:hit(2, knockbackDir)
            player.combo = player.combo + 2
            player.score = player.score + player.combo * 1
            globalStun = 0.25
            foe.parent.weakspot = false
            foe.parent.oddWeakspot = false
        else
            foe.parent:hit(1, knockbackDir)
            player.combo = player.combo + 1
        end
    end

end

-- Gestion du buffer :
function player:processBuffer(dt)
    -- pour i allant du nombre d'elements dans 'player.buffer' (#) jusqu'à 1 en réduisant i de 1 à chaque itération, ...
    for i = #player.buffer, 1, -1 do
        player.buffer[i][2] = player.buffer[i][2] - dt -- Chaque élément voit sa durée de vie diminuer à chaque dt
    end
    -- On supprime les actions qui sont arrivé à expiration :
    for i = #player.buffer, 1, -1 do
        if player.buffer[i][2] <= 0 then
            table.remove(player.buffer, i)
        end
    end

    -- Si le joueur n'est pas en train de réaliser une action, on peut réaliser les actions dans le buffer :
    if player.state == 0 then
        player:useBuffer()
    end
end

function player:addToBuffer(action)
    if action == 'roll' and player.state == 0.1 then
        table.insert(player.buffer, {action, 0.1}) -- Le deuxième élément de chaque tuple correspond à la durée de vie de l'action dans le buffer.
    else
        table.insert(player.buffer, {action, 0.15})
    end
end

function player:useBuffer()
    local action = nil
    -- On affecte le dernier élément ajouté au buffer à l'action qui va être réalisée.
    if #player.buffer > 0 then
        action = player.buffer[1][1]
    end

    -- On vide ensuite le buffer :
    for n, v in pairs(player.buffer) do player.buffer[n] = nil end

    if action == nil then return end

    if action == 'roll' then
        player:roll()
    end

    if action == 'kick' then
        player:kick()
    end

end

function player:checkDamage()
    if player.immunityTimer > 0 then return end

    -- On créé une liste qui comporte tous les ennemis qui sont en range pour blesser le joueur.
    local hitEnemies = world:queryCircleArea(player:getX(), player:getY(), 20, {'Enemy'})
    -- Si la liste n'est pas vide, le joueur subit des dégats de la part de l'ennemi.
    if #hitEnemies > 0 then
        local enemyHitting = hitEnemies[1]
        player:hurt(enemyHitting.parent.damage, enemyHitting:getX(), enemyHitting:getY())
    end
end


function player:hurt(damage, srcx, srcy)
    if player.immunityTimer > 0 or player.health - damage < 0 then return end
    player.immunityTimer = 1
    player.state = 10
    player.stunTimer = 0.1
    player.flashTimer = 0.1
    player.combo = 0
    player:setLinearDamping(20)
    player:setLinearVelocity((vector(player:getX() - srcx, player:getY() - srcy):normalized() * 1000):unpack())
    player.health = player.health - damage
    takeDamage = true
    player.dmg = damage
end