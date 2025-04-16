-- Tout ce qui touche à la sauvegarde + nouvelle partie.

function createNewSave(fileNumber)
    -- Cette liste contient la data de la sauvegarde.
    data = {}
    data.saveCount = 0 -- Nombre de fois que la partie a été sauvegardée.
    data.progress = 0 -- Où en est le joueur de la progression du jeu dans cette sauvegarde.
    data.playerx = 0
    data.playery = 0
    data.maxHealth = 100
    data.map = 'basicBeach' -- Quelle map est chargée.

    if fileNumber == nil then fileNumber = 1 end
    data.fileNumber = fileNumber -- Quel est l'id de la sauvegarde.
end

function startFresh(fileNumber)
    createNewSave(fileNumber)
    data.map = 'basicBeach'
    data.playerx = 384
    data.playery = 3392
end