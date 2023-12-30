local Paddle = fg.Object:extend('Paddle')

function Paddle:new(x, y, settings)
    local settings = settings or {}
    self.x, self.y = x, y
    self.w = settings.w or 10
    self.h = settings.h or 50
end

function Paddle:update(dt)
    self.y = love.mouse.getY()
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end

return Paddle
