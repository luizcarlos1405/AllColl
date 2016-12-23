local vector = require("../libs/vector-light")
isColl = function(aabb1, aabb2)
  return (aabb1.x + aabb1.w > aabb2.x and aabb2.x + aabb2.w > aabb1.x) and (aabb1.y + aabb1.h > aabb2.y and aabb2.y + aabb2.h > aabb1.y)
end
mtv = function(fix, move)
  local top = fix.y - (move.y + move.h)
  local bottom = (fix.y + fix.h) - move.y
  local left = fix.x - (move.x + move.w)
  local right = (fix.x + fix.w) - move.x
  local min = math.min(math.abs(top), math.abs(bottom), math.abs(left), math.abs(right))
  if min == math.abs(top) then
    return 0, top, "top"
  elseif min == math.abs(bottom) then
    return 0, bottom, "bottom"
  elseif min == math.abs(left) then
    return left, 0, "left"
  elseif min == math.abs(right) then
    return right, 0, "right"
  end
end
