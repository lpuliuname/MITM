local Game = fg.Object:extend('Game')

Player = require 'Player'

function Game:new()
    fg.world.box2d_world:setGravity(0, 20*32)
    fg.screen_scale = 2
    fg.setScreenSize(960, 720)
    fg.world:createEntity('Player', fg.screen_width/2, fg.screen_height/2, {w = 16, h = 28})

    fg.world:addLayer('BG1', {parallax_scale = 0.8})
    fg.world:addToLayer('BG1', fg.Background(380, 260, love.graphics.newImage('bg-back.png')))
    fg.world:addLayer('BG2', {parallax_scale = 0.9})
    fg.world:addToLayer('BG2', fg.Background(440, 270, love.graphics.newImage('bg-mid.png')))
    fg.world:setLayerOrder({'BG1', 'BG2', 'Default'})

    tilemap = fg.Tilemap(fg.screen_width/2, fg.screen_height/2, 32, 32, love.graphics.newImage('tileset-normal.png'), {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    })
    tilemap:setAutoTileRules({6, 14, 12, 2, 10, 8, 7, 15, 13, 3, 11, 9})
    tilemap:autoTile()
    fg.world:generateCollisionSolids(tilemap)
    fg.world:addToLayer('Default', tilemap)
end

function Game:update(dt)

end

function Game:draw()

end

return Game
