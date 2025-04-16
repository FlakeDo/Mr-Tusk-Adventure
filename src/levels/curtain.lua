-- Sert de transition entre les niveaux. Permet aussi de démarrer le jeu après le menu principal.

curtain = {}

-- Etats :
-- 0 : inactif
-- 1 : fermeture
-- 2 : ouverture
curtain.state = 0
curtain.x = 0
curtain.y = 0

-- Informations de la transition
curtain.destMap = 'basicBeach'
curtain.destx = 0
curtain.desty = 0

function curtain:call(destMap, destx, desty)
    curtain.destMap = destMap
    curtain.destx = destx
    curtain.desty = desty
    self:close()
end

function curtain:close()
    self.state = 1
    -- Inserer ici toute la partie graphique.
    self:open()
end

function curtain:open()
    self.state = 2
    triggerTransition(self.destMap, self.destx, self.desty)
    -- Inserer ici toute la partie graphique.
    self.state = 0
end