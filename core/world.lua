local World = {}

function World:new()
  local o = {}
  o.entities = {}

  setmetatable(o, { __index = World })
  return o
end

function World:add(entity)
  self.entities[entity] = entity
end

function World:remove(entity)
  self.entities[entity] = nil
end

function World:bruteForceAABB(entity)
  for _, other in pairs(self.entities) do
    if other ~= entity then
      local rangeX = entity.entity:getWidth() / 2 + other.entity:getWidth() / 2
      local rangeY = entity.entity:getHeight() / 2 + other.entity:getHeight() / 2
      local dx = math.abs(entity.entity.x - other.entity.x)
      local dy = math.abs(entity.entity.y - other.entity.y)
      if dx <= rangeX and dy <= rangeY then
        entity:onCollision(other, self)
      end
    end
  end
end

function World:update(dt)
  for _, entity in pairs(self.entities) do
    if entity.onCollision ~= nil then
      self:bruteForceAABB(entity)
    end

    if entity.update ~= nil then
      entity:update(dt)
    end
  end
end

function World:draw()
  for _, entity in pairs(self.entities) do
    if entity.draw ~= nil then
      entity:draw()
    end
  end
end

return World
