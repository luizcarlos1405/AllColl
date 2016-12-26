require("allcoll")
local allcoll = require("allcoll")
local aabb = require("aabb")
local polygon = require("polygon")
local rectangle = require("rectangle")
love.load = function()
  AC = allcoll()
  aabb1 = rectangle(AC, 0, 100, 100, "dynamic", "middle", "S1")
  aabb2 = polygon(AC, {
    0,
    -50,
    30,
    -20,
    10,
    40,
    -10,
    40,
    -30,
    -20
  }, nil, nil, "dynamic", {
    0,
    0
  }, "S2")
  aabb3 = polygon(AC, nil, nil, nil, "static", {
    50,
    50
  }, "S3")
  floor = rectangle(AC, 0, 900, 100, "static", "middle", "floor")
  aabb1:moveTo(200, 200)
  aabb2:moveTo(600, 200)
  aabb3:moveTo(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  return floor:moveTo(love.graphics.getWidth() / 2, love.graphics.getHeight() - 50)
end
love.update = function(dt)
  AC:update(dt)
  if love.keyboard.isDown("w") then
    aabb1:move(0, -400 * dt)
  end
  if love.keyboard.isDown("a") then
    aabb1:move(-400 * dt, 0)
  end
  if love.keyboard.isDown("s") then
    aabb1:move(0, 400 * dt)
  end
  if love.keyboard.isDown("d") then
    aabb1:move(400 * dt, 0)
  end
  if love.keyboard.isDown("e") then
    aabb1:rotate(dt)
  end
  if love.keyboard.isDown("q") then
    aabb1:rotate(-dt)
  end
  if love.keyboard.isDown("r") then
    aabb1:setAngle(math.pi / 4)
  end
  if love.keyboard.isDown("i") then
    aabb2:move(0, -400 * dt)
  end
  if love.keyboard.isDown("j") then
    aabb2:move(-400 * dt, 0)
  end
  if love.keyboard.isDown("k") then
    aabb2:move(0, 400 * dt)
  end
  if love.keyboard.isDown("l") then
    aabb2:move(400 * dt, 0)
  end
  if love.keyboard.isDown("o") then
    aabb2:rotate(dt)
  end
  if love.keyboard.isDown("u") then
    aabb2:rotate(-dt)
  end
  if love.keyboard.isDown("p") then
    aabb2:setAngle(math.pi / 4)
  end
  return aabb3:rotate(dt)
end
love.draw = function()
  aabb1:drawShape()
  aabb2:drawShape()
  aabb3:drawShape()
  floor:drawShape()
  return love.graphics.print("S1.r: " .. tostring(aabb1.r) .. "\nS2.r: " .. tostring(aabb2.r) .. ".\nMove the Rectangle with W A S D and the Pentagon with I J K L.\nRotate the Rectantle with Q E and the Pentagon with U O.\nThe triangle is static.", 20, 20)
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end
