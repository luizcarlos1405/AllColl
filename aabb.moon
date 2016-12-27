-- AABB is rectangular shape that does'nt allow rotation

class aabb
    new: (w = 42, h = 42, behavior = "static", offset = {0, 0}, name = "aabb") =>
        @x        = 0
        @y        = 0
        @w        = w
        @h        = h
        @behavior = behavior
        @name     = name
        @type     = "aabb"

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

        AC\addShape(@)

    drawShape: =>
        love.graphics.rectangle("line", @x - @offset.x, @y - @offset.y, @w, @h)
        love.graphics.setColor(255, 0, 255)
        love.graphics.setPointSize(4)
        love.graphics.points(@x, @y)
        love.graphics.setColor(255, 255, 255)

    move: (dx, dy) =>
        @x += dx
        @y += dy

        @points = {
            {x: @x - @offset.x,      y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y + @h}
            {x: @x - @offset.x,      y: @y - @offset.y + @h}
        }

        for shape in *AC.shapes
            continue if shape == @
            coll, mtv = AC\isColliding(shape, @)
            if coll
                @collided(shape, mtv, false)

    moveTo: (x, y) =>
        @x = x
        @y = y

        @points = {
            {x: @x - @offset.x,      y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y}
            {x: @x - @offset.x + @w, y: @y - @offset.y + @h}
            {x: @x - @offset.x,      y: @y - @offset.y + @h}
        }

    collided: (shape, mtv,  rotated) =>
        AC\collisionStandartTreatment(@, shape, mtv, rotated)

return aabb
