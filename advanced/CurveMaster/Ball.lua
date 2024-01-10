local Ball = fg.Object:extend('Ball')

function Ball:new(x, y, settings)
    local settings = settings or {}
    self.x, self.y = x, y
    self.r = settings.r or 30
    self.v = settings.v or fg.Vector(400, 400)
    self.angle = settings.angle or 0

    self.just_hit_paddle = false
    self.dead = false
    self.angle_speed = 0
    self.rotation = 0
    self.rotation_speed = math.pi
    self.trail_t = 0
    self.r_pulse = 0

    self.trail_timer = fg.timer:every({0.02, 0.04}, function()
        table.insert(ball_trails, BallTrail(self.x, self.y, self.r))
    end)
    fg.timer:every({0.02, 0.04}, function()
        fg.timer:tween(0.02, self, {r_pulse = fg.utils.math.random(-4, 4)}, 'in-elastic')
    end)
end

function Ball:update(dt)
    self.x = self.x + self.v.x*math.cos(self.angle)*dt
    self.y = self.y + self.v.y*math.sin(self.angle)*dt
    self.angle = self.angle + self.angle_speed*dt
    self.rotation = self.rotation + self.rotation_speed*dt

    self.trail_t = self.trail_t + dt
    if self.trail_t > (0.03 - math.abs(0.0125*self.angle_speed)) then
        self.trail_t = 0
        table.insert(ball_trails, BallTrail(self.x, self.y, self.r))
    end

    if self.x < 0 + self.r/2 then 
        self.angle = math.pi - self.angle
        self.dead = true
        camera:shake(1, 0.5)
        local ps = fg.getPS('Basic')
        ps:setPosition(self.x, self.y)
        table.insert(particles, ps)
    end
    if self.x > fg.screen_width - self.r/2 then
        self.angle = math.pi - self.angle
        self.dead = true
        camera:shake(1, 0.5)
        local ps = fg.getPS('Basic')
        ps:setPosition(self.x, self.y)
        table.insert(particles, ps)
    end
    if self.y < 0 + self.r/2 then
        self.angle = -self.angle
        self.rotation_speed = self.rotation_speed/2
        camera:shake(0.5, 0.25)
        local ps = fg.getPS('Basic')
        ps:setPosition(self.x, self.y)
        table.insert(particles, ps)
    end
    if self.y > fg.screen_height - self.r/2 then
        self.angle = -self.angle
        self.rotation_speed = self.rotation_speed/2
        camera:shake(0.5, 0.25)
        local ps = fg.getPS('Basic')
        ps:setPosition(self.x, self.y)
        table.insert(particles, ps)
    end

    if not self.just_hit_paddle then
        if (self.x - self.r/2 <= paddle1.x + paddle1.w/2) and
           (self.y >= paddle1.y - paddle1.h/2) and (self.y <= paddle1.y + paddle1.h/2) then
            self.angle = math.pi - self.angle
            self.angle_speed = paddle1.v/80
            self.v.x = self.v.x*(1.07 + 0.01*level)
            self.rotation_speed = paddle1.v/4
            paddle2.idle = false
            self.just_hit_paddle = true
            camera:shake(2, 0.5)
            local ps = fg.getPS('Basic')
            ps:setPosition(self.x, self.y)
            table.insert(particles, ps)
            fg.timer:cancel('r_speed_add')
            fg.timer:tween('r_speed_add', 1.5, self, {r = 30 - math.abs(12.5*self.angle_speed)}, 'in-out-cubic')
            fg.timer:after(0.2, function() self.just_hit_paddle = false end)
        end

        if (self.x + self.r/2 >= paddle2.x - paddle1.w/2) and
           (self.y >= paddle2.y - paddle2.h/2) and (self.y <= paddle2.y + paddle2.h/2) then
            self.angle = math.pi - self.angle
            self.angle_speed = -paddle2.v/80
            self.v.x = self.v.x*(1.07 + 0.01*level)
            self.rotation_speed = paddle2.v/4
            paddle2.idle = true
            self.just_hit_paddle = true
            camera:shake(2, 0.5)
            local ps = fg.getPS('Basic')
            ps:setPosition(self.x, self.y)
            table.insert(particles, ps)
            fg.timer:cancel('r_speed_add')
            fg.timer:tween('r_speed_add', 1.5, self, {r = 30 - math.abs(12.5*self.angle_speed)}, 'in-out-cubic')
            fg.timer:after(0.2, function() self.just_hit_paddle = false end)
        end
    end

    if self.dead then
        if self.x > fg.screen_width/2 then 
            level = level + 1 
        end
        if self.x < fg.screen_width/2 then
            level = level - 1
        end
        paddle2.idle = false
        fg.timer:cancel(self.trail_timer)
        table.insert(balls, Ball(fg.screen_width/2, fg.screen_height/2, {angle = fg.utils.math.random(-math.pi/4, math.pi/4)}))
    end
end

function Ball:draw()
    fg.utils.graphics.pushRotate(self.x, self.y, self.rotation)
    local r = self.r + self.r_pulse
    love.graphics.rectangle('fill', self.x - r/2, self.y - r/2, r, r)
    love.graphics.pop()
end

return Ball
