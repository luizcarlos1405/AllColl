local vector = require("../libs/vector-light")
local polygon
do
  local _class_0
  local _base_0 = {
    drawShape = function(self)
      for i = 1, #self.points do
        if i == #self.points then
          love.graphics.setColor(0, 0, 255)
          love.graphics.line(self.points[1].x, self.points[1].y, self.points[i].x, self.points[i].y)
          love.graphics.setColor(255, 255, 255)
        else
          love.graphics.line(self.points[i].x, self.points[i].y, self.points[i + 1].x, self.points[i + 1].y)
        end
      end
      love.graphics.setColor(255, 0, 255)
      love.graphics.setPointSize(4)
      love.graphics.points(self.x, self.y)
      return love.graphics.setColor(255, 255, 255)
    end,
    move = function(self, dx, dy)
      return AC:movePolygon(dx, dy, self)
    end,
    moveTo = function(self, x, y)
      return AC:movePolygonTo(x, y, self)
    end,
    rotate = function(self, da)
      return AC:rotatePolygon(da, self)
    end,
    setAngle = function(self, a)
      return AC:setPolygonAngle(a, self)
    end,
    collided = function(self, other, mtv, rotated)
      return AC:collisionStandartTreatment(self, other, mtv, rotated)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, points, r, behavior, name)
      if points == nil then
        points = {
          0,
          0,
          100,
          0,
          100,
          100
        }
      end
      if r == nil then
        r = 0
      end
      if behavior == nil then
        behavior = "static"
      end
      if name == nil then
        name = "polygon"
      end
      if #points % 2 ~= 0 or #points < 6 then
        error("Not full points or not enough points")
      end
      self.x = 0
      self.y = 0
      self.r = r
      self.behavior = behavior
      self.name = name
      self.type = "polygon"
      self.points = { }
      for i = 1, math.ceil(#points / 2) do
        self.points[i] = { }
        self.points[i].x = points[2 * (i - 1) + 1]
        if points[i + 1] then
          self.points[i].y = points[2 * (i - 1) + 2]
        end
      end
      self:setAngle(r)
      return AC:addShape(self)
    end,
    __base = _base_0,
    __name = "polygon"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  polygon = _class_0
end
return polygon
