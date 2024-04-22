local debugDraw = {}
local path = fuccboi_path .. '/resources/controllers/'

debugDraw.input = fg.input
debugDraw.controller_enabled = false 
debugDraw.keyboard_enabled = false 
debugDraw.physics_enabled = false 
debugDraw.query_enabled = false 

debugDraw.resources = {}
debugDraw.resources.PS3 = {
    dpad = love.graphics.newImage(path .. 'PS3/PS3_Dpad.png'),
    dpad_left = love.graphics.newImage(path .. 'PS3/PS3_Dpad_Left.png'),
    dpad_right = love.graphics.newImage(path .. 'PS3/PS3_Dpad_Right.png'),
    dpad_up = love.graphics.newImage(path .. 'PS3/PS3_Dpad_Up.png'),
    dpad_down = love.graphics.newImage(path .. 'PS3/PS3_Dpad_Down.png'),
    l1 = love.graphics.newImage(path .. 'PS3/PS3_L1.png'),
    l1_down = love.graphics.newImage(path .. 'PS3/PS3_L1_Down.png'),
    l2 = love.graphics.newImage(path .. 'PS3/PS3_L2.png'),
    l2_down = love.graphics.newImage(path .. 'PS3/PS3_L2_Down.png'),
    r1 = love.graphics.newImage(path .. 'PS3/PS3_R1.png'),
    r1_down = love.graphics.newImage(path .. 'PS3/PS3_R1_Down.png'),
    r2 = love.graphics.newImage(path .. 'PS3/PS3_R2.png'),
    r2_down = love.graphics.newImage(path .. 'PS3/PS3_R2_Down.png'),
    left_stick_front = love.graphics.newImage(path .. 'PS3/PS3_Left_Stick_Front.png'),
    right_stick_front = love.graphics.newImage(path .. 'PS3/PS3_Right_Stick_Front.png'),
    left_stick_front_down = love.graphics.newImage(path .. 'PS3/PS3_Left_Stick_Front_Down.png'),
    right_stick_front_down = love.graphics.newImage(path .. 'PS3/PS3_Right_Stick_Front_Down.png'),
    stick_back = love.graphics.newImage(path .. 'PS3/PS3_Stick_Back.png'),
    select = love.graphics.newImage(path .. 'PS3/PS3_Select.png'),
    start = love.graphics.newImage(path .. 'PS3/PS3_Start.png'),
    cross = love.graphics.newImage(path .. 'PS3/PS3_Cross.png'),
    circle = love.graphics.newImage(path .. 'PS3/PS3_Circle.png'),
    triangle = love.graphics.newImage(path .. 'PS3/PS3_Triangle.png'),
    square = love.graphics.newImage(path .. 'PS3/PS3_Square.png'),
    cross_down = love.graphics.newImage(path .. 'PS3/PS3_Cross_Down.png'),
    circle_down = love.graphics.newImage(path .. 'PS3/PS3_Circle_Down.png'),
    triangle_down = love.graphics.newImage(path .. 'PS3/PS3_Triangle_Down.png'),
    square_down = love.graphics.newImage(path .. 'PS3/PS3_Square_Down.png'),
}

debugDraw.positions = {}
local center = {x = 200, y = 200}
debugDraw.positions.PS3 = {
    dpad = {x = center.x + 263, y = center.y - 15},
    face_down = {x = center.x - 20, y = center.y - 20},
    face_up = {x = center.x - 20, y = center.y + 100},
    face_left = {x = center.x + 40, y = center.y + 40},
    face_right = {x = center.x - 80, y = center.y + 40},
    left_stick = {x = center.x + 157, y = center.y - 80},
    right_stick = {x = center.x + 63, y = center.y - 80},
    r1 = {x = center.x + 63, y = center.y},
    l1 = {x = center.x + 157, y = center.y},
    r2 = {x = center.x + 63, y = center.y + 80},
    l2 = {x = center.x + 157, y = center.y + 80},
}


debugDraw.update = function(dt)

end

debugDraw.draw = function()
    if debugDraw.controller_enabled == 'PS3' then
        -- dpad
        love.graphics.draw(debugDraw.resources.PS3.dpad, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                           debugDraw.positions.PS3.dpad.x, debugDraw.positions.PS3.dpad.y)
        if debugDraw.input.state.dpup then
            love.graphics.draw(debugDraw.resources.PS3.dpad_up, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                               debugDraw.positions.PS3.dpad.x, debugDraw.positions.PS3.dpad.y)
        end
        if debugDraw.input.state.dpdown then
            love.graphics.draw(debugDraw.resources.PS3.dpad_down, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                               debugDraw.positions.PS3.dpad.x, debugDraw.positions.PS3.dpad.y)
        end
        if debugDraw.input.state.dpleft then
            love.graphics.draw(debugDraw.resources.PS3.dpad_left, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                               debugDraw.positions.PS3.dpad.x, debugDraw.positions.PS3.dpad.y)
        end
        if debugDraw.input.state.dpright then
            love.graphics.draw(debugDraw.resources.PS3.dpad_right, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                               debugDraw.positions.PS3.dpad.x, debugDraw.positions.PS3.dpad.y)
        end

        local visual

        -- sticks
        local x, y = debugDraw.input.state.leftx or 0, debugDraw.input.state.lefty or 0
        love.graphics.draw(debugDraw.resources.PS3.stick_back, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.left_stick.x, debugDraw.positions.PS3.left_stick.y)
        visual = debugDraw.resources.PS3.left_stick_front
        if debugDraw.input.state.leftstick then visual = debugDraw.resources.PS3.left_stick_front_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                           debugDraw.positions.PS3.left_stick.x - 20*x, debugDraw.positions.PS3.left_stick.y - 20*y)
        local x, y = debugDraw.input.state.rightx or 0, debugDraw.input.state.righty or 0
        love.graphics.draw(debugDraw.resources.PS3.stick_back, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.right_stick.x, debugDraw.positions.PS3.right_stick.y)
        visual = debugDraw.resources.PS3.right_stick_front
        if debugDraw.input.state.rightstick then visual = debugDraw.resources.PS3.right_stick_front_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, 
                           debugDraw.positions.PS3.right_stick.x - 20*x, debugDraw.positions.PS3.right_stick.y - 20*y)

        -- face
        visual = debugDraw.resources.PS3.cross
        if debugDraw.input.state.fdown then visual = debugDraw.resources.PS3.cross_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.35, 0.35, debugDraw.positions.PS3.face_down.x, debugDraw.positions.PS3.face_down.y)
        visual = debugDraw.resources.PS3.triangle
        if debugDraw.input.state.fup then visual = debugDraw.resources.PS3.triangle_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.35, 0.35, debugDraw.positions.PS3.face_up.x, debugDraw.positions.PS3.face_up.y)
        visual = debugDraw.resources.PS3.square
        if debugDraw.input.state.fleft then visual = debugDraw.resources.PS3.square_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.35, 0.35, debugDraw.positions.PS3.face_left.x, debugDraw.positions.PS3.face_left.y)
        visual = debugDraw.resources.PS3.circle
        if debugDraw.input.state.fright then visual = debugDraw.resources.PS3.circle_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.35, 0.35, debugDraw.positions.PS3.face_right.x, debugDraw.positions.PS3.face_right.y)

        -- l1r1
        visual = debugDraw.resources.PS3.l1
        if debugDraw.input.state.l1 then visual = debugDraw.resources.PS3.l1_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.l1.x, debugDraw.positions.PS3.l1.y)
        visual = debugDraw.resources.PS3.r1
        if debugDraw.input.state.r1 then visual = debugDraw.resources.PS3.r1_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.r1.x, debugDraw.positions.PS3.r1.y)

        -- l2r2
        visual = debugDraw.resources.PS3.l2
        local v = debugDraw.input.state.l2 or 0
        if v > 0.5 then visual = debugDraw.resources.PS3.l2_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.l2.x, debugDraw.positions.PS3.l2.y)
        visual = debugDraw.resources.PS3.r2
        local v = debugDraw.input.state.r2 or 0
        if v > 0.5 then visual = debugDraw.resources.PS3.r2_down end
        love.graphics.draw(visual, fg.screen_width, fg.screen_height, 0, 0.5, 0.5, debugDraw.positions.PS3.r2.x, debugDraw.positions.PS3.r2.y)
    end
end

return debugDraw

