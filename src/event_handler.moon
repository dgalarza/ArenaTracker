export class EventHandler
  ARENA_EVENTS = {
    "ARENA_PREP_OPPONENT_SPECIALIZATIONS": "prepArenaOpponentSpecializations",
    "UNIT_NAME_UPDATE": "arenaUnitNameUpdated",
    "UPDATE_BATTLEFIELD_SCORE", "score_udpated"
  }

  new: =>
    @frame = CreateFrame("Frame")
    @frame.events = {}
    @bindEventLoop!

  bindEventLoop: =>
    eventHandler = @
    @frame\RegisterEvent("PLAYER_LOGIN")
    @frame\SetScript "OnEvent", (event, ...) =>
      if event == "PLAYER_LOGIN"
        eventHandler\initializeArenaTracker!
      else
        eventHandler\delegateEvent(event, ...)

  initializeArenaTracker: =>
    @arenaTracker = ArenaTracker!
    @bindZoneEvents!

  bindZoneEvents: =>
    @registerEvent("ZONE_CHANGED_NEW_AREA", "zoneChange")
    @registerEvent("PLAYER_ENTERING_WORLD", "zoneChange")

  bindArenaEvents: =>
    for event, handler in pairs(ARENA_EVENTS) do
      @registerEvent(event, handler)

  unbindArenaEvents: =>
    for event in pairs(ARENA_EVENTS) do
      @frame\UnregisterEvent(event)

  registerEvent: (event, handler) =>
    @frame.events[event] = handler or event
    @frame\RegisterEvent(event)

  delegateEvent: (event, ...) =>
    handler = @frame.events[event]
    if type(@[handler]) == "function"
      @[handler](@, event, ...)

  zoneChange: =>
    _, instanceType = IsInInstance()

    if instanceType == "arena"
      @bindArenaEvents!
      @arenaMatch = @arenaTracker\joined_arena!
    elseif @previousInstanceType == "arena"
      @arenaTracker\left_arena!
      @arenaMatch = nil

    @previousInstanceType = instanceType

  prepArenaOpponentSpecializations: =>
    @arenaMatch\prepArenaOpponentSpecializations!

  arenaUnitNameUpdated: (_, unit) =>
    @arenaMatch.unitNameUpdated(unit)

  score_updated: =>
    @arenaMatch.score_updated!
