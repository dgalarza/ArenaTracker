util = {}

function util.select(table, func)
  local new_table = {}

  for key, value in pairs(table) do
    if func(value) then
      new_table[key] = value
    end
  end

  return new_table
end

function util.table_has_key(needle, haystack)
  for key, _ in pairs(haystack) do
    if key == needle then
      return true
    end
  end

  return false
end

function util.reduce(list, memo, func)
  for _, value in pairs(list) do
    memo = func(memo, value)
  end

  return memo
end

function util.reverse(tbl)
  local reversed_table = {}

  for _, value in pairs(tbl) do
    table.insert(reversed_table, 1, value)
  end

  return reversed_table
end
