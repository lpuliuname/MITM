local Entity = require(fuccboi_path .. '/entities/Entity')
local DebugShape = Entity:extend('DebugShape')

DebugShape.layer = 'Debug'

function DebugShape:new(area, x, y, settings)
    DebugShape.super.new(self, area, x, y, settings)
    self.alpha = 255
end

function DebugShape:update(dt)
    self.dead = true
end

function DebugShape:draw()
    if self.query then love.graphics.setColor(222, 222, 128, self.alpha) 
    elseif self.apply then love.graphics.setColor(222, 128, 128, self.alpha)
    elseif self.link then love.graphics.setColor(160, 128, 222, self.alpha) end

    if self.shape == 'circle' then
        love.graphics.circle('line', self.x, self.y, self.r)

    elseif self.shape == 'line' then
        love.graphics.line(self.x, self.y, self.xf, self.yf)
    end

    love.graphics.setColor(255, 255, 255, 255)
end

return DebugShape
