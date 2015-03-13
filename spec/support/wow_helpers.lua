local stub = require "luassert.stub"

function stubNumberOfArenaOpponents(number)
  return stub(WowApi, "GetNumberOfArenaOpponents", number)
end

function stubUnitName(name)
  return stub(WowApi, "GetUnitName", name)
end

function stubOpponentSpec(specId)
  return stub(WowApi, "GetArenaOpponentSpec", specId)
end

function CreateFrame(name)
  local frame = MockFrame()
  frame.name = name

  return frame
end
