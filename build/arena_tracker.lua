ArenaMatches = { }
do
  local _base_0 = {
    joined_arena = function(self)
      if not self.currentMatch then
        self.currentMatch = ArenaMatch()
      end
      self.currentMatch.prepare()
      return self.currentMatch
    end,
    left_arena = function(self)
      self.currentMatch = nil
    end,
    score_updated = function(self)
      local winner = self.currentMatch:getWinner()
      if winner and not self.currentMatch.saved then
        return self:track_match()
      end
    end,
    track_match = function(self)
      self.currentMatch.saved = true
      self.currentMatch:determineResults()
      return table.insert(ArenaMatches, self.currentMatch:toTable())
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
