require("allcoll")
local allcoll = require("allcoll")
local aabb = require("aabb")
local rectangle = require("rectangle")
love.load = function()
  AC = allcoll()
  aabb1 = rectangle(AC, 200, 200, 0, 100, 100, "dynamic", "middle")
  aabb2 = rectangle(AC, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 100, 100, "dynamic", "middle")
end
love.update = function(dt)
  if love.keyboard.isDown("w") then
    aabb1:move(0, -200 * dt)
  elseif love.keyboard.isDown("a") then
    aabb1:move(-200 * dt, 0)
  elseif love.keyboard.isDown("s") then
    aabb1:move(0, 200 * dt)
  elseif love.keyboard.isDown("d") then
    aabb1:move(200 * dt, 0)
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
    aabb2:move(0, -200 * dt)
  elseif love.keyboard.isDown("j") then
    aabb2:move(-200 * dt, 0)
  elseif love.keyboard.isDown("k") then
    aabb2:move(0, 200 * dt)
  elseif love.keyboard.isDown("l") then
    aabb2:move(200 * dt, 0)
  end
  if love.keyboard.isDown("o") then
    aabb2:rotate(dt)
  end
  if love.keyboard.isDown("u") then
    aabb2:rotate(-dt)
  end
  if love.keyboard.isDown("p") then
    return aabb2:setAngle(math.pi / 4)
  end
end
love.draw = function()
  aabb1:drawShape()
  aabb2:drawShape()
  return love.graphics.print("S1.r: " .. tostring(aabb1.r) .. "\nS2.r: " .. tostring(aabb2.r), 20, 20)
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end
