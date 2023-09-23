local Timer = { timers = {} }

function Timer:new(timeout, func)
  local o = {}
  o.timeout = timeout or 0
  o.time = 0
  o.callback = func

  setmetatable(o, { __index = self })
  return o
end

function Timer:reset()
  self.time = 0
end

function Timer.update(dt)
  for _, timer in pairs(Timer.timers) do
    timer.time = timer.time + dt
    if timer.time > timer.timeout then
      timer.time = 0
      timer.callback()
    end
  end
end

function Timer.clear(timer)
  Timer.timers[timer] = nil
end

function Timer.setInterval(func, intervalSeconds)
  local timer = Timer:new(intervalSeconds, func)
  Timer.timers[timer] = timer
  return timer
end

return Timer
