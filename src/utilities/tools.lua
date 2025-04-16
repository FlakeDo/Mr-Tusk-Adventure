u = vector.new(1,0)
v = vector.new(0,1)

function sign(x)
    return math.max(math.min(x * 1e200 * 1e200, 1), -1)
end

function playerToMouseVect()
    local mx, my = cam:mousePosition()
    return vector.new(mx - player.x, my - player.y):normalized()
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end