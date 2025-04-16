function gameStart()

    initGlobals()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Gestion de la taille de la fenêtre.
    isFullscreen = true
    setWindowSize(isFullscreen, 960, 540)

    setScale()

    vector = require 'libraries/hump/vector'
    flux = require 'libraries/flux'

    -- Pas de collision classes dans breezefield donc remettre windfield et corriger le problème de detection de ennemies.
    local wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0, false)

    anim8 = require 'libraries/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'

    require "src/startup/require"
    requireAll()
end

function setWindowSize(full, width, height)
    if full then
        isFullscreen = true
        love.window.setFullscreen(true)
        windowWidth = love.graphics.getWidth()
        windowHeight = love.graphics.getHeight()
    else
        isFullscreen = false
        if width == nil or height == nil then
            windowWidth = 1920
            windowHeight = 1080
        else
            windowWidth = width
            windowHeight = height
        end
        love.window.setMode(windowWidth, windowHeight)
    end
end


function initGlobals()
    data = {}

    -- gamestates :
    -- 0 : Main Menu
    -- 1 : In game
    gamestate = 0
    globalStun = 0
end

function setScale()
    scale = (5.5/2400) * windowHeight

    if cam then
        cam:zoomTo(scale)
    end
end

function reinitScale()
    -- Reinitialise tout ce qui touche à l'echelle.
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    setScale()
    initFonts()
end