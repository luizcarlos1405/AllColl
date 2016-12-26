local vector = require("../libs/vector-light")
local allcoll
do
  local _class_0
  local _base_0 = {
    isColl = function(self, fix, move)
      local mtv = {
        x = 0,
        y = 0
      }
      if fix.type == "aabb" and move.type == "aabb" then
        local coll = (fix.x + fix.w - fix.offset.x > move.x - move.offset.x and move.x + move.w - move.offset.x > fix.x - fix.offset.x) and (fix.y + fix.h - fix.offset.y > move.y - move.offset.y and move.y + move.h - move.offset.y > fix.y - fix.offset.y)
        if coll then
          local top = fix.y - (move.y + move.h) - fix.offset.y + move.offset.y
          local bottom = (fix.y + fix.h) - move.y - fix.offset.y + move.offset.y
          local left = fix.x - (move.x + move.w) - fix.offset.x + move.offset.x
          local right = (fix.x + fix.w) - move.x - fix.offset.x + move.offset.x
          local min = math.min(math.abs(top), math.abs(bottom), math.abs(left), math.abs(right))
          if min == math.abs(top) then
            mtv = {
              x = 0,
              y = top
            }
          elseif min == math.abs(bottom) then
            mtv = {
              x = 0,
              y = bottom
            }
          elseif min == math.abs(left) then
            mtv = {
              x = left,
              y = 0
            }
          elseif min == math.abs(right) then
            mtv = {
              x = right,
              y = 0
            }
          end
          return true, mtv
        end
        return false, mtv
      elseif fix.type == "rectangle" and move.type == "rectangle" then
        local Vx, Vy = nil, nil
        mtv = { }
        local proj = nil
        local overlap = nil
        local minOverlap = nil
        local fixMinProj = nil
        local fixMaxProj = nil
        local moveMinProj = nil
        local moveMaxProj = nil
        for i = 1, #fix.points do
          if i == #fix.points then
            Vx, Vy = vector.sub(fix.points[1].x, fix.points[1].y, fix.points[i].x, fix.points[i].y)
          else
            Vx, Vy = vector.sub(fix.points[i + 1].x, fix.points[i + 1].y, fix.points[i].x, fix.points[i].y)
          end
          Vx, Vy = vector.perpendicular(Vx, Vy)
          Vx, Vy = vector.normalize(Vx, Vy)
          for j = 1, #fix.points do
            if j == 1 then
              fixMinProj = vector.dot(fix.points[j].x, fix.points[j].y, Vx, Vy)
              fixMaxProj = fixMinProj
            else
              proj = vector.dot(fix.points[j].x, fix.points[j].y, Vx, Vy)
              fixMinProj = math.min(proj, fixMinProj)
              fixMaxProj = math.max(proj, fixMaxProj)
            end
          end
          for j = 1, #move.points do
            if j == 1 then
              moveMinProj = vector.dot(move.points[j].x, move.points[j].y, Vx, Vy)
              moveMaxProj = moveMinProj
            else
              proj = vector.dot(move.points[j].x, move.points[j].y, Vx, Vy)
              moveMinProj = math.min(proj, moveMinProj)
              moveMaxProj = math.max(proj, moveMaxProj)
            end
          end
          if fixMaxProj < moveMinProj or moveMaxProj < fixMinProj then
            return false, {
              x = 0,
              y = 0
            }
          end
          local auxOverlap1 = fixMaxProj - moveMinProj
          local auxOverlap2 = fixMinProj - moveMaxProj
          if math.abs(auxOverlap1) < math.abs(auxOverlap2) then
            overlap = auxOverlap1
          else
            overlap = auxOverlap2
          end
          if i == 1 then
            minOverlap = overlap
            mtv = {
              Vx,
              Vy
            }
          elseif math.abs(minOverlap) > math.abs(overlap) then
            minOverlap = overlap
            mtv = {
              Vx,
              Vy
            }
          end
        end
        for i = 1, #move.points do
          if i == #move.points then
            Vx, Vy = vector.sub(move.points[1].x, move.points[1].y, move.points[i].x, move.points[i].y)
          else
            Vx, Vy = vector.sub(move.points[i + 1].x, move.points[i + 1].y, move.points[i].x, move.points[i].y)
          end
          Vx, Vy = vector.perpendicular(Vx, Vy)
          Vx, Vy = vector.normalize(Vx, Vy)
          for j = 1, #move.points do
            proj = vector.dot(move.points[i].x, move.points[i].y, Vx, Vy)
            moveMinProj = math.min(proj, moveMinProj)
            moveMaxProj = math.max(proj, moveMaxProj)
          end
          for j = 1, #move.points do
            proj = vector.dot(move.points[i].x, move.points[i].y, Vx, Vy)
            moveMinProj = math.min(proj, moveMinProj)
            moveMaxProj = math.max(proj, moveMaxProj)
          end
          if fixMaxProj < moveMinProj or moveMaxProj < fixMinProj then
            return false, {
              x = 0,
              y = 0
            }
          end
          local auxOverlap1 = fixMaxProj - moveMinProj
          local auxOverlap2 = fixMinProj - moveMaxProj
          if math.abs(auxOverlap1) < math.abs(auxOverlap2) then
            overlap = auxOverlap1
          else
            overlap = auxOverlap2
          end
          if i == 1 then
            minOverlap = overlap
            mtv = {
              Vx,
              Vy
            }
          elseif math.abs(minOverlap) > math.abs(overlap) then
            minOverlap = overlap
            mtv = {
              Vx,
              Vy
            }
          end
        end
        print("unit x: " .. tostring(mtv[1]) .. " y: " .. tostring(mtv[2]))
        print("minOverlap: " .. tostring(minOverlap))
        mtv.x, mtv.y = vector.mul(minOverlap, mtv[1], mtv[2])
        print("mtv.x " .. tostring(mtv.x) .. " mtv.y " .. tostring(mtv.y))
        return true, mtv
      end
    end,
    addShape = function(self, shape)
      return table.insert(self.shapes, shape)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.shapes = { }
    end,
    __base = _base_0,
    __name = "allcoll"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  allcoll = _class_0
end
return allcoll
