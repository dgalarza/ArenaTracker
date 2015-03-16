require "busted"

SlashCmdList = {}

function IsArenaSkirmish()
  return true
end

function UnitName(name)
  return "Doctype"
end

function CreateFrame(name)
  local frame = MockFrame()
  frame.name = name

  return frame
end
