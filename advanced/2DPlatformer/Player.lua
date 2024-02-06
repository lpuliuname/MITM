local Player = fg.Class('Player', 'Entity')
Player:implement(fg.PhysicsBody)

function Player:new(area, x, y, settings)
    Player.super.new(self, area, x, y, settings)
    self:physicsBodyNew(area, x, y, settings)

    self.direction = 'right'
    self.animation_state = 'idle'
    self.idle = fg.Animation(love.graphics.newImage('idle.png'), 32, 32, 0)
    self.run = fg.Animation(love.graphics.newImage('run.png'), 32, 32, 0.1)

    fg.input:bind('a', 'move_left')
    fg.input:bind('d', 'move_right')
    fg.input:bind('dpleft', 'move_left')
    fg.input:bind('dpright', 'move_right')
    fg.input:bind('leftx', 'move_horizontal')
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

    local vx, vy = self.body:getLinearVelocity()
    if math.abs(vx) < 25 then self.animation_state = 'idle'
    else self.animation_state = 'run' end
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

return Player
