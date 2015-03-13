local FramePrototype = {}

function FramePrototype:RegisterEvent(event_name)
  table.insert(self.registeredEvents, event_name)
end

function FramePrototype:SetScript(scriptName, callback)
  self.scripts[scriptName] = callback
end

function FramePrototype:triggerEvent(event, ...)
  self.scripts["OnEvent"](self, event, ...)
end

FramePrototype.__index = FramePrototype

MockFrame = setmetatable({
  __init = function(self)
    self.name = nil
    self.registeredEvents = {}
    self.events = {}
    self.scripts = {}
  end,

  __base = FramePrototype,
  __name = "MockFrame"

}, {
  __index = FramePrototype,
  __call = function(cls, ...)
    local obj = setmetatable({}, FramePrototype)
    cls.__init(obj, ...)
    return obj
  end
})
