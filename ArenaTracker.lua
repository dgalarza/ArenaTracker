local print = print

local GetBattlefieldArenaFaction = GetBattlefieldArenaFaction
local GetBattlefieldWinner = GetBattlefieldWinner
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local IsInInstance = IsInInstance
local UnitName = UnitName

local ArenaEvents = {
  "ARENA_PREP_OPPONENT_SPECIALIZATIONS",
  "UNIT_NAME_UPDATE",
  "UPDATE_BATTLEFIELD_SCORE",
}

ArenaMatches = {}

ArenaTracker = {}
ArenaTracker.eventHandler = CreateFrame("Frame")
ArenaTracker.eventHandler.events = {}

ArenaTracker.eventHandler:RegisterEvent("PLAYER_LOGIN")

function ArenaTracker:Print(...)
  print("ArenaTracker: ", ...)
end

function ArenaTracker:Debug(...)
  print("ArenaTracker Debug: ", ...)
end

ArenaTracker.eventHandler:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    ArenaTracker:Enable()
    ArenaTracker:RegisterEvents()
    ArenaTracker.eventHandler:UnregisterEvent("PLAYER_LOGIN")
  else
    local handler = self.events[event]
    if type(ArenaTracker[handler]) == "function" then
      ArenaTracker[handler](ArenaTracker, event, ...)
    end
  end
end)

function ArenaTracker:RegisterEvents()
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
end

function ArenaTracker:Enable()
  self:Print("Welcome to ArenaTracker");

  SlashCmdList["ARENATRACKER"] = function(...)
    ArenaTracker:DisplayMatches()
  end
  SLASH_ARENATRACKER1 = "/arenaTracker"
end

function ArenaTracker:RegisterEvent(event, handler)
  self.eventHandler.events[event] = handler or event
  self.eventHandler:RegisterEvent(event)
end

function ArenaTracker:UnregisterEvent(event)
  self.eventHandler.events[event] = nil
  self.eventHandler:UnregisterEvent(event)
end

function ArenaTracker:ZONE_CHANGED_NEW_AREA()
  local _, instanceType = IsInInstance()

  if instanceType == "arena" then
    self:JoinedArena()
  elseif self.previousInstanceType == "arena" then
    self:LeftArena()
  end

  self.previousInstanceType = instanceType
end

function ArenaTracker:JoinedArena()
  self:RegisterArenaEvents()

  if self.currentMatch == nil then
    self.currentMatch = {}
    self.currentMatch["players"] = {}
  end

  local numberOfOpponents = GetNumArenaOpponentSpecs()
  if (numberOfOpponents and numberOfOpponents > 0) then
    self:ARENA_PREP_OPPONENT_SPECIALIZATIONS()
  end
end

function ArenaTracker:LeftArena()
  self:UnregisterArenaEvents()
  self.currentMatch = nil
end

function ArenaTracker:RegisterArenaEvents()
  for _, event in pairs(ArenaEvents) do
    self:RegisterEvent(event)
  end
end

function ArenaTracker:UnregisterArenaEvents()
  for _, event in pairs(ArenaEvents) do
    self.eventHandler:UnregisterEvent(event)
  end
end

function ArenaTracker:ARENA_PREP_OPPONENT_SPECIALIZATIONS(event)
  local numberOfOpponents = GetNumArenaOpponentSpecs()
  local match = {}

  for i = 1, numberOfOpponents do
    local unit = "arena"..i
    local specID = GetArenaOpponentSpec(i)
    if specID > 0 then
      self:UpdateUnit(unit, "spec", specID)
    end
  end
end

function ArenaTracker:UPDATE_BATTLEFIELD_SCORE(event)
  local winner = GetBattlefieldWinner()

  if winner and not self.currentMatch["saved"] then
    self:TrackMatch()
  end
end

function ArenaTracker:UNIT_NAME_UPDATE(event, unit)
  if self:IsValidUnit(unit) then
    local name = UnitName(unit)

    if name then
      self:UpdateUnit(unit, "name", name)
    end
  end
end

function ArenaTracker:DisplayMatches()
  for _, match in pairs(ArenaMatches) do
    self:DisplayMatch(match)
  end
end

function ArenaTracker:DisplayMatch(match)
  for _, unit in pairs(match["players"]) do
    self:Debug(unit["name"])
    self:Debug(unit["spec"])
  end

  self:Debug("Won?", match["won"])
end

function ArenaTracker:IsValidUnit(unit)
  return strfind(unit, "arena") and not strfind(unit, "pet")
end

function ArenaTracker:TrackMatch()
  local winner = GetBattlefieldWinner()
  local MyFaction = GetBattlefieldArenaFaction()

  self.currentMatch["won"] = MyFaction == winner
  self.currentMatch["saved"] = true

  table.insert(ArenaMatches, self.currentMatch)
end

function ArenaTracker:BuildUnit(unit)
  if self.currentMatch["players"][unit] == nil then
    self.currentMatch["players"][unit] = {}
  end
end

function ArenaTracker:UpdateUnit(unit, attribute, value)
  self:BuildUnit(unit)
  self.currentMatch["players"][unit][attribute] = value
end
