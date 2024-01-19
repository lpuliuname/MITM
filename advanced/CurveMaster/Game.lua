local Game = fg.Object:extend('Game')

Ball = require 'Ball'
Paddle = require 'Paddle'
BallTrail = require 'BallTrail'
PaddleTrail = require 'PaddleTrail'

function Game:new()
    fg.setScreenSize(800, 600)
    level = 1
    camera = fg.Camera({x = 240, y = 180, target = {x = 240, y = 180}})

    ball_trails = {}
    paddle_trails = {}
    balls = {}
    particles = {}
    table.insert(balls, Ball(fg.screen_width/2, fg.screen_height/2, {angle = math.pi/4}))

    paddle1 = Paddle(30, 50)
    paddle2 = Paddle(fg.screen_width - 30, 50, {ai = true})
end

function Game:update(dt)
    camera:update(dt)

    paddle1:update(dt)
    paddle2:update(dt)

    for i = #balls, 1, -1 do
        balls[i]:update(dt)
        if balls[i].dead then 
            table.remove(balls, i) 
        end
    end

    for i = #ball_trails, 1, -1 do
        ball_trails[i]:update(dt)
        if ball_trails[i].dead then 
            table.remove(ball_trails, i) 
        end
    end

    for i = #paddle_trails, 1, -1 do
        paddle_trails[i]:update(dt)
        if paddle_trails[i].dead then 
            table.remove(paddle_trails, i) 
        end
    end

    for i = #particles, 1, -1 do
        particles[i]:update(dt)
    end
end

function Game:draw()
    camera:attach()
    paddle1:draw()
    paddle2:draw()
    for _, ball in ipairs(balls) do 
        ball:draw() 
    end
    for _, ball_trail in ipairs(ball_trails) do 
        ball_trail:draw() 
    end
    for _, paddle_trail in ipairs(paddle_trails) do 
        paddle_trail:draw() 
    end
    for _, particle in ipairs(particles) do
        love.graphics.draw(particle, 0, 0)
    end
    camera:detach()
    love.graphics.print("LEVEL: " .. level, 30, 30, 0, 4, 4)
end

return Game
