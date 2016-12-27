-- Polygons have to be concave, they can be rotated

vector = require "../libs/vector-light"

class polygon
    new: (points = {0, 0, 100, 0, 100, 100}, r = 0, behavior = "static", name = "polygon") =>
        if #points % 2 ~= 0 or #points < 6
            error("Not full points or not enough points")
        @x        = 0
        @y        = 0
        @r        = r
        @behavior = behavior
        @name     = name
        @type     = "polygon"
        @points   = {}

        for i = 1, math.ceil(#points/2)
            @points[i] = {}
            @points[i].x = points[2*(i-1)+1]
            if points[i+1]
                @points[i].y = points[2*(i-1)+2]

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

    collided: (other, mtv, rotated) =>
        AC\collisionStandartTreatment(@, other, mtv, rotated)

return polygon
