require "src/util"

local say = require "say"
local assert = require "luassert.assert"

local function slash_command_registered(state, arguments)
  local expectedCommand = arguments[1]
  local commandFunc = arguments[2]

  if util.table_has_key(expectedCommand, SlashCmdList) then
    return SlashCmdList[expectedCommand] == commandFunc
  end

  return false
end

say:set(
  "assertion.slash_command_registered.positive",
  "Expected %s\n to have been registered in SlashCmdList"
)

say:set(
  "assertion.slash_command_registered.negative",
  "Expected %s\n not to have been registered in SlashCmdList"
)

assert:register(
  "assertion",
  "slash_command_registered",
  slash_command_registered,
  "assertion.slash_command_registered.positive",
  "assertion.slash_command_registered.negative"
)
