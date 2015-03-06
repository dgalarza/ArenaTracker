export class ArenaMatch
  new: =>
    @saved = false
    @won = false
    @players = {}

  prepare: =>
    numberOfOpponents = GetNumArenaOpponentSpecs!
    if numberOfOpponents and numberOfOpponents > 0
      @prepArenaOpponentSpecializations!

  determineResults: =>
    myFaction = GetBattlefieldArenaFaction!
    @won = @getWinner! == myFaction

  toTable: =>
    results = {
      won: @won,
      players: {}
    }

    for _, unit in pairs(@players) do
      table.insert results["players"], unit

    results

  getWinner: ->
    GetBattlefieldWinner!

  unitNameUpdated: (unit) =>
    if isValidUnit(unit)
      name = UnitName(unit)

      if name
        @updateUnit(unit, "name", name)

  prepArenaOpponentSpecializations: =>
    numberOfOpponents = GetNumArenaOpponentSpecs!
    match = {}

    for i = 1, numberOfOpponents do
      unit = "arena"..i
      specID = GetArenaOpponentSpec(i)
      if specID > 0
        @updateUnit(unit, "spec", specID)

  updateUnit: (unit, attribute, value) =>
    @buildUnit(unit)
    @players[unit][attribute] = value

  buildUnit: (unit) =>
    if @players[unit] == nil
      @players[unit] = ArenaPlayer!

  isValidUnit = (unit) ->
    strfind(unit, "arena") and not strfind(unit, "pet")
