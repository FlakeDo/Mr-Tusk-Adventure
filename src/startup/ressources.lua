sprites = {}
sprites.enemies = {}
sprites.enemies.dropletIner = love.graphics.newImage('sprites/enemies/dropletIner.png')
sprites.enemies.dropletOuter = love.graphics.newImage('sprites/enemies/dropletOuter.png')
sprites.enemies.shadow = love.graphics.newImage('sprites/enemies/shadow.png')

sprites.environement = {}
sprites.environement.wave = love.graphics.newImage('sprites/environement/waves.png')

sprites.ui = {}
sprites.ui.movementPing = love.graphics.newImage('sprites/ui/movementPingSheet.png')
sprites.ui.healthBarUi = love.graphics.newImage('sprites/ui/healthBarUi.png')
sprites.ui.healthBarBg = love.graphics.newImage('sprites/ui/healthBarBg.png')
sprites.ui.kickEffect = love.graphics.newImage('sprites/ui/kickEffect.png')
sprites.ui.comboUi = love.graphics.newImage('sprites/ui/comboUi.png')

sprites.MTusk = love.graphics.newImage('sprites/MTusk.png')
sprites.playerShadow = love.graphics.newImage('sprites/playerShadow.png')

function initFonts()
    fonts = {}
    fonts.global = love.graphics.newFont('fonts/Jersey10-regular.ttf', 20 * scale)

    love.graphics.setFont(fonts.global)
end
initFonts()