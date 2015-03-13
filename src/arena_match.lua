local ArenaMatchPrototype = {}

function ArenaMatchPrototype:prepare()
  local numberOfOpponents = GetNumArenaOpponentSpecs()

  if numberOfOpponents and numberOfOpponents > 0 then
    self:prepArenaOpponentSpecializations()
  end
end

function ArenaMatchPrototype:determineResults()
  local myFaction = GetBattlefieldArenaFaction()
  self.won = self:getWinner() == myFaction
end

function ArenaMatchPrototype:toTable()
  local results = {
    ["won"] = self.won,
    ["players"] = {}
  }

  for _, unit in pairs(self.players) do
    table.insert(results["players"], unit)
  end

  return results
end

function ArenaMatchPrototype:getWinner()
  return GetBattlefieldWinner()
end

function ArenaMatchPrototype:unitNameUpdated(unit)
  if isValidUnit(unit) then
    local name = UnitName(unit)

    if name then
      self:updateUnit(unit, "name", name)
    end
  end
end

function ArenaMatchPrototype:prepArenaOpponentSpecializations()
  local numberOfOpponents = GetNumArenaOpponentSpecs()
  local match = {}

  for i = 1, numberOfOpponents do
    local unit = "arena"..i
    local specId = GetArenaOpponentSpec(i)

    if specId > 0 then
      self:updateUnit(unit, "spec", specId)
    end
  end
end

function ArenaMatchPrototype:updateUnit(unit, attribute, value)
  self:buildUnit(unit)
  self.players[unit][attribute] = value
end

function ArenaMatchPrototype:buildUnit(unit)
  if self.players[unit] == nil then
    self.players[unit] = ArenaPlayer()
  end
end

function isValidUnit(unit)
  return strfind(unit, "arena") and not strfind(unit, "pet")
end

ArenaMatchPrototype.__index = ArenaMatchPrototype

ArenaMatch = setmetatable({
  __init = function(self)
    self.saved = false
    self.won = false
    self.players = {}
  end,

  __base = ArenaMatchPrototype,
  __name = "ArenaMatch"

}, {
  __index = ArenaMatchPrototype,
  __call = function(cls, ...)
    local obj = setmetatable({}, ArenaMatchPrototype)
    cls.__init(obj, ...)
    return obj
  end
})
