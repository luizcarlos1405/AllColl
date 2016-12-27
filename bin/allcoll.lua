local vector = require("../libs/vector-light")
local allcoll
do
  local _class_0
  local _base_0 = {
    setGravity = function(self, gx, gy)
      self.gravity = {
        x = gx,
        y = gy
      }
    end,
    isColliding = function(self, fix, move)
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
      elseif fix.type == "circle" and move.type == "circle" then
        local Vx, Vy = move.x - fix.x, move.y - fix.y
        local distance = vector.len(Vx, Vy)
        if distance < fix.r + move.r then
          Vx, Vy = vector.normalize(Vx, Vy)
          mtv = {
            x = Vx * (fix.r + move.r - distance),
            y = Vy * (fix.r + move.r - distance)
          }
          return true, mtv
        else
          return false, {
            x = 0,
            y = 0
          }
        end
      elseif fix.type ~= "circle" and move.type ~= "circle" then
        local overlap = nil
        local minOverlap1 = nil
        local minOverlap2 = nil
        local mtv1, mtv2
        mtv, mtv1, mtv2 = { }
        if fix.type == "polygon" then
          minOverlap1, mtv1 = self:processAllPoints(fix, move)
        else
          minOverlap1, mtv1 = self:processRectanglePoints(fix, move)
        end
        if minOverlap1 == 0 then
          return false, {
            x = 0,
            y = 0
          }
        end
        if move.type == "polygon" then
          minOverlap2, mtv2 = self:processAllPoints(move, fix)
        else
          minOverlap2, mtv2 = self:processRectanglePoints(move, fix)
        end
        if minOverlap2 == 0 then
          return false, {
            x = 0,
            y = 0
          }
        end
        if math.abs(minOverlap1) <= math.abs(minOverlap2) then
          mtv = mtv1
          overlap = minOverlap1
        else
          mtv = {
            -mtv2[1],
            -mtv2[2]
          }
          overlap = minOverlap2
        end
        mtv.x, mtv.y = vector.mul(overlap, mtv[1], mtv[2])
        return true, mtv
      end
    end,
    addShape = function(self, shape)
      return table.insert(self.shapes, shape)
    end,
    processAllPoints = function(self, S1, S2)
      local mtv = {
        0,
        0
      }
      local proj = 0
      local Vx, Vy = nil, nil
      local overlap = 0
      local S1MinProj = nil
      local S1MaxProj = nil
      local S2MinProj = nil
      local S2MaxProj = nil
      local minOverlap = nil
      for i = 1, #S1.points do
        if i == #S1.points then
          Vx, Vy = vector.sub(S1.points[1].x, S1.points[1].y, S1.points[i].x, S1.points[i].y)
        else
          Vx, Vy = vector.sub(S1.points[i + 1].x, S1.points[i + 1].y, S1.points[i].x, S1.points[i].y)
        end
        Vx, Vy = vector.perpendicular(Vx, Vy)
        Vx, Vy = vector.normalize(Vx, Vy)
        for j = 1, #S1.points do
          if j == 1 then
            S1MinProj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
            S1MaxProj = S1MinProj
          else
            proj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
            S1MinProj = math.min(proj, S1MinProj)
            S1MaxProj = math.max(proj, S1MaxProj)
          end
        end
        for j = 1, #S2.points do
          if j == 1 then
            S2MinProj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
            S2MaxProj = S2MinProj
          else
            proj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
            S2MinProj = math.min(proj, S2MinProj)
            S2MaxProj = math.max(proj, S2MaxProj)
          end
        end
        if S1MaxProj < S2MinProj or S2MaxProj < S1MinProj then
          return 0, {
            0,
            0
          }
        end
        local auxOverlap1 = S1MaxProj - S2MinProj
        local auxOverlap2 = S1MinProj - S2MaxProj
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
        elseif math.abs(overlap) < math.abs(minOverlap) then
          minOverlap = overlap
          mtv = {
            Vx,
            Vy
          }
        end
      end
      return minOverlap, mtv
    end,
    processRectanglePoints = function(self, S1, S2)
      local mtv = {
        0,
        0
      }
      local proj = 0
      local Vx, Vy = nil, nil
      local overlap = 0
      local S1MinProj = nil
      local S1MaxProj = nil
      local S2MinProj = nil
      local S2MaxProj = nil
      local minOverlap = nil
      local S1points = {
        {
          x = S1.points[1].x,
          y = S1.points[1].y
        },
        {
          x = S1.points[2].x,
          y = S1.points[2].y
        },
        {
          x = S1.points[4].x,
          y = S1.points[4].y
        }
      }
      for i = 1, 2 do
        if i == 1 then
          Vx, Vy = vector.sub(S1points[2].x, S1points[2].y, S1points[1].x, S1points[1].y)
        else
          Vx, Vy = vector.sub(S1points[3].x, S1points[3].y, S1points[1].x, S1points[1].y)
        end
        Vx, Vy = vector.perpendicular(Vx, Vy)
        Vx, Vy = vector.normalize(Vx, Vy)
        for j = 1, #S1.points do
          if j == 1 then
            S1MinProj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
            S1MaxProj = S1MinProj
          else
            proj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
            S1MinProj = math.min(proj, S1MinProj)
            S1MaxProj = math.max(proj, S1MaxProj)
          end
        end
        for j = 1, #S2.points do
          if j == 1 then
            S2MinProj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
            S2MaxProj = S2MinProj
          else
            proj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
            S2MinProj = math.min(proj, S2MinProj)
            S2MaxProj = math.max(proj, S2MaxProj)
          end
        end
        if S1MaxProj < S2MinProj or S2MaxProj < S1MinProj then
          return 0, {
            0,
            0
          }
        end
        local auxOverlap1 = S1MaxProj - S2MinProj
        local auxOverlap2 = S1MinProj - S2MaxProj
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
        elseif math.abs(overlap) < math.abs(minOverlap) then
          minOverlap = overlap
          mtv = {
            Vx,
            Vy
          }
        end
      end
      return minOverlap, mtv
    end,
    rotatePolygon = function(self, da, polygon)
      polygon.r = polygon.r + da
      for i = 1, #polygon.points do
        local nx, ny = vector.rotate(da, polygon.points[i].x - polygon.x, polygon.points[i].y - polygon.y)
        polygon.points[i].x = nx + polygon.x
        polygon.points[i].y = ny + polygon.y
      end
      if polygon.r > 2 * math.pi then
        polygon.r = polygon.r % (2 * math.pi)
      elseif polygon.r < -2 * math.pi then
        polygon.r = -polygon.r % (2 * math.pi)
      end
      local _list_0 = self.shapes
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local shape = _list_0[_index_0]
          if shape == polygon then
            _continue_0 = true
            break
          end
          local coll, mtv = self:isColliding(shape, polygon)
          if coll then
            polygon:collided(shape, mtv, true)
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    setPolygonAngle = function(self, a, polygon)
      local da = a - polygon.r
      polygon.r = a
      for i = 1, #polygon.points do
        local nx, ny = vector.rotate(da, polygon.points[i].x - polygon.x, polygon.points[i].y - polygon.y)
        polygon.points[i].x = nx + polygon.x
        polygon.points[i].y = ny + polygon.y
      end
      if polygon.r > 2 * math.pi then
        polygon.r = polygon.r % (2 * math.pi)
      elseif polygon.r < 0 then
        polygon.r = 2 * math.pi - polygon.r % (2 * math.pi)
      end
    end,
    movePolygon = function(self, dx, dy, polygon)
      polygon.x = polygon.x + dx
      polygon.y = polygon.y + dy
      for i = 1, #polygon.points do
        polygon.points[i].x = polygon.points[i].x + dx
        polygon.points[i].y = polygon.points[i].y + dy
      end
      local _list_0 = self.shapes
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local shape = _list_0[_index_0]
          if shape == polygon then
            _continue_0 = true
            break
          end
          local coll, mtv = self:isColliding(shape, polygon)
          if coll then
            polygon:collided(shape, mtv, false)
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    movePolygonTo = function(self, x, y, polygon)
      local dx, dy = x - polygon.x, y - polygon.y
      polygon.x = polygon.x + dx
      polygon.y = polygon.y + dy
      for i = 1, #polygon.points do
        polygon.points[i].x = polygon.points[i].x + dx
        polygon.points[i].y = polygon.points[i].y + dy
      end
    end,
    update = function(self, dt)
      for i = 1, #self.shapes do
        if self.shapes[i].behavior ~= "static" then
          self.shapes[i]:move(self.gravity.x * dt, self.gravity.y * dt, self.shapes[i])
        end
      end
    end,
    drawAllShapes = function(self)
      for i = 1, #self.shapes do
        self.shapes[i]:draw()
      end
    end,
    collisionStandartTreatment = function(self, a, b, mtv, rotated)
      if rotated then
        if a.behavior == "dynamic" then
          if b.behavior == "static" then
            return a:moveTo(a.x + mtv.x, a.y + mtv.y)
          elseif b.behavior == "dynamic" then
            a:moveTo(a.x + mtv.x / 2, a.y + mtv.y / 2)
            return b:moveTo(b.x - mtv.x / 2, b.y - mtv.y / 2)
          end
        elseif a.behavior == "static" then
          if b.behavior == "dynamic" then
            return b:moveTo(b.x - mtv.x, b.y - mtv.y)
          end
        end
      else
        if b.behavior == "static" then
          return a:moveTo(a.x + mtv.x, a.y + mtv.y)
        elseif b.behavior == "dynamic" then
          a:moveTo(a.x + mtv.x / 2, a.y + mtv.y / 2)
          return b:moveTo(b.x - mtv.x / 2, b.y - mtv.y / 2)
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.shapes = { }
      self.gravity = {
        x = 0,
        y = 0
      }
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
AC = allcoll()
