do
  local isValidUnit
  local _base_0 = {
    prepare = function(self)
      local numberOfOpponents = GetNumArenaOpponentSpecs()
      if numberOfOpponents and numberOfOpponents > 0 then
        return self:prepArenaOpponentSpecializations()
      end
    end,
    determineResults = function(self)
      local myFaction = GetBattlefieldArenaFaction()
      self.won = self:getWinner() == myFaction
    end,
    toTable = function(self)
      local results = {
        won = self.won,
        players = { }
      }
      for _, unit in pairs(self.players) do
        table.insert(results["players"], unit)
      end
      return results
    end,
    getWinner = function()
      return GetBattlefieldWinner()
    end,
    unitNameUpdated = function(self, unit)
      if isValidUnit(unit) then
        local name = UnitName(unit)
        if name then
          return self:updateUnit(unit, "name", name)
        end
      end
    end,
    prepArenaOpponentSpecializations = function(self)
      local numberOfOpponents = GetNumArenaOpponentSpecs()
      local match = { }
      for i = 1, numberOfOpponents do
        local unit = "arena" .. i
        local specID = GetArenaOpponentSpec(i)
        if specID > 0 then
          self:updateUnit(unit, "spec", specID)
        end
      end
    end,
    updateUnit = function(self, unit, attribute, value)
      self:buildUnit(unit)
      self.players[unit][attribute] = value
    end,
    buildUnit = function(self, unit)
      if self.players[unit] == nil then
        self.players[unit] = ArenaPlayer()
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.saved = false
      self.won = false
      self.players = { }
    end,
    __base = _base_0,
    __name = "ArenaMatch"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  isValidUnit = function(unit)
    return strfind(unit, "arena") and not strfind(unit, "pet")
  end
  ArenaMatch = _class_0
end
