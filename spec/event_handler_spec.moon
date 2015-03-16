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
        arenaMatchSpy = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")

        eventHandler.frame\triggerEvent("ARENA_OPPONENT_UPDATE", "arena1", "seen")

        assert.spy(arenaMatchSpy).was.called!

    describe "type is destroyed", ->
      it "updates the unit's name", ->
        eventHandler = joinArena!
        arenaMatchSpy = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")

        eventHandler.frame\triggerEvent("ARENA_OPPONENT_UPDATE", "arena1", "destroyed")

        assert.spy(arenaMatchSpy).was.called!

      describe "pet unit", ->
        it "does not update the unit's name", ->
          eventHandler = joinArena!
          arenaMatchSpy = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")

          eventHandler.frame\triggerEvent("ARENA_OPPONENT_UPDATE", "arenapet1", "destroyed")

          assert.spy(arenaMatchSpy).was_not.called!

  describe "UNIT_NAME_UPDATE", ->
    describe "arena unit is updated", ->
      it "alerts the arena tracker that an opponent unit name has been updated", ->
        eventHandler = joinArena!
        stubbed = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")
        unit = "arena1"
        eventHandler.frame\triggerEvent("UNIT_NAME_UPDATE", unit)

        assert.spy(stubbed).was.called!

    describe "arena pet is updated", ->
      it "does not alert that a unit name was updated", ->
        eventHandler = joinArena!
        stubbed = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")
        unit = "arenapet1"
        eventHandler.frame\triggerEvent("UNIT_NAME_UPDATE", unit)

        assert.spy(stubbed).was_not_called!

    describe "a party unit was updated", ->
      it "does not alert that an opponent name was updated", ->
        eventHandler = joinArena!
        stubbed = spy.on(eventHandler.arenaMatch, "opponentNameUpdated")
        unit = "party1"
        eventHandler.frame\triggerEvent("UNIT_NAME_UPDATE", unit)

        assert.spy(stubbed).was_not_called!

      it "alerts that a party member was updated", ->
        eventHandler = joinArena!
        stubbed = spy.on(eventHandler.arenaMatch, "partyNameUpdated")
        unit = "party1"
        eventHandler.frame\triggerEvent("UNIT_NAME_UPDATE", unit)

        assert.spy(stubbed).was_called!

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
