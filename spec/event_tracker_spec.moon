require "spec/spec_helper"
require "src/event_handler"

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
