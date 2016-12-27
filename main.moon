require "allcoll"
aabb      = require "aabb"
circle    = require "circle"
polygon   = require "polygon"
rectangle = require "rectangle"

love.load = ->
    export floor  = rectangle(900, 100, 0, "static", "middle", "floor")
    export shape1 = circle(50, "dynamic", "circleMenor")
    export shape2 = circle(60, "dynamic", "circleMaior")
    export shape3 = polygon(nil, nil, "static", "polygon2")

    shape1\moveTo(200, 200)
    shape2\moveTo(600, 200)
    shape3\moveTo(love.graphics.getWidth!/2, love.graphics.getHeight!/2)
    floor\moveTo(love.graphics.getWidth!/2, love.graphics.getHeight!-50)

    AC\setGravity(0, 200)

love.update = (dt) ->

    if love.keyboard.isDown("w")
        shape1\move(0, -400*dt)
    if love.keyboard.isDown("a")
        shape1\move(-400*dt, 0)
    if love.keyboard.isDown("s")
        shape1\move(0, 400*dt)
    if love.keyboard.isDown("d")
        shape1\move(400*dt, 0)

    if love.keyboard.isDown("i")
        shape2\move(0, -400*dt)
    if love.keyboard.isDown("j")
        shape2\move(-400*dt, 0)
    if love.keyboard.isDown("k")
        shape2\move(0, 400*dt)
    if love.keyboard.isDown("l")
        shape2\move(400*dt, 0)
    if love.keyboard.isDown("o")
        shape2\rotate(dt*3)
    if love.keyboard.isDown("u")
        shape2\rotate(-dt*3)
    if love.keyboard.isDown("p")
        shape2\setAngle(math.pi/4)

    -- shape1\rotate(dt)
    -- shape2\rotate(dt)
    -- shape3\rotate(dt)
    -- AC\update(dt)

love.draw = ->
    shape1\drawShape!
    shape2\drawShape!
    shape3\drawShape!
    floor\drawShape!

    love.graphics.print("S1.r: #{shape1.r}\nS2.r: #{shape2.r}.
Move the Rectangle with W A S D and the Pentagon with I J K L.
Rotate the Rectantle with Q E and the Pentagon with U O.
The triangle is static.", 20, 20)

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit()
