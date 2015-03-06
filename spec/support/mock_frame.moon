export class MockFrame
  new: =>
    @name = nil
    @events = nil

  RegisterEvent: (event_name) =>
    table.insert @events, event_name

  SetScript: (callback) ->
