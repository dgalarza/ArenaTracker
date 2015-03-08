stub = require "luassert.stub"

export stubNumberOfArenaOpponents = (number) ->
  stub(_G, "GetNumArenaOpponentSpecs", number)

export stubUnitName = (name) ->
  stub(_G, "UnitName", name)

export strfind = (haystack, needle) ->
  string.find(haystack, needle)

export stubOpponentSpec = (specId) ->
  stub(_G, "GetArenaOpponentSpec", specId)

export CreateFrame = (name) ->
  frame = MockFrame!
  frame.name = name

  frame
