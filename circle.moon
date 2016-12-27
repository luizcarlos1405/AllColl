-- Rectangles are polygons and they can be rotated, for rectangular shapes that can
-- be rotated is better a circle than a 4 sides polygon

vector = require "../libs/vector-light"

class circle
    new: (r = 0, behavior = "static", name = "circle") =>
        @x        = 0
        @y        = 0
        @r        = r
        @behavior = behavior
        @name     = name
        @type     = "circle"

        if behavior ~= "static" and behavior ~= "dynamic"
            error("Invalid shape behavior. Valids shape behaviors are 'kynetic' and 'dynamic'")

        -- Adiciona à tabe de shapes
        AC\addShape(@)

    drawShape: =>
        love.graphics.circle("line", @x, @y, @r)

        love.graphics.setColor(255, 0, 255)
        love.graphics.setPointSize(4)
        love.graphics.points(@x, @y)
        love.graphics.setColor(255, 255, 255)

    move: (dx, dy) =>
        @x += dx
        @y += dy

        for shape in *AC.shapes
            continue if shape == @
            coll, mtv = AC\isColliding(shape, @)
            if coll
                @collided(shape, mtv, false)

    moveTo: (x, y) =>
        @x = x
        @y = y

    -- Callback function that treats collision
    collided: (other, mtv, rotated) =>
        AC\collisionStandartTreatment(@, other, mtv, rotated)

return circle
