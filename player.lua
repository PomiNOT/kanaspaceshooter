local Entity = require("core/entity")
local Player = { WIDTH = 50, HEIGHT = 50 }

function Player:new(x, y, hearts)
  local o = {}
  o.entity = Entity:new(x, y, self.WIDTH, self.HEIGHT)
  o.hearts = hearts
  setmetatable(o, { __index = Player })
  return o
end

function Player:onCollision(other, world)
  if not other.bullet then
    self.hearts:sub()
    world:remove(other)
  end
end

function Player:draw()
  self.entity:draw(function (entity, _)
    love.graphics.clear()
    love.graphics.rectangle("fill", 0, 0, entity.width, entity.height)
  end)
end

return Player
