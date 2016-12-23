require("allcoll")
local aabb = require("aabb")
love.load = function()
  aabb1 = aabb(20, 20, 100, 100)
  aabb2 = aabb(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 50, 100, 100)
end
love.update = function(dt)
  aabb1:update(dt)
  if isColl(aabb1, aabb2) then
    love.graphics.setColor(0, 0, 255)
    local mtvx, mtvy, side = mtv(aabb1, aabb2)
    aabb2.x = aabb2.x + (mtvx / 2)
    aabb2.y = aabb2.y + (mtvy / 2)
    aabb1.x = aabb1.x - (mtvx / 2)
    aabb1.y = aabb1.y - (mtvy / 2)
  else
    return love.graphics.setColor(255, 255, 255)
  end
end
love.draw = function()
  aabb1:draw()
  aabb2:draw()
  if isColl(aabb1, aabb2) then
    local mtvx, mtvy, side = mtv(aabb1, aabb2)
    return love.graphics.print("mtvx = " .. tostring(mtvx) .. "\nmtvy = " .. tostring(mtvy) .. "\nside = " .. tostring(side))
  end
end
love.keypressed = function(key)
  if key == "escape" then
    return love.event.quit()
  end
end
