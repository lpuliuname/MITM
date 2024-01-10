local PaddleTrail = fg.Object:extend('PaddleTrail')

function PaddleTrail:new(x, y, w, h)
    self.x, self.y = x, y
    self.w = w + fg.utils.math.random(-4, 4)
    self.h = h + fg.utils.math.random(-4, 4)
    self.alpha = 0
    self.dead = false

    fg.timer:tween(0.02, self, {alpha = 255}, 'in-out-cubic')
    fg.timer:after(0.02, function()
        fg.timer:tween(0.2, self, {alpha = 0}, 'in-out-cubic')
        fg.timer:after(0.2, function() self.dead = true end)
    end)
end

function PaddleTrail:update(dt)

end

function PaddleTrail:draw()
    love.graphics.setColor(255, 255, 255, self.alpha)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    love.graphics.setColor(255, 255, 255, 255)
end

return PaddleTrail
