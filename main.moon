require "allcoll"
allcoll   = require "allcoll"
aabb      = require "aabb"
rectangle = require "rectangle"

love.load = ->
    export AC = allcoll!
    export aabb1 = rectangle(AC, 200, 200, 0, 100, 100, "dynamic", "middle")
    export aabb2 = rectangle(AC, love.graphics.getWidth!/2, love.graphics.getHeight!/2, 0, 100, 100, "dynamic", "middle")

love.update = (dt) ->
    if love.keyboard.isDown("w")
        aabb1\move(0, -200*dt)
    elseif love.keyboard.isDown("a")
        aabb1\move(-200*dt, 0)
    elseif love.keyboard.isDown("s")
        aabb1\move(0, 200*dt)
    elseif love.keyboard.isDown("d")
        aabb1\move(200*dt, 0)
    if love.keyboard.isDown("e")
        aabb1\rotate(dt)
    if love.keyboard.isDown("q")
        aabb1\rotate(-dt)
    if love.keyboard.isDown("r")
        aabb1\setAngle(math.pi/4)

    if love.keyboard.isDown("i")
        aabb2\move(0, -200*dt)
    elseif love.keyboard.isDown("j")
        aabb2\move(-200*dt, 0)
    elseif love.keyboard.isDown("k")
        aabb2\move(0, 200*dt)
    elseif love.keyboard.isDown("l")
        aabb2\move(200*dt, 0)
    if love.keyboard.isDown("o")
        aabb2\rotate(dt)
    if love.keyboard.isDown("u")
        aabb2\rotate(-dt)
    if love.keyboard.isDown("p")
        aabb2\setAngle(math.pi/4)



love.draw = ->
    aabb1\drawShape!
    aabb2\drawShape!

    love.graphics.print("S1.r: #{aabb1.r}\nS2.r: #{aabb2.r}", 20, 20)

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit()
