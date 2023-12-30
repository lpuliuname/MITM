local Ball = fg.Object:extend('Ball')

function Ball:new(x, y, settings)
    local settings = settings or {}
    self.x, self.y = x, y
    self.r = settings.r or 15
    self.v = settings.v or fg.Vector(100, 100)
    self.angle = settings.angle or 0
end

function Ball:update(dt)
    self.x = self.x + self.v.x*math.cos(self.angle)*dt
    self.y = self.y + self.v.y*math.sin(self.angle)*dt

    if self.x < 0 + self.r/2 then 
        self.angle = math.pi - self.angle
    end
    if self.x > fg.screen_width - self.r/2 then
        self.angle = math.pi - self.angle
    end
    if self.y < 0 + self.r/2 then
        self.angle = -self.angle
    end
    if self.y > fg.screen_height - self.r/2 then
        self.angle = -self.angle
    end
end

function Ball:draw()
    love.graphics.rectangle('fill', self.x - self.r/2, self.y - self.r/2, self.r, self.r)
end

return Ball
