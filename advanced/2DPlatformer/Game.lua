local Game = fg.Object:extend('Game')

Player = require 'Player'

function Game:new()
    fg.world:createEntity('Player', fg.screen_width/2, fg.screen_height/2, {w = 16, h = 28})
end

function Game:update(dt)

end

function Game:draw()

end

return Game
