require "allcoll"
allcoll   = require "allcoll"
aabb      = require "aabb"
polygon   = require "polygon"
rectangle = require "rectangle"

love.load = ->
    export AC = allcoll!
    export aabb1 = rectangle(AC, 0, 100, 100, "dynamic", "middle", "S1")
    export aabb2 = polygon(AC, {0,-50,30,-20,10,40,-10,40,-30,-20}, nil, nil, "dynamic", {0, 0}, "S2")
    export aabb3 = polygon(AC, nil, nil, nil, "static", {50, 50}, "S3")

    aabb1\moveTo(200, 200)
    aabb2\moveTo(600, 200)
    aabb3\moveTo(love.graphics.getWidth!/2, love.graphics.getHeight!/2)

love.update = (dt) ->
    if love.keyboard.isDown("w")
        aabb1\move(0, -200*dt)
    if love.keyboard.isDown("a")
        aabb1\move(-200*dt, 0)
    if love.keyboard.isDown("s")
        aabb1\move(0, 200*dt)
    if love.keyboard.isDown("d")
        aabb1\move(200*dt, 0)
    if love.keyboard.isDown("e")
        aabb1\rotate(dt)
    if love.keyboard.isDown("q")
        aabb1\rotate(-dt)
    if love.keyboard.isDown("r")
        aabb1\setAngle(math.pi/4)

    if love.keyboard.isDown("i")
        aabb2\move(0, -200*dt)
    if love.keyboard.isDown("j")
        aabb2\move(-200*dt, 0)
    if love.keyboard.isDown("k")
        aabb2\move(0, 200*dt)
    if love.keyboard.isDown("l")
        aabb2\move(200*dt, 0)
    if love.keyboard.isDown("o")
        aabb2\rotate(dt)
    if love.keyboard.isDown("u")
        aabb2\rotate(-dt)
    if love.keyboard.isDown("p")
        aabb2\setAngle(math.pi/4)

    -- aabb1\rotate(dt)
    -- aabb2\rotate(dt)
    aabb3\rotate(dt)

love.draw = ->
    aabb1\drawShape!
    aabb2\drawShape!
    aabb3\drawShape!

    love.graphics.print("S1.r: #{aabb1.r}\nS2.r: #{aabb2.r}.
Move the Rectangle with W A S D and the Pentagon with I J K L.
Rotate the Rectantle with Q E and the Pentagon with U O.
The triangle is static.", 20, 20)

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit()
