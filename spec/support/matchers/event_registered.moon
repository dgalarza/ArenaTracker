say = require "say"
assert = require "luassert.assert"

event_registered = (state, arguments) ->
  frame = arguments[1]
  needle = arguments[2]
  callbackName = arguments[3]

  registeredEvent = false

  for _, event in pairs(frame.registeredEvents) do
    if event == needle
      registeredEvent = true

  if callbackName
    registeredEvent and (frame.events[needle] == callbackName)
  else
    registeredEvent

say\set("assertion.event_registered.positive", "Expected %s \nto have registered event: %s")
say\set("assertion.event_registered.negative", "Expected %s \nnot to have registered event: %s")

assert\register("assertion", "event_registered", event_registered, "assertion.event_registered.positive", "assertion.event_registered.negative")
