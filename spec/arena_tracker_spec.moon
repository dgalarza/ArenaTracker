require "spec/spec_helper"
require "src/event_handler"
require "src/arena_tracker"
require "src/arena_match"

describe "ArenaTracker", ->
  after_each ->
    _G["ArenaMatches"] = {}

  it "prints a welcome message", ->
    print_spy = spy.on(_G, "print")

    ArenaTracker.Init()

    assert.spy(print_spy).was_called_with("Welcome to ArenaTracker")

  describe "#joined_arena", ->
    it "creates an arena match", ->
      stub(_G, "GetNumArenaOpponentSpecs")

      ArenaTracker\joined_arena!

      assert.not.equals(ArenaTracker.currentMatch, nil)

    it "does not overwrite the match if called multiple times", ->
      stub(_G, "GetNumArenaOpponentSpecs")

      currentMatch = ArenaTracker\joined_arena!

      assert.equal(currentMatch, ArenaTracker\joined_arena!)

    it "prepares the currentMatch", ->
      mockArenaMatch = {
        prepare: -> true
      }
      mockArenaMatch = mock(mockArenaMatch)

      ArenaTracker.currentMatch = mockArenaMatch
      ArenaTracker.joined_arena!

      assert.spy(mockArenaMatch.prepare).was_called!

    describe "#left_arena", ->
      it "resets the currentMatch", ->
        mockArenaMatch = {}
        ArenaTracker.currentMatch = mockArenaMatch

        ArenaTracker\left_arena()

        assert.equal(nil, ArenaTracker.currentMatch)

    describe "#score_updated", ->
      context "winner determined and match not saved", ->
        it "saves the match", ->
          mockArenaMatch = {
            getWinner: -> "winner",
            saved: false,
            determineResults: -> true
          }
          ArenaTracker.Init()

          with ArenaTracker
            .currentMatch = mockArenaMatch
            \score_updated!

          assert.True(ArenaTracker.currentMatch.saved)

        it "determines the result of the current match", ->
          mockArenaMatch = mock({
            getWinner: -> "winner",
            determineResults: -> true,
            saved: false
          })
          tracker = ArenaTracker.Init()

          with ArenaTracker
            .currentMatch = mockArenaMatch
            \score_updated!

          assert.spy(mockArenaMatch.determineResults).was_called!

        it "stores the current match in the matches table" ,->
          mockArenaMatch = {
            getWinner: -> "winner",
            determineResults: -> true,
            saved: false
          }
          tracker = ArenaTracker.Init()

          with ArenaTracker
            .currentMatch = mockArenaMatch
            \score_updated!

          assert.equal(mockArenaMatch, ArenaMatches[1])

      context "current match already saved", ->
        it "does not add the current match into the matches table again", ->
          mockArenaMatch = buildMockArenaMatch({
            getWinner: -> "winner",
            saved: true
          })
          tracker = ArenaTracker.Init()

          with ArenaTracker
            .currentMatch = mockArenaMatch
            \score_updated!

          assert.spy(mockArenaMatch.determineResults).was_not_called!
          assert.equal(nil, ArenaMatches[1])

      context "winner is not available yet", ->
        it "does not add the current match to the matches table again", ->
          mockArenaMatch = buildMockArenaMatch({
            getWinner: -> nil,
            saved: false
          })
          tracker = ArenaTracker.Init()

          with ArenaTracker
            .currentMatch = mockArenaMatch
            \score_updated!

          assert.spy(mockArenaMatch.determineResults).was_not_called!
          assert.equal(nil, ArenaMatches[1])

  export buildMockArenaMatch = (attributes = {}) ->
    defaults = {
      getWinner: -> nil
      determineResults: -> true
      saved: false,
    }

    for key, value in pairs(attributes)
      defaults[key] = value

    mock(defaults)
