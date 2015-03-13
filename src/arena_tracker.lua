ArenaTracker = {}

function ArenaTracker:Init()
  print("Welcome to ArenaTracker")

  ArenaTracker.currentMatch = nil

  return ArenaTracker
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
