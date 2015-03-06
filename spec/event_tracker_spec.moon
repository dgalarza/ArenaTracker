require "spec/spec_helper"
require "src/event_handler"
require "src/arena_tracker"

describe "EventHandler", ->
  describe "#new", ->
    it "creates a frame for handling events", ->
      frameSpy = spy.on(_G, "CreateFrame")

      eventHandler = EventHandler!
      eventsTable = eventHandler.frame.events

      assert.spy(frameSpy).was.called!
      assert.equal(type(eventsTable), "table")

    it "registers an event for PLAYER_LOGIN", ->
      eventHandler = EventHandler!
      frame = eventHandler.frame

      assert.event_registered(frame, "PLAYER_LOGIN")

  context "PLAYER_LOGIN", ->
    it "initializes the ArenaTracker addon", ->
      eventHandler = EventHandler!
      frame = eventHandler.frame

      frame\triggerEvent("PLAYER_LOGIN")

      assert.not.equal(eventHandler.arenaTracker, nil)

    it "binds events to track zone changes", ->
      eventHandler = EventHandler!
      frame = eventHandler.frame
      frame\triggerEvent("PLAYER_LOGIN")

      assert.event_registered(frame, "ZONE_CHANGED_NEW_AREA", "zoneChange")
      assert.event_registered(frame, "PLAYER_ENTERING_WORLD", "zoneChange")

  describe "ZONE_CHANGE_NEW_AREA", ->
    context "entered arena", ->
      it "binds arena events", ->

      it "notifies the arenaTracker that the player has entered an arena", ->

    context "leaving arena", ->
      it "notifies the arenaTracker that the player has left the arena", ->

      it "resets the arenaMatch", ->
