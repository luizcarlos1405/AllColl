require "allcoll"
aabb = require "aabb"

love.load = ->
    export aabb1 = aabb(20, 20, 100, 100)
    export aabb2 = aabb(love.graphics.getWidth!/2 - 50, love.graphics.getHeight!/2 - 50, 100, 100)

love.update = (dt) ->
    aabb1\update(dt)

    if isColl(aabb1, aabb2)
        love.graphics.setColor(0, 0, 255)
        mtvx, mtvy, side = mtv(aabb1, aabb2)
        aabb2.x += mtvx/2
        aabb2.y += mtvy/2
        aabb1.x -= mtvx/2
        aabb1.y -= mtvy/2
    else
        love.graphics.setColor(255, 255, 255)

love.draw = ->
    aabb1\draw!
    aabb2\draw!

    if isColl(aabb1, aabb2)
        mtvx, mtvy, side = mtv(aabb1, aabb2)
        love.graphics.print("mtvx = #{mtvx}\nmtvy = #{mtvy}\nside = #{side}")

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit()
