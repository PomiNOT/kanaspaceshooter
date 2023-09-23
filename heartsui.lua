local Entity = require("core/entity")
local Hearts = {
  image = love.graphics.newImage("assets/heart.png")
}

function Hearts:new(x, y, max)
  local o = {}
  o.entity = Entity:new(x, y, self.image:getWidth() * max, self.image:getHeight())
  o.max = max
  o.lives = max

  setmetatable(o, { __index = self })
  return o
end

function Hearts:add()
  if self.lives < self.max then
    self.lives = self.lives + 1
  end
end

function Hearts:sub()
  if self.lives > 0 then
    self.lives = self.lives - 1
  end
end

function Hearts:draw()
  self.entity:draw(function()
    love.graphics.clear()
    for i=1,self.lives do
      love.graphics.draw(self.image, (i - 1) * self.image:getWidth(), 0)
    end
  end)
end

return Hearts
