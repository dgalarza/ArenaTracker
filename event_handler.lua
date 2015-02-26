do
  local ARENA_EVENTS
  local _base_0 = {
    bindEventLoop = function(self)
      local eventHandler = self
      self.handler:RegisterEvent("PLAYER_LOGIN")
      return self.handler:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" then
          return eventHandler:initializeArenaTracker()
        else
          return eventHandler:delegateEvent(event, ...)
        end
      end)
    end,
    initializeArenaTracker = function(self)
      self.arenaTracker = ArenaTracker()
      return self:bindZoneEvents()
    end,
    bindZoneEvents = function(self)
      self:registerEvent("ZONE_CHANGED_NEW_AREA", "zoneChange")
      return self:registerEvent("PLAYER_ENTERING_WORLD", "zoneChange")
    end,
    bindArenaEvents = function(self)
      for event, handler in pairs(ARENA_EVENTS) do
        self:registerEvent(event, handler)
      end
    end,
    unbindArenaEvents = function(self)
      for event in pairs(ARENA_EVENTS) do
        self.handler:UnregisterEvent(event)
      end
    end,
    registerEvent = function(self, event, handler)
      self.handler.events[event] = handler or event
      return self.handler:RegisterEvent(event)
    end,
    delegateEvent = function(self, event, ...)
      local handler = self.handler.events[event]
      if type(self[handler]) == "function" then
        return self[handler](self, event, ...)
      end
    end,
    zoneChange = function(self)
      local _, instanceType = IsInInstance()
      if instanceType == "arena" then
        self:bindArenaEvents()
        self.arenaMatch = self.arenaTracker:joinedArena()
      elseif self.previousInstanceType == "arena" then
        self.arenaTracker:leftArena()
        self.arenaMatch = nil
      end
      self.previousInstanceType = instanceType
    end,
    prepArenaOpponentSpecializations = function(self)
      return self.arenaMatch:prepArenaOpponentSpecializations()
    end,
    arenaUnitNameUpdated = function(self, _, unit)
      return self.arenaMatch.unitNameUpdated(unit)
    end,
    scoreUpdated = function(self)
      return self.arenaMatch.scoreUpdated()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.handler = CreateFrame("Frame")
      self.handler.events = { }
      return self:bindEventLoop()
    end,
    __base = _base_0,
    __name = "EventHandler"
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
  ARENA_EVENTS = {
    ["ARENA_PREP_OPPONENT_SPECIALIZATIONS"] = "prepArenaOpponentSpecializations",
    ["UNIT_NAME_UPDATE"] = "arenaUnitNameUpdated",
    "UPDATE_BATTLEFIELD_SCORE",
    "scoreUpdated"
  }
  EventHandler = _class_0
end
