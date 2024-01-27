local Paddle = fg.Object:extend('Paddle')

function Paddle:new(x, y, settings)
    local settings = settings or {}
    self.x, self.y = x, y
    self.w = settings.w or 30
    self.h = settings.h or 100

    self.last_y = 0
    self.ai = settings.ai
    self.v = 0
    self.max_v = 400
    self.idle = false
    self.idle_position = 0
    fg.timer:every(0.6, function()
        self.idle_position = fg.screen_height/2 + math.random(-fg.screen_height/4, fg.screen_height/4)
    end)
    fg.timer:every({0.02, 0.04}, function()
        table.insert(paddle_trails, PaddleTrail(self.x, self.y, self.w, self.h))
    end)

    self.w_pulse = 0
    self.h_pulse = 0
    fg.timer:every({0.02, 0.04}, function()
        fg.timer:tween(0.02, self, {w_pulse = fg.utils.math.random(-4, 4)}, 'in-elastic')
        fg.timer:tween(0.02, self, {h_pulse = fg.utils.math.random(-4, 4)}, 'in-elastic')
    end)
end

function Paddle:update(dt)
    if self.ai then
        self.max_v = 100*level
        local dy = self.y - balls[1].y
        if self.idle then 
            dy = self.y - self.idle_position 
        end
        if dy < 0 then
            self.y = self.y - math.max((level+1.2)*dy, -self.max_v)*dt
        else
            self.y = self.y - math.min((level+1.2)*dy, self.max_v)*dt
        end
    else
        self.y = love.mouse.getY()
    end

    if self.y < 0 + self.h/2 then
        self.y = 0 + self.h/2
    end
    if self.y > fg.screen_height - self.h/2 then
        self.y = fg.screen_height - self.h/2
    end

    self.v = self.last_y - self.y
    self.last_y = self.y
end

function Paddle:draw()
    local w, h = self.w + self.w_pulse, self.h + self.h_pulse
    love.graphics.rectangle('fill', self.x - w/2, self.y - h/2, w, h)
end

return Paddle
