export class ArenaTracker
  new: =>
    @matches = {}
    print "Welcome to ArenaTracker"

  joined_arena: =>
    if not @currentMatch
      @currentMatch = ArenaMatch!

    @currentMatch.prepare!
    @currentMatch

  left_arena: =>
    print "left arena"
    @currentMatch = nil

  score_updated: =>
    winner = @currentMatch\get_winner!
    if winner and not @currentMatch.saved
      @track_match!

  track_match: =>
    @currentMatch.saved = true
    @currentMatch\determine_result!

    table.insert @matches, @currentMatch\toTable!

--EventHandler!
