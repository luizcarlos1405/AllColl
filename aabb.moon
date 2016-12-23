class aabb
    new: (x, y, w, h) =>
        @x = x
        @y = y
        @w = w
        @h = h

    update: (dt) =>
        if love.keyboard.isDown "w"
            @y -= 200 * dt
        if love.keyboard.isDown("a")
            @x -= 200 * dt
        if love.keyboard.isDown("s")
            @y += 200 * dt
        if love.keyboard.isDown("d")
            @x += 200 * dt

    draw: =>
        love.graphics.rectangle("line", @x, @y, @w, @h)

return aabb
