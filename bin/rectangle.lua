local vector = require("../libs/vector-light")
local rectangle
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
    __init = function(self, w, h, r, behavior, offset, name)
      if w == nil then
        w = 42
      end
      if h == nil then
        h = 42
      end
      if r == nil then
        r = 0
      end
      if behavior == nil then
        behavior = "static"
      end
      if offset == nil then
        offset = {
          0,
          0
        }
      end
      if name == nil then
        name = "rectangle"
      end
      self.x = 0
      self.y = 0
      self.r = 0
      self.w = w
      self.h = h
      self.behavior = behavior
      self.name = name
      self.type = "rectangle"
      if behavior ~= "static" and behavior ~= "dynamic" then
        error("Invalid shape behavior. Valids shape behaviors are 'kynetic' and 'dynamic'")
      end
      if offset == "middle" then
        self.offset = {
          x = w / 2,
          y = h / 2
        }
      else
        self.offset = {
          x = offset[1],
          y = offset[2]
        }
      end
      self.points = {
        {
          x = self.x - self.offset.x,
          y = self.y - self.offset.y
        },
        {
          x = self.x - self.offset.x + self.w,
          y = self.y - self.offset.y
        },
        {
          x = self.x - self.offset.x + self.w,
          y = self.y - self.offset.y + self.h
        },
        {
          x = self.x - self.offset.x,
          y = self.y - self.offset.y + self.h
        }
      }
      self:setAngle(r)
      return AC:addShape(self)
    end,
    __base = _base_0,
    __name = "rectangle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  rectangle = _class_0
end
return rectangle
