local Shaker = {}

function Shaker:new()
  local o = {}
  o.duration = 0.2
  o.time = o.duration
  o.intensity = 25
  o.maxDisplacement = 15
  o.d = 0
  setmetatable(o, { __index = self })
  return o
end

function Shaker:shake()
  self.time = 0
end

function Shaker:update(dt)
  local n = love.math.noise(love.timer.getTime() * self.intensity) * 2 - 1
  local progress = self.time / self.duration
  if progress < 1 then
    self.time = self.time + dt
  elseif progress > 1 then
    progress = 1
  end

  self.d = (1 - progress) * n * self.maxDisplacement
end

function Shaker:draw(func)
  love.graphics.push()
  love.graphics.translate(self.d, self.d)
  func()
  love.graphics.pop()
end

return Shaker
