require "spec/spec_helper"
require "src/arena_match"
require "src/arena_player"
require "src/event_handler"
require "src/arena_tracker"

describe "EventHandler", ->
  describe "#new", ->
    it "creates a frame for handling events", ->
      frameSpy = spy.on(WowApi, "CreateFrame")

      eventHandler = EventHandler.init!
      eventsTable = eventHandler.frame.events

      assert.spy(frameSpy).was.called!
      assert.equal(type(eventsTable), "table")

    it "registers an event for PLAYER_LOGIN", ->
      eventHandler = EventHandler.init!
      frame = eventHandler.frame

      assert.event_registered(frame, "PLAYER_LOGIN")

  context "PLAYER_LOGIN", ->
    it "initializes the ArenaTracker addon", ->
      eventHandler = EventHandler.init!
      frame = eventHandler.frame

      frame\triggerEvent("PLAYER_LOGIN")

      assert.not.equal(eventHandler.arenaTracker, nil)

    it "binds events to track zone changes", ->
      eventHandler = EventHandler.init!
      frame = eventHandler.frame
      frame\triggerEvent("PLAYER_LOGIN")

      assert.event_registered(frame, "ZONE_CHANGED_NEW_AREA", "zoneChange")
      assert.event_registered(frame, "PLAYER_ENTERING_WORLD", "zoneChange")

  describe "ZONE_CHANGE_NEW_AREA", ->
    context "entered arena", ->
      it "binds arena events", ->
        eventHandler = joinArena!
        frame = eventHandler.frame

        assert.event_registered(frame, "ARENA_PREP_OPPONENT_SPECIALIZATIONS", "prepArenaOpponentSpecializations")
        assert.event_registered(frame, "UNIT_NAME_UPDATE", "arenaUnitNameUpdated")
        assert.event_registered(frame, "UPDATE_BATTLEFIELD_SCORE", "score_updated")

      it "notifies the arenaTracker that the player has entered an arena", ->
        eventHandler = startEventHandler!
        arenaTrackerSpy = spy.on(eventHandler.arenaTracker, "joined_arena")

        joinArena(eventHandler)

        assert.spy(arenaTrackerSpy).was.called!

      it "caches the current instance type", ->
        eventHandler = joinArena!

        assert.True(eventHandler.inArena)

    context "leaving arena", ->
      it "notifies the arenaTracker that the player has left the arena", ->
        eventHandler = joinArena!
        arenaTrackerSpy = spy.on(eventHandler.arenaTracker, "left_arena")
        leaveArena(eventHandler)

        assert.spy(arenaTrackerSpy).was.called!

      it "resets the arenaMatch", ->
        eventHandler = joinArena!
        leaveArena(eventHandler)

        assert.equal(eventHandler.arenaMatch, nil)

  describe "ARENA_OPPONENT_UPDATE", ->
    describe "type is seen", ->
      it "updates the unit's name", ->
        eventHandler = joinArena!
        arenaMatchSpy = spy.on(eventHandler.arenaMatch, "unitNameUpdated")

        eventHandler.frame\triggerEvent("ARENA_OPPONENT_UPDATE", "arena1", "seen")

        assert.spy(arenaMatchSpy).was.called!

    describe "type is destroyed", ->
      it "updates the unit's name", ->
        eventHandler = joinArena!
        arenaMatchSpy = spy.on(eventHandler.arenaMatch, "unitNameUpdated")

        eventHandler.frame\triggerEvent("ARENA_OPPONENT_UPDATE", "arena1", "destroyed")

        assert.spy(arenaMatchSpy).was.called!

  describe "UNIT_NAME_UPDATE", ->
    it "alerts the arena tracker that a unit name has been updated", ->
      eventHandler = joinArena!
      stubbed = spy.on(eventHandler.arenaMatch, "unitNameUpdated")
      stubUnitName("Doctype")
      unit = "arena1"
      eventHandler.frame\triggerEvent("UNIT_NAME_UPDATE", unit)

      assert.spy(stubbed).was.called!

  export joinArena = (eventHandler) ->
    if not eventHandler
      eventHandler = startEventHandler!

    stubNumberOfArenaOpponents(0)
    stub(WowApi, "IsInArena", true)

    eventHandler.frame\triggerEvent("ZONE_CHANGED_NEW_AREA")
    eventHandler

  export startEventHandler = ->
    eventHandler = EventHandler.init!
    eventHandler.frame\triggerEvent("PLAYER_LOGIN")
    eventHandler

  export leaveArena = (eventHandler) ->
    stub(WowApi, "IsInArena", false)
    eventHandler.frame\triggerEvent("ZONE_CHANGED_NEW_AREA")
