walls = {}

function spawnWalls(x, y, width, height, name, type, parent)
    local wall = world:newRectangleCollider(x, y, width, height, {collision_class = 'Wall'})
    wall:setType('static')
    wall.name = name
    wall.type = type
    wall.parent = parent

    table.insert(walls, wall)
end