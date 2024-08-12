local Player = fg.Class('Player', 'Entity')
Player:implement(fg.PhysicsBody)

Player.enter = {'Solid'}

function Player:new(area, x, y, settings)
    Player.super.new(self, area, x, y, settings)
    self:physicsBodyNew(area, x, y, settings)

    self.fixture:setFriction(0)

    fg.world.camera:follow(self, {lerp = 1, follow_style = 'platformer'})

    self.direction = 'right'
    self.animation_state = 'idle'
    self.jumping = false
    self.idle = fg.Animation(love.graphics.newImage('idle.png'), 32, 32, 0)
    self.run = fg.Animation(love.graphics.newImage('run.png'), 32, 32, 0.18)
    self.jump = fg.Animation(love.graphics.newImage('jump.png'), 32, 32, 0)
    self.fall = fg.Animation(love.graphics.newImage('fall.png'), 32, 32, 0)

    self.max_jumps = 1
    self.jumps_left = self.max_jumps
    self.jump_press_time = 0

    fg.input:bind('a', 'move_left')
    fg.input:bind('d', 'move_right')
    fg.input:bind('dpleft', 'move_left')
    fg.input:bind('dpright', 'move_right')
    fg.input:bind('leftx', 'move_horizontal')
    fg.input:bind(' ', 'jump')
    fg.input:bind('fdown', 'jump')
end

function Player:update(dt)
    self:physicsBodyUpdate(dt)

    if fg.input:down('move_left') then
        self.direction = 'left'
        local vx, vy = self.body:getLinearVelocity()
        self.body:setLinearVelocity(-150, vy)
    end
    if fg.input:down('move_right') then
        self.direction = 'right'
        local vx, vy = self.body:getLinearVelocity()
        self.body:setLinearVelocity(150, vy)
    end
    if not fg.input:down('move_left') and not fg.input:down('move_right') then
        local vx, vy = self.body:getLinearVelocity()
        self.body:setLinearVelocity(48*dt*vx, vy)
    end
    if fg.input:pressed('jump') then
        if self.jumps_left > 0 then
            self.jumping = true
            local vx, vy = self.body:getLinearVelocity()
            self.body:setLinearVelocity(vx, -250)
            self.jumps_left = self.jumps_left - 1
            self.jump_press_time = love.timer.getTime()
        end
    end
    if fg.input:released('jump') then
        local stopJump = function()
            self.jump_press_time = 0
            local vx, vy = self.body:getLinearVelocity()
            if vy < 0 then self.body:setLinearVelocity(vx, 0) end
        end
        local dt = love.timer.getTime() - self.jump_press_time
        if dt >= 0.125 then stopJump()
        else fg.timer:after(0.125 - dt, function() stopJump() end) end
    end

    --[[
    local x = fg.input:down('move_horizontal')
    if x then
        if x < 0 then 
            self.direction = 'left'
            local vx, vy = self.body:getLinearVelocity()
            self.body:setLinearVelocity(-150, vy)
        elseif x > 0 then
            self.direction = 'right'
            local vx, vy = self.body:getLinearVelocity()
            self.body:setLinearVelocity(150, vy)
        end
    else
        local vx, vy = self.body:getLinearVelocity()
        self.body:setLinearVelocity(48*dt*vx, vy)
    end
    ]]--

    local vx, vy = self.body:getLinearVelocity()
    if math.abs(vx) < 25 then self.animation_state = 'idle'
    else self.animation_state = 'run' end
    if self.jumping then self.animation_state = 'jump' end
    if vy > 5 then self.animation_state = 'fall' end
    self[self.animation_state]:update(dt)
    self[self.animation_state]:update(dt)
end

function Player:draw()
    self:physicsBodyDraw()
    if self.direction == 'right' then
        self[self.animation_state]:draw(self.x, self.y, 0, 1, 1, 
                                        self[self.animation_state].frame_width/2, 
                                        self[self.animation_state].frame_height/2 + 2)
    elseif self.direction == 'left' then
        self[self.animation_state]:draw(self.x, self.y, 0, -1, 1, 
                                        self[self.animation_state].frame_width/2, 
                                        self[self.animation_state].frame_height/2 + 2)
    end
end

function Player:onCollisionEnter(other, contact)
    if other.tag == 'Solid' then
        local x1, y1, x2, y2 = contact:getPositions()
        local player_bottom = self.y + self.h/2 - 4
        if y1 > player_bottom then
            self.jumping = false
            self.jumps_left = self.max_jumps
        end
    end
end

return Player
