stub = require "luassert.stub"

export stubNumberOfArenaOpponents = (number) ->
  stub(WowApi, "GetNumberOfArenaOpponents", number)

export stubUnitName = (name) ->
  stub(WowApi, "GetUnitName", name)

export strfind = (haystack, needle) ->
  string.find(haystack, needle)

export stubOpponentSpec = (specId) ->
  stub(WowApi, "GetArenaOpponentSpec", specId)

export CreateFrame = (name) ->
  frame = MockFrame!
  frame.name = name

  frame
