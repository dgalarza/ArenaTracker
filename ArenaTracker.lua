local print = print

local IsInInstance = IsInInstance

local ArenaEvents = {
  "ARENA_PREP_OPPONENT_SPECIALIZATIONS"
}

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
  self:Debug("Registering events")
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
end

function ArenaTracker:Enable()
  self:Print("Welcome to ArenaTracker")

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
end

end
