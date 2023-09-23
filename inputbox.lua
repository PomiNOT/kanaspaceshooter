local Entity = require("core/entity")
local Timer = require("core/timer")

InputBox = {
  font = love.graphics.newFont("assets/bigblue.ttf", 48),
  WIDTH = 480
}

function InputBox:new(x, y)
  local o = {}
  local fontHeight = self.font:getAscent() - self.font:getDescent()
  o.entity = Entity:new(x, y, self.WIDTH, fontHeight)
  o.string = ""
  o.cursorOpacity = 1
  o.cursorPosition = 0
  o.cursorTargetPosition = 0
  o.timer = Timer.setInterval(function()
    if o.cursorOpacity == 1 then
      o.cursorOpacity = 0
    else
      o.cursorOpacity = 1
    end
  end, 1)
  setmetatable(o, { __index = self })
  return o
end

function InputBox:update(dt)
  self.cursorPosition = self.cursorPosition + (self.cursorTargetPosition - self.cursorPosition) * dt * 15
end

function InputBox:process(char)
  self.cursorOpacity = 1
  if self.timer ~= nil then
    self.timer:reset()
  end

  local stringWidth = self.font:getWidth(self.string)

  if char == "backspace" then
    self.string = string.sub(self.string, 1, #self.string - 1)
  elseif stringWidth < self.WIDTH * 0.9 then
    self.string = self.string .. char
  end

  self.cursorTargetPosition = self.font:getWidth(self.string)
end

function InputBox:submit()
  local ret = self.string
  self.string = ""
  self.cursorTargetPosition = 0
  return ret
end

function InputBox:draw()
  self.entity:draw(function()
    love.graphics.clear()
    love.graphics.setFont(self.font)
    love.graphics.print(self.string, 0, 0)
    love.graphics.setColor(1, 1, 1, self.cursorOpacity)

    local h = self.entity:getHeight() * 0.7
    local dh = self.entity:getHeight() - h
    love.graphics.rectangle("fill", self.cursorPosition + 5, dh / 2, 10, h)
  end)
end

return InputBox
