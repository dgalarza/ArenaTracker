ArenaMatches = {}
ArenaTracker = {}

function ArenaTracker:Init()
  print("Welcome to ArenaTracker")

  ArenaTracker.currentMatch = nil

  ArenaTracker:registerSlashCommand()

  return ArenaTracker
end

function ArenaTracker:registerSlashCommand()
  SlashCmdList["ARENA_TRACKER"] = ArenaTracker.SlashCommands
  SLASH_ARENA_TRACKER1 = "/arenatracker"
end

function ArenaTracker:SlashCommands()
  if ArenaTrackerUiFrame:IsVisible() then
    HideUIPanel(ArenaTrackerUiFrame)
  else
    ShowUIPanel(ArenaTrackerUiFrame)
  end
end

function ArenaTracker:joined_arena()
  if not ArenaTracker.currentMatch then
    ArenaTracker.currentMatch = ArenaMatch()
  end

  ArenaTracker.currentMatch:prepare()

  return ArenaTracker.currentMatch
end

function ArenaTracker:left_arena()
  ArenaTracker.currentMatch = nil
end

function ArenaTracker:score_updated()
  local winner = self.currentMatch:getWinner()

  if winner and not self.currentMatch.saved then
    self.track_match()
  end
end

function ArenaTracker:track_match()
  ArenaTracker.currentMatch.saved = true
  ArenaTracker.currentMatch:determineResults()

  table.insert(ArenaMatches, ArenaTracker.currentMatch)
end

function ArenaTracker:rankedMatches()
  return util.select(ArenaMatches, function(match)
    return match.ranked
  end)
end

function ArenaTracker:skirmishMatches()
  return util.select(ArenaMatches, function(match)
    return not match.ranked
  end)
end

function ArenaTracker:countWins(matches)
  return util.reduce(matches, 0, function(sum, match)
    if match.won then
      return sum + 1
    else
      return sum
    end
  end)
end

function ArenaTracker:countLosses(matches)
  return util.reduce(matches, 0, function(sum, match)
    if not match.won then
      return sum + 1
    else
      return sum
    end
  end)
end
