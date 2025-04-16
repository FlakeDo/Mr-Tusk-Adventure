function waveInit(x, y, width, height, name, type, parent)

    wave = world:newRectangleCollider(x, y, width, height, {collision_class = 'wave'})
    wave:setType('static')
    wave:setCollisionClass('Wave')
    wave.name = name
    wave.parent = parent
    wave.type = type
    wave.riseTime = 1.2
    wave.riseX = 0
    wave.riseMax = 40
    wave.sprite = sprites.environement.wave

    wave.grid = anim8.newGrid(64, 1024, wave.sprite:getWidth(), wave.sprite:getHeight())

    wave.animation = anim8.newAnimation(wave.grid('1-8', 1), 0.3)

    function wave:rise(dest, start)
        local time = self.riseTime
        if start then time = 0.6 end
        self.tween = flux.to(self, time, {riseX = dest}):ease('sineinout'):oncomplete(function() self:lower(self.riseMax * -1) end )        
    end

    function wave:lower(dest)
        self.tween = flux.to(self, self.riseTime, {riseX = dest}):ease('sineinout'):oncomplete(function() self:rise(self.riseMax) end )        
    end

    wave:rise(wave.floatMax, true)

    function wave:update(dt)
        wave.animation:update(dt)
    end

    function wave:draw()

        love.graphics.setColor(0.20, 0.63, 0.95)
        love.graphics.rectangle('fill', 1408 - wave.riseX, 0, 448, 4096)
        love.graphics.setColor(1, 1, 1)
    
        wave.animation:draw(wave.sprite, 1344 - self.riseX, 0)
    
    end

   
end