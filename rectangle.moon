-- Rectangles are polygons and they can be rotated, for rectangular shapes that can
-- be rotated is better a rectangle than a 4 sides polygon

vector = require "../libs/vector-light"

class rectangle
    new: (AC, x = 0, y = 0, r = 0, w = 42, h = 42, behavior = "static", offset = {0, 0}, name = "aabb") =>
        @AC       = AC
        @x        = x
        @y        = y
        @r        = 0
        @w        = w
        @h        = h
        @behavior = behavior
        @name     = name
        @type     = "rectangle"

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
        @x += dx
        @y += dy
        for i = 1, #@points
            @points[i].x += dx
            @points[i].y += dy

        for shape in *@AC.shapes
            continue if shape == @
            coll, mtv = @AC\isColl(@, shape)
            -- if coll
            --     @x += mtv.x
            --     @y += mtv.y
            --     for i = 1, #@points
            --         @points[i].x += mtv.x
            --         @points[i].y += mtv.y
            -- else
            --     print "NO COLLISION"

    moveTo: (x, y) =>
        @x = x
        @y = y
        @points = {
            {x: @x - @offset.x,      y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y + @h}
            {x: @x - @offset.x,      y: @y - @offset.y + @h}
        }

    rotate: (da) =>
        @r += da
        for i = 1, #@points
            nx, ny = vector.rotate(da, @points[i].x - @x, @points[i].y - @y)
            @points[i].x = nx + @x
            @points[i].y = ny + @y
        -- mantém @r entre -2*pi e 2*pi
        if @r > 2*math.pi
            @r = @r % (2*math.pi)
        elseif @r < -2*math.pi
            @r = -@r % (2*math.pi)

    setAngle: (a) =>
        @rotate(a-@r)
        @r == a
        -- mantém @r entre -2*pi e 2*pi
        if @r > 2*math.pi
            @r = @r % (2*math.pi)
        elseif @r < 0
            @r = 2*math.pi - @r % (2*math.pi)


return rectangle
