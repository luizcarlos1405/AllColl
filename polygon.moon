-- Rectangles are polygons and they can be rotated, for rectangular shapes that can
-- be rotated is better a rectangle than a 4 sides polygon

vector = require "../libs/vector-light"

class rectangle
    new: (AC, points = {0, 0, 100, 0, 100, 100}, r = 0, h = 42, behavior = "static", offset = {0, 0}, name = "aabb") =>
        if #points % 2 ~= 0 or #points < 6
            error("Not full points or not enough points")
        @AC       = AC
        @x        = offset[1]
        @y        = offset[2]
        @r        = r
        @w        = w
        @h        = h
        @behavior = behavior
        @name     = name
        @type     = "polygon"
        @points   = {}

        if offset == "middle"
            @offset = {x: w/2, y:h/2}
        else
            @offset = {x:offset[1], y:offset[2]}

        for i = 1, math.ceil(#points/2)
            @points[i] = {}
            @points[i].x = points[2*(i-1)+1]
            if points[i+1]
                @points[i].y = points[2*(i-1)+2]

        @setAngle(r)
        -- Adiciona à tabe de shapes
        @AC\addShape(@)

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
        @rotate(a-@r)
        @r == a
        -- mantém @r entre -2*pi e 2*pi
        if @r > 2*math.pi
            @r = @r % (2*math.pi)
        elseif @r < 0
            @r = 2*math.pi - @r % (2*math.pi)


return rectangle
