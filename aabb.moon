-- AABB is rectangular shape that does'nt allow rotation

class aabb
    new: (AC, x = 0, y = 0, w = 42, h = 42, behavior = "static", offset = {0, 0}, name = "aabb") =>
        @AC       = AC
        @x        = x
        @y        = y
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

        @AC\addShape(@)

    drawShape: =>
        love.graphics.rectangle("line", @x - @offset.x, @y - @offset.y, @w, @h)
        love.graphics.setColor(255, 0, 255)
        love.graphics.setPointSize(4)
        love.graphics.points(@x, @y)
        love.graphics.setColor(255, 255, 255)

    move: (dx, dy) =>
        @x += dx
        @y += dy

        for shape in *@AC.shapes
            continue if shape == @

            coll, mtv = @AC\isColl(@, shape)
            if coll
                if shape.behavior == "static"
                    @.x += -mtv.x
                    @.y += -mtv.y

                elseif shape.behavior == "dynamic"
                    @.x     += -mtv.x/2
                    @.y     += -mtv.y/2
                    shape.x += mtv.x/2
                    shape.y += mtv.y/2

    moveTo: (x, y) =>
        @x = x
        @y = y

return aabb
