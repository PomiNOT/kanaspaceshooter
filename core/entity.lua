local Entity = { debug = false }

function Entity:new(x, y, width, height)
  local o = {}
  o.x = x
  o.y = y
  o.width = width or 0
  o.height = height or 0
  o.rotation = 0
  o.scale = 1
  o.canvas = love.graphics.newCanvas(o.width, o.height)
  setmetatable(o, { __index = self })
  return o
end

function Entity:getWidth()
  return self.width * self.scale
end

function Entity:getHeight()
  return self.height * self.scale
end

function Entity:draw(drawfunc)
  if drawfunc ~= nil then
    love.graphics.push("all")
    love.graphics.reset()
    love.graphics.setCanvas(self.canvas)
    drawfunc(self, self.canvas)
    love.graphics.pop()

    love.graphics.draw(
      self.canvas,
      self.x,
      self.y,
      self.rotation,
      self.scale, self.scale,
      self.width / 2,
      self.height / 2
    )

    if Entity.debug then
      love.graphics.rectangle("line", self.x - self:getWidth() / 2, self.y - self:getHeight() / 2, self:getWidth(), self:getHeight())
    end
  end
end

return Entity
