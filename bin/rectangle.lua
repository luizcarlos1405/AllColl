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
      self.x = self.x + dx
      self.y = self.y + dy
      for i = 1, #self.points do
        self.points[i].x = self.points[i].x + dx
        self.points[i].y = self.points[i].y + dy
      end
      local _list_0 = self.AC.shapes
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local shape = _list_0[_index_0]
          if shape == self then
            _continue_0 = true
            break
          end
          local coll, mtv = self.AC:isColl(self, shape)
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    moveTo = function(self, x, y)
      self.x = x
      self.y = y
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
    end,
    rotate = function(self, da)
      self.r = self.r + da
      for i = 1, #self.points do
        local nx, ny = vector.rotate(da, self.points[i].x - self.x, self.points[i].y - self.y)
        self.points[i].x = nx + self.x
        self.points[i].y = ny + self.y
      end
      if self.r > 2 * math.pi then
        self.r = self.r % (2 * math.pi)
      elseif self.r < -2 * math.pi then
        self.r = -self.r % (2 * math.pi)
      end
    end,
    setAngle = function(self, a)
      self:rotate(a - self.r)
      local _ = self.r == a
      if self.r > 2 * math.pi then
        self.r = self.r % (2 * math.pi)
      elseif self.r < 0 then
        self.r = 2 * math.pi - self.r % (2 * math.pi)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, AC, x, y, r, w, h, behavior, offset, name)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if r == nil then
        r = 0
      end
      if w == nil then
        w = 42
      end
      if h == nil then
        h = 42
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
        name = "aabb"
      end
      self.AC = AC
      self.x = x
      self.y = y
      self.r = 0
      self.w = w
      self.h = h
      self.behavior = behavior
      self.name = name
      self.type = "rectangle"
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
      return self.AC:addShape(self)
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
