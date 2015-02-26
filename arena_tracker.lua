do
  local _base_0 = {
    joinedArena = function(self)
      if self.currentMatch == nil then
        self.currentMatch = ArenaMatch()
      end
      self.currentMatch.prepare()
      return self.currentMatch
    end,
    leftArena = function(self)
      print("left arena")
      self.currentMatch = nil
    end,
    scoreUpdated = function(self)
      local winner = self.currentMatch:getWinner()
      if winner and not self.currentMatch.saved then
        return self:trackMatch()
      end
    end,
    trackMatch = function(self)
      self.currentMatch.saved = true
      self.currentMatch:determineResult()
      return table.insert(matches, self.currentMatch:toTable())
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      return print("Welcome to ArenaTracker")
    end,
    __base = _base_0,
    __name = "ArenaTracker"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ArenaTracker = _class_0
end
return EventHandler()
