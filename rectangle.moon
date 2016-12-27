-- Rectangles are polygons and they can be rotated, for rectangular shapes that can
-- be rotated is better a rectangle than a 4 sides polygon

vector = require "../libs/vector-light"

class rectangle
    new: (w = 42, h = 42, r = 0, behavior = "static", offset = {0, 0}, name = "rectangle") =>
        @x        = 0
        @y        = 0
        @r        = 0
        @w        = w
        @h        = h
        @behavior = behavior
        @name     = name
        @type     = "rectangle"

        if behavior ~= "static" and behavior ~= "dynamic"
            error("Invalid shape behavior. Valids shape behaviors are 'kynetic' and 'dynamic'")

        if offset == "middle"
            @offset = {x: w/2, y:h/2}
        else
            @offset = {x:offset[1], y:offset[2]}

        @points = {
            {x: @x - @offset.x,      y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y + @h}
            {x: @x - @offset.x,      y: @y - @offset.y + @h}
        }

        @setAngle(r)
        -- Adiciona à tabe de shapes
        AC\addShape(@)

    drawShape: =>
        for i = 1, #@points
            -- print "x#{i} #{@points[i].x} y#{i} #{@points[i].y}"
            if i == #@points
                love.graphics.setColor(0, 0, 255)
                love.graphics.line(@points[1].x, @points[1].y
                    @points[i].x, @points[i].y)
                love.graphics.setColor(255, 255, 255)

            else
                love.graphics.line(@points[i].x, @points[i].y
                    @points[i+1].x, @points[i+1].y)

        love.graphics.setColor(255, 0, 255)
        love.graphics.setPointSize(4)
        love.graphics.points(@x, @y)
        love.graphics.setColor(255, 255, 255)

    move: (dx, dy) =>
        AC\movePolygon(dx, dy, @)

    moveTo: (x, y) =>
        AC\movePolygonTo(x, y, @)

    rotate: (da) =>
        AC\rotatePolygon(da, @)

    setAngle: (a) =>
        AC\setPolygonAngle(a, @)

    -- Callback function that treats collision
    collided: (other, mtv, rotated) =>
        AC\collisionStandartTreatment(@, other, mtv, rotated)

return rectangle
