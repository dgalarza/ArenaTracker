stub = require "luassert.stub"

export stubNumberOfArenaOpponents = (number) ->
  stub(_G, "GetNumArenaOpponentSpecs", 0)

export stubUnitName = (name) ->
  stub(_G, "UnitName", "Doctype")

export strfind = (haystack, needle) ->
  string.find(haystack, needle)
