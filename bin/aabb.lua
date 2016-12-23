local aabb
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      if love.keyboard.isDown("w") then
        self.y = self.y - (200 * dt)
      end
      if love.keyboard.isDown("a") then
        self.x = self.x - (200 * dt)
      end
      if love.keyboard.isDown("s") then
        self.y = self.y + (200 * dt)
      end
      if love.keyboard.isDown("d") then
        self.x = self.x + (200 * dt)
      end
    end,
    draw = function(self)
      return love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      self.x = x
      self.y = y
      self.w = w
      self.h = h
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
