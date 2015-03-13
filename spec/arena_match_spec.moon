require "spec/spec_helper"
require "src/arena_match"
require "src/arena_player"

describe "ArenaMatch", ->
  describe "#getWinner", ->
    it "returns the result of GetBattlefieldWinner", ->
      battlefieldWinnerStub = stub(_G, "GetBattlefieldWinner", "Horde")
      match = ArenaMatch!

      winner = match\getWinner!

      assert.spy(battlefieldWinnerStub).was_called!
      assert.equal(winner, "Horde")

  describe "#determineResults", ->
    context "my faction is the same as the winning faction", ->
      it "marks the match as won", ->
        stub(_G, "GetBattlefieldArenaFaction", "Alliance")
        stub(_G, "GetBattlefieldWinner", "Alliance")
        match = ArenaMatch!

        match\determineResults!

        assert.True(match.won)

      it "flags whether or not the match is ranked", ->
        stub(WowApi, "IsRankedArenaMatch", true)
        rankedMatch = ArenaMatch!
        rankedMatch\determineResults!
        assert.True(rankedMatch.ranked)

        stub(WowApi, "IsRankedArenaMatch", false)
        skirmishMatch = ArenaMatch!
        skirmishMatch\determineResults!
        assert.False(skirmishMatch.ranked)

    context "my faction is different from the winning faction", ->
      it "marks the match as lost", ->
        stub(_G, "GetBattlefieldArenaFaction", "Alliance")
        stub(_G, "GetBattlefieldWinner", "Horde")
        match = ArenaMatch!

        match\determineResults!

        assert.False(match.won)

  describe "#opponentNameUpdated", ->
    context "Unit is valid arena unit" ,->
      it "stores the unit's name", ->
        unitNameSpy = stubUnitName("Doctype")
        match = ArenaMatch!

        match\opponentNameUpdated("arena1")

        assert.spy(unitNameSpy).was.called_with("arena1")
        assert.equal("Doctype", match.opponents["arena1"].name)

  describe "#prepare", ->
    context "number of opponents is nil", ->
      it "does not create track any players", ->
        stubNumberOfArenaOpponents(nil)
        match = ArenaMatch!

        match\prepare!

        assert.is_empty(match.opponents)

    context "number of opponents is 0", ->
      it "does not create track any players", ->
        stubNumberOfArenaOpponents(0)
        match = ArenaMatch!

        match\prepare!

        assert.is_empty(match.opponents)

    context "number of opponents is greater than 0", ->
      context "Spec is available for player", ->
        it "adds the opponent to the players table", ->
          frostSpecId = 156
          stubNumberOfArenaOpponents(1)
          opponentSpecStub = stubOpponentSpec(frostSpecId)
          match = ArenaMatch!

          match\prepare!
          arena1 = match.opponents["arena1"]

          assert.stub(opponentSpecStub).was.called_with(1)
          assert.equal(arena1.spec, frostSpecId)

      context "Spec is not available for player", ->
        it "does not add the opponent to the players table", ->
          stubNumberOfArenaOpponents(1)
          opponentSpecStub = stubOpponentSpec(0)
          match = ArenaMatch!

          match\prepare!

          assert.stub(opponentSpecStub).was.called_with(1)
          assert.is_empty(match.opponents)
