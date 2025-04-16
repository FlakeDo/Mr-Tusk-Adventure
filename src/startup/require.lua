function requireAll()

    require 'src/startup/collisionClasses'
    createCollisionClasses()

    require 'src/startup/ressources'
    require 'src/startup/data'

    require 'src/player'
    require 'src/draw'
    require 'src/update'

    require 'src/enemies/enemyMain'

    require 'src/utilities/cam'
    require 'src/utilities/tools'
    require 'src/utilities/globalStun'

    require 'src/levels/loadMap'
    require 'src/levels/walls'
    require 'src/levels/wave'
    require 'src/levels/curtain'
    require 'src/levels/transition'

    require 'src/ui/mainMenu'
    require 'src/ui/hud'
end