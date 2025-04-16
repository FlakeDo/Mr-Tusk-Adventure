enemies = {}

function spawnEnemy(x, y, type)

    local enemy = {}

    enemy.type = type
    enemy.dead = false
    enemy.startx = x
    enemy.starty = y
    enemy.dead = false
    enemy.stunTimer = 0

    TEST = false

    -- Etats d'enemies :
    -- 0 : Apparait.
    -- 1  : Cherche.
    -- 1.1 : Marche vers.
    -- 10 : Attaque.
    enemy.state = 10
    enemy.speed = 1000

    enemy.weakspotSize = 2 * math.pi / 5 -- La tolérance du point faible, sa taille en radian.
    enemy.oddWeakspot = false

    local init
    if type == 'droplet' then
        init = require 'src/enemies/droplet'
    end

    enemy = init(enemy, enemy.startx, enemy.starty)

    function enemy:movePattern(dt)

        if self.stunTimer > 0 then
            self.stunTimer = self.stunTimer - dt
        end
        if self.stunTimer < 0 then
            self.stunTimer = 0
            self.collider:setLinearVelocity(0, 0)
            self.anim = self.animations.neutral
            self.auraAnim = self.animations.auraNeutral
        end

        if self.stunTimer == 0 then
            -- self.anim:update(dt)
            local px, py = player:getPosition()
            local ex, ey = self.collider:getPosition()

            if self.state == 10 then
                self.dir = vector(px - ex, py - ey):normalized() * self.magnitude
                if distanceBetween(0, 0, self.collider:getLinearVelocity()) < self.maxSpeed then
                    self.collider:applyForce(self.dir:unpack())
                end
            end

            if self.health <= 0 then
                self.dead = true
            end
        end

    end

    function enemy:hit(damage, dir)
        self.health = self.health - damage
        self.stunTimer = 0.4
        local magnitude = 400
        self.anim = self.animations.hurt
        self.auraAnim = self.animations.auraHurt

        -- Le linear damping ralentit l'ennemi après qu'il ait été touché ; Linear impulse marche mais est moins clean.
        -- self.collider:setLinearDamping(20)
        -- self.collider:setLinearVelocity((dir:normalized() * magnitude):unpack())
        self.collider:applyLinearImpulse((dir:normalized() * magnitude):unpack())
    end

    function enemy:initWeakSpot()
        local rand = math.random()
        self.weakspotStart = 2 * math.pi * rand
        if self.weakspotStart > 2 * math.pi - self.weakspotSize then self.oddWeakspot = true end
        self.weakspotEnd = self.weakspotStart + self.weakspotSize
        self.weakspot = true
    end

    table.insert(enemies, enemy)

end



function enemies:update(dt)

    if gamestate == 0 then return end
    -- Update chaque ennemi de la liste.
    for i, foe in ipairs(self) do
        foe:update(dt)
    end

    -- On parcourt la liste des ennemis à l'envers pour éliminer ceux qui sont morts.
    for i = #enemies, 1, -1 do
        if enemies[i].dead then
            if enemies[i].collider ~= nil then
                player.score = player.score + enemies[i].prize * player.combo
                enemies[i].collider:destroy()
            end
            table.remove(enemies, i)
        end
    end
end

function enemies:draw()
    for i, foe in ipairs(self) do
        foe:draw()
    end
end