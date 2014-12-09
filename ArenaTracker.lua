local print = print

local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local IsInInstance = IsInInstance
local UnitName = UnitName

local ArenaEvents = {
  "ARENA_PREP_OPPONENT_SPECIALIZATIONS"
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

function ArenaTracker:ZONE_CHANGED_NEW_AREA()
  local _, instanceType = IsInInstance()

  if instanceType == "arena" then
    self:JoinedArena()
  elseif self.previousInstanceType == "arena" then
    self:UnregisterArenaEvents()
  end

  self.previousInstanceType = instanceType
end

function ArenaTracker:JoinedArena()
  self:RegisterArenaEvents()

  local numberOfOpponents = GetNumArenaOpponentSpecs()
  if (numberOfOpponents and numberOfOpponents > 0) then
    self:ARENA_PREP_OPPONENT_SPECIALIZATIONS()
  end
end

function ArenaTracker:RegisterArenaEvents()
  for _, event in pairs(ArenaEvents) do
    self.eventHandler:RegisterEvent(event)
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
    local specId = GetArenaOpponentSpec(i)
    if specId > 0 then
      match[unit] = {}
      match[unit]["spec"] = specId
      match[unit]["name"] = UnitName(unit)
    end
  end

  table.insert(ArenaMatches, match)
end

function ArenaTracker:DisplayMatches()
  for _, match in pairs(ArenaMatches) do
    self:DisplayMatch(match)
  end
end

function ArenaTracker:DisplayMatch(match)
  for _, unit in pairs(match) do
    self:Debug(unit["name"])
    self:Debug(unit["spec"])
  end
end
