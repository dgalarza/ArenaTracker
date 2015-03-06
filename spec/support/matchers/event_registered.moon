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

say\set("assertion.is_empty.positive", "Expected %s \nto have registered event")
say\set("assertion.is_empty.negative", "Expected %s \nnot to have registered event")

assert\register("assertion", "event_registered", event_registered, "assertion.event_registered.positive", "assertion.event_registered.negative")
