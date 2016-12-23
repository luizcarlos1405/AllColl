local rectangle
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, width, heigth)
      if x == nil then
        x = 200
      end
      if y == nil then
        y = 200
      end
      if width == nil then
        width = 42
      end
      if heigth == nil then
        heigth = 42
      end
      self.shape = {
        type = "rectangle",
        x = x,
        y = y,
        w = x + width,
        h = y + heigth,
        draw = function(self)
          return love.graphics.rectangle("line", self.shape.x, self.shape.y, self.shape.w, self.shape.h)
        end
      }
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
