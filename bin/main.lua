require("allcoll")
local aabb = require("aabb")
local circle = require("circle")
local polygon = require("polygon")
local rectangle = require("rectangle")
love.load = function()
  floor = rectangle(900, 100, 0, "static", "middle", "floor")
  shape1 = circle(50, "dynamic", "circleMenor")
  shape2 = circle(60, "dynamic", "circleMaior")
  shape3 = polygon(nil, nil, "static", "polygon2")
  shape1:moveTo(200, 200)
  shape2:moveTo(600, 200)
  shape3:moveTo(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  floor:moveTo(love.graphics.getWidth() / 2, love.graphics.getHeight() - 50)
  return AC:setGravity(0, 200)
end
love.update = function(dt)
  if love.keyboard.isDown("w") then
    shape1:move(0, -400 * dt)
  end
  if love.keyboard.isDown("a") then
    shape1:move(-400 * dt, 0)
  end
  if love.keyboard.isDown("s") then
    shape1:move(0, 400 * dt)
  end
  if love.keyboard.isDown("d") then
    shape1:move(400 * dt, 0)
  end
  if love.keyboard.isDown("i") then
    shape2:move(0, -400 * dt)
  end
  if love.keyboard.isDown("j") then
    shape2:move(-400 * dt, 0)
  end
  if love.keyboard.isDown("k") then
    shape2:move(0, 400 * dt)
  end
  if love.keyboard.isDown("l") then
    shape2:move(400 * dt, 0)
  end
  if love.keyboard.isDown("o") then
    shape2:rotate(dt * 3)
  end
  if love.keyboard.isDown("u") then
    shape2:rotate(-dt * 3)
  end
  if love.keyboard.isDown("p") then
    return shape2:setAngle(math.pi / 4)
  end
end
love.draw = function()
  shape1:drawShape()
  shape2:drawShape()
  shape3:drawShape()
  floor:drawShape()
  return love.graphics.print("S1.r: " .. tostring(shape1.r) .. "\nS2.r: " .. tostring(shape2.r) .. ".\nMove the Rectangle with W A S D and the Pentagon with I J K L.\nRotate the Rectantle with Q E and the Pentagon with U O.\nThe triangle is static.", 20, 20)
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end
