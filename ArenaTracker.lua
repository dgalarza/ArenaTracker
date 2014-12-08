local print = print

local IsActiveBattleFieldArena = IsActiveBattleFieldArena

ArenaTracker = {}
ArenaTracker.eventHandler = CreateFrame("Frame")
ArenaTracker.eventHandler.events = {}

ArenaTracker.eventHandler:RegisterEvent("PLAYER_LOGIN")

function ArenaTracker:Print(...)
  print(...)
end

ArenaTracker.eventHandler:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    ArenaTracker:Enable()
    ArenaTracker.eventHandler:UnregisterEvent("PLAYER_LOGIN")
  end
end)

function ArenaTracker:Enable()
  self:Print("Welcome to ArenaTracker")
end

function ArenaTracker:RegisterEvent(event, handler)
  self.eventHandler.events[event] = handler or event
  self.eventHandler:RegisterEvent(event)
end
