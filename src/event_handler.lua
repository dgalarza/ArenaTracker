EventHandler = {}

EventHandler.ARENA_EVENTS = {
  ["ARENA_PREP_OPPONENT_SPECIALIZATIONS"] = "prepArenaOpponentSpecializations",
  ["UNIT_NAME_UPDATE"] = "arenaUnitNameUpdated",
  ["ARENA_OPPONENT_UPDATE"] = "arenaOpponentUpdate",
  ["UPDATE_BATTLEFIELD_SCORE"] = "score_updated"
}

function EventHandler:init()
  EventHandler.frame = WowApi.CreateFrame("Frame")
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
  local handler = self.frame.events[event]
  if type(self[handler]) == "function" then
    self[handler](self, event, ...)
  end
end

function EventHandler:zoneChange()
  if WowApi.IsInArena() then
    self:bindArenaEvents()
    self.arenaMatch = self.arenaTracker:joined_arena()
    self.inArena = true
  elseif self.inArena then
    self.arenaTracker:left_arena()
    self.arenaMatch = nil
  end
end

function EventHandler:prepArenaOpponentSpecializations()
  self.arenaMatch:prepArenaOpponentSpecializations()
end

function EventHandler:arenaUnitNameUpdated(_, unit)
  if isArenaUnit(unit) then
    self.arenaMatch:opponentNameUpdated(unit)
  elseif isPartyUnit(unit) then
    self.arenaMatch:partyNameUpdated(unit)
  end
end

function EventHandler:score_updated()
  self.arenaTracker:score_updated()
end

function EventHandler:arenaOpponentUpdate(_, unit, type)
  if type == "seen" or type == "destroyed" then
    if isArenaUnit(unit) then
      self.arenaMatch:opponentNameUpdated(unit)
    end
  end
end

function isArenaUnit(unit)
  return string.find(unit, "arena") and not string.find(unit, "pet")
end

function isPartyUnit(unit)
  return string.find(unit, "party") and not string.find(unit, "pet")
end
