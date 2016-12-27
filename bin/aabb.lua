local aabb
do
  local _class_0
  local _base_0 = {
    drawShape = function(self)
      love.graphics.rectangle("line", self.x - self.offset.x, self.y - self.offset.y, self.w, self.h)
      love.graphics.setColor(255, 0, 255)
      love.graphics.setPointSize(4)
      love.graphics.points(self.x, self.y)
      return love.graphics.setColor(255, 255, 255)
    end,
    move = function(self, dx, dy)
      self.x = self.x + dx
      self.y = self.y + dy
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
      local _list_0 = AC.shapes
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local shape = _list_0[_index_0]
          if shape == self then
            _continue_0 = true
            break
          end
          local coll, mtv = AC:isColliding(shape, self)
          if coll then
            self:collided(shape, mtv, false)
          end
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
    collided = function(self, shape, mtv, rotated)
      return AC:collisionStandartTreatment(self, shape, mtv, rotated)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, w, h, behavior, offset, name)
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
      self.x = 0
      self.y = 0
      self.w = w
      self.h = h
      self.behavior = behavior
      self.name = name
      self.type = "aabb"
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
      return AC:addShape(self)
    end,
    __base = _base_0,
    __name = "aabb"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  aabb = _class_0
end
return aabb
