export ArenaMatches = {}

export class ArenaTracker
  new: =>
    print "Welcome to ArenaTracker"

  joined_arena: =>
    if not @currentMatch
      @currentMatch = ArenaMatch!

    @currentMatch.prepare!
    @currentMatch

  left_arena: =>
    @currentMatch = nil

  score_updated: =>
    winner = @currentMatch\getWinner!
    if winner and not @currentMatch.saved
      @track_match!

  track_match: =>
    @currentMatch.saved = true
    @currentMatch\determineResults!

    table.insert ArenaMatches, @currentMatch\toTable!
