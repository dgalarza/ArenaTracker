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

function ArenaMatchPrototype:unitNameUpdated(unit)
  if isValidUnit(unit) then
    local name = WowApi.GetUnitName(unit)

    if name and name ~= "Unknown" then
      self:updateUnit(unit, "name", name)
    end
  end
end

function ArenaMatchPrototype:prepArenaOpponentSpecializations()
  local numberOfOpponents = WowApi.GetNumberOfArenaOpponents()
  local match = {}

  for i = 1, numberOfOpponents do
    local unit = "arena"..i
    local specId = WowApi.GetArenaOpponentSpec(i)

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
  return string.find(unit, "arena") and not string.find(unit, "pet")
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
