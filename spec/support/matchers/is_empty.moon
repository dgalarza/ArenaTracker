say = require "say"
assert = require "luassert.assert"

is_empty = (state, arguments) ->
  _table = arguments[1]
  next(_table) == nil

say\set("assertion.is_empty.positive", "Expected %s \nto be empty")
say\set("assertion.is_empty.negative", "Expected %s \nnot to be empty")

assert\register("assertion", "is_empty", is_empty, "assertion.is_empty.positive", "assertion.is_empty.negative")
