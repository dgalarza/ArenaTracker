require "spec/spec_helper"

describe("WowApi", function()
  describe("IsRankedArenaMatch", function()
    describe("Arena match is not a skirmish", function()
      it("returns true", function()
        stub(_G, "IsArenaSkirmish", false)

        assert.True(WowApi.IsRankedArenaMatch())
      end)
    end)

    describe("Arena match is a skirmish", function()
      it("returns false", function()
        stub(_G, "IsArenaSkirmish", true)

        assert.False(WowApi.IsRankedArenaMatch())
      end)
    end)
  end)
end)
