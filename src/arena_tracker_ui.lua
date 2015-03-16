ArenaTrackerUi = {}

local function buildRecordString(wins, loses)
  return string.format("%u - %u", wins, loses)
end

function ArenaTrackerUi:Show()
  ArenaTrackerUi_RankedRecord:SetText(self:rankedRecord())
  ArenaTrackerUi_SkirmishRecord:SetText(self:skirmishRecord())
  self:buildRows()
end

function ArenaTrackerUi:rankedRecord()
  local rankedMatches = ArenaTracker:rankedMatches()
  local wins = ArenaTracker:countWins(rankedMatches)
  local loses = ArenaTracker:countLosses(rankedMatches)

  return buildRecordString(wins, loses)
end

function ArenaTrackerUi:skirmishRecord()
  local skirmishMatches = ArenaTracker:skirmishMatches()
  local wins = ArenaTracker:countWins(skirmishMatches)
  local loses = ArenaTracker:countLosses(skirmishMatches)

  return buildRecordString(wins, loses)
end

function ArenaTrackerUi:buildRows()
  local reversedMatches = util.reverse(ArenaTracker:rankedMatches())

  for index, match in pairs(reversedMatches) do
    ArenaTrackerUi.drawRow(index, match)
  end
end

function ArenaTrackerUi.drawRow(index, match)

end
