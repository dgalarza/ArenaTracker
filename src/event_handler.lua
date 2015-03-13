EventHandler = {}

EventHandler.ARENA_EVENTS = {
  ["ARENA_PREP_OPPONENT_SPECIALIZATIONS"] = "prepArenaOpponentSpecializations",
  ["UNIT_NAME_UPDATE"] = "arenaUnitNameUpdated",
  ["UPDATE_BATTLEFIELD_SCORE"] = "score_updated"
}

function EventHandler:init()
  EventHandler.frame = CreateFrame("Frame")
  EventHandler.frame.events = {}
  EventHandler:bindEventLoop()

  return EventHandler
end

function EventHandler:bindEventLoop()
  self.frame:RegisterEvent("PLAYER_LOGIN")
  self.frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
      EventHandler:initializeArenaTracker()
    else
      EventHandler:delegateEvent(event, ...)
    end
  end)
end

function EventHandler:initializeArenaTracker()
  ArenaTracker:Init()
  self.arenaTracker = ArenaTracker
  self:bindZoneEvents()
end

function EventHandler:bindZoneEvents()
  self:registerEvent("ZONE_CHANGED_NEW_AREA", "zoneChange")
  self:registerEvent("PLAYER_ENTERING_WORLD", "zoneChange")
end

function EventHandler:bindArenaEvents()
  for event, handler in pairs(self.ARENA_EVENTS) do
    self:registerEvent(event, handler)
  end
end

function EventHandler:registerEvent(event, handler)
  self.frame.events[event] = handler or event
  self.frame:RegisterEvent(event)
end

function EventHandler:delegateEvent(event, ...)
  handler = self.frame.events[event]
  if type(self[handler]) == "function" then
    self[handler](self, event, ...)
  end
end

function EventHandler:zoneChange()
  _, instanceType = IsInInstance()

  if instanceType == "arena" then
    self:bindArenaEvents()
    self.arenaMatch = self.arenaTracker:joined_arena()
  elseif self.previousInstanceType == "arena" then
    self.arenaTracker:left_arena()
    self.arenaMatch = nil
  end

  self.previousInstanceType = instanceType
end

function EventHandler:prepArenaOpponentSpecializations()
  self.arenaMatch:prepArenaOpponentSpecializations()
end

function EventHandler:arenaUnitNameUpdated(_, unit)
  self.arenaMatch:unitNameUpdated(unit)
end

function EventHandler:score_updated()
  self.arenaTracker:score_updated()
end
