require "spec/spec_helper"
require "src/util"

describe("Util", function()
  describe("select", function()
    it("returns a new table for each entry that function returns true", function()
      local matches = {
        {
          ["ranked"] = true
        },
        {
          ["ranked"] = false
        }
      }
      local expected_table = {
        {
          ["ranked"] = true
        }
      }
      local result = util.select(matches, function(match)
        return match.ranked
      end)

      local result_size = select("#", result)

      assert.equal(result_size, 1)
      assert.True(result[1].ranked)
    end)
  end)

  describe("table_has_key", function()
    it("returns true when the given table includes the given key", function()
      local character = {
        name = "Doctype",
        class = "Mage"
      }

      local has_key = util.table_has_key("name", character)

      assert.True(has_key)
    end)

    it("returns false when the given table does not include the given key", function()
      local character = {
        name = "Doctype",
        class = "Mage"
      }

      local has_key = util.table_has_key("Spec", character)

      assert.False(has_key)
    end)
  end)

  describe("reverse", function()
    it("returns a new table which is the reverse of the input", function()
      local reverseMe = {
        "foo",
        "bar",
        "baz"
      }

      local reversed = util.reverse(reverseMe)

      assert.equal("baz", reversed[1])
      assert.equal("bar", reversed[2])
      assert.equal("foo", reversed[3])
    end)
  end)

  describe("reduce", function()
    it("combines all elements of a table into a single value", function()
      local matches = {
        {
          won = true
        },
        {
          won = false
        },
        {
          won = true
        }
      }

      local result = util.reduce(matches, 0, function(memo, match)
        if match.won then
          return memo + 1
        else
          return memo
        end
      end)

      assert.equal(2, result)
    end)
  end)
end)
