local Game = fg.Object:extend('Game')

Ball = require 'Ball'
Paddle = require 'Paddle'

function Game:new()
    ball = Ball(fg.screen_width/2, fg.screen_height/2, {angle = math.pi/4})
    paddle1 = Paddle(15, 50)
    paddle2 = Paddle(fg.screen_width - 15, 50)
end

function Game:update(dt)
    ball:update(dt)
    paddle1:update(dt)
    paddle2:update(dt)
end

function Game:draw()
    ball:draw()
    paddle1:draw()
    paddle2:draw()
end

return Game
