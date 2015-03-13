local ArenaMatchPrototype = {}

function ArenaMatchPrototype:prepare()
  local numberOfOpponents = WowApi.GetNumberOfArenaOpponents()

  if numberOfOpponents and numberOfOpponents > 0 then
    self:prepArenaOpponentSpecializations()
  end
end

function ArenaMatchPrototype:determineResults()
  local myFaction = WowApi.GetPlayerArenaFaction()
  self.ranked = WowApi.IsRankedArenaMatch()
  self.won = self:getWinner() == myFaction
end

function ArenaMatchPrototype:getWinner()
  return WowApi.GetBattlefieldWinner()
end

function ArenaMatchPrototype:opponentNameUpdated(unit)
  local name = WowApi.GetUnitName(unit)

  if name and name ~= "Unknown" then
    self:updateUnit(unit, "name", name, "opponents")
  end
end

function ArenaMatchPrototype:partyNameUpdated(unit)
  local name = WowApi.GetUnitName(unit)

  if name and name ~= "Unknown" then
    self:updateUnit(unit, "name", name, "party")
  end
end

function ArenaMatchPrototype:prepArenaOpponentSpecializations()
  local numberOfOpponents = WowApi.GetNumberOfArenaOpponents()
  local match = {}

  for i = 1, numberOfOpponents do
    local unit = "arena"..i
    local specId = WowApi.GetArenaOpponentSpec(i)

    if specId > 0 then
      self:updateUnit(unit, "spec", specId, "opponents")
    end
  end
end

function ArenaMatchPrototype:updateUnit(unit, attribute, value, collection)
  local unitsTable = self[collection]

  self:buildUnit(unit, collection)
  unitsTable[unit][attribute] = value
end

function ArenaMatchPrototype:buildUnit(unit, collection)
  local unitsTable = self[collection]

  if unitsTable[unit] == nil then
    unitsTable[unit] = ArenaPlayer()
  end
end

ArenaMatchPrototype.__index = ArenaMatchPrototype

ArenaMatch = setmetatable({
  __init = function(self)
    self.saved = false
    self.won = false
    self.opponents = {}
    self.party = {}
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
