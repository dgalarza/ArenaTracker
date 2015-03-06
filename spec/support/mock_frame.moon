export class MockFrame
  new: =>
    @name = nil
    @registeredEvents = {}
    @events = {}
    @scripts = {}

  RegisterEvent: (event_name) =>
    table.insert @registeredEvents, event_name

  SetScript: (scriptName, callback) =>
    @scripts[scriptName] = callback

  triggerEvent: (event, ...) =>
    @scripts["OnEvent"](@, event, ...)
