local Entity = require("core/entity")
local flux = require("libs/flux")
local Letter = { WIDTH = 100, HEIGHT = 100, font = love.graphics.newFont("assets/font.ttf", 90) }

function Letter:new(x, y, letter)
  local o = {}
  o.entity = Entity:new(x, y, self.WIDTH, self.HEIGHT)
  o.letter = letter
  o.target = nil
  o.vx = 0
  o.vy = 0
  o.speed = 100
  o.opacity = 1
  o.bullet = false
  o.killed = false
  setmetatable(o, { __index = Letter })

  return o
end

function Letter:setTarget(target)
  self.target = target
  local vx, vy = CalculateVelocity(self.entity.x, self.entity.y, target.entity.x, target.entity.y)
  self.vx = vx
  self.vy = vy
end

function CalculateVelocity(x0, y0, x1, y1)
  local dx = x1 - x0
  local dy = y1 - y0
  local len = math.sqrt(dx * dx + dy * dy)
  return dx / len, dy / len
end

function Letter:update(dt)
  if self.target ~= nil then
    self.entity.x = self.entity.x + self.vx * self.speed * dt
    self.entity.y = self.entity.y + self.vy * self.speed * dt
  end
end

function Letter:draw()
  self.entity:draw(function ()
    love.graphics.clear()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.opacity, 0, 0)
    love.graphics.print(self.letter, 5, -20)
  end)
end

return Letter
