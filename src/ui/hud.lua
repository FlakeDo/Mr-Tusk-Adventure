function drawHUD()
    drawHealthBar()
    drawScore()
end

function drawHealthBar()
    love.graphics.draw(sprites.ui.healthBarBg, (love.graphics.getWidth() / 2) - 256, love.graphics.getHeight() - 32)

    -- On dessine la barre de vie blanche qui diminue graduellement.
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', (love.graphics.getWidth() / 2) - 248, love.graphics.getHeight() - 22, (512 - 14) * player.healthVisual / data.maxHealth, 15)
    
    -- On dessine ensuite la barre de vie dont la couleur varie et qui diminue instantanément lorsque le joueur est touché.
    love.graphics.setColor(0.4 - 0.52 * ((player.health / data.maxHealth)^4 - 1), 0.86 + 0.6 * (player.health / data.maxHealth - 1), 0.52 + 0.34 * ((player.health / data.maxHealth)^4 - 1))
    
    love.graphics.rectangle('fill', (love.graphics.getWidth() / 2) - 248, love.graphics.getHeight() - 22, (512 - 14) * player.health / data.maxHealth, 15)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(sprites.ui.healthBarUi, (love.graphics.getWidth() / 2) - 256, love.graphics.getHeight() - 32)
end

function drawScore()
    love.graphics.draw(sprites.ui.comboUi, 0, 0)
    love.graphics.print(player.score, 157, 4)
    love.graphics.print(player.combo, 135, 63)
end

--[[ draft : 
-- Création d'un rectangle qui réduira sa taille en fonction de la vie du personnage.
    -- Full health
    if player.health > 2 * data.maxHealth / 3 then
        love.graphics.setColor(0.4, 0.86, 0.52)
    -- Mid life
    elseif player.health > data.maxHealth / 3 then
        love.graphics.setColor(0.92, 0.52, 0.19)
    -- Low health
    else
        love.graphics.setColor(0.92, 0.26, 0.18)
]]