local ArenaPlayerPrototype = {}

ArenaPlayer = setmetatable({
  __init = function(self)
    self.spec = nil
    self.name = nil
  end,

  __base = ArenaPlayerPrototype,
  __name = "ArenaMatch"
}, {
  __index = ArenaPlayerPrototype,
  __call = function(cls, ...)
    local obj = setmetatable({}, ArenaPlayerPrototype)
    cls.__init(obj, ...)
    return obj
  end
})
