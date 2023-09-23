local Timer = require("core/timer")
local World = require("core/world")
local Entity = require("core/entity")
local flux = require("libs/flux")
local Player = require("player")
local Letter = require("letter")
local InputBox = require("inputbox")
local Dictionary = require("dictionary")
local Shaker = require("shaker")
local Hearts = require("heartsui")

local UIScoreBig = love.graphics.newFont("assets/bigblue.ttf", 72)
local UIScoreSmall = love.graphics.newFont("assets/bigblue.ttf", 20)

function love.load()
  love.window.setMode(1024, 1024)
  love.window.setTitle("GAIE")
  love.window.setVSync(true)
  love.keyboard.setKeyRepeat(true)

  BestScore = 0
  InitGame()
end

function InitGame()
  GameWorld = World:new()
  WorldShaker = Shaker:new()
  UIWorld = World:new()
  Score = 0
  HeartsUI = Hearts:new(0, 0, 5)

  local width, height = love.graphics.getDimensions()
  local ox, oy = width / 2, height / 2
  MainPlayer = Player:new(ox, oy, HeartsUI)
  DefaultInputBox = InputBox:new(width / 2, height - 50)
  HeartsUI.entity.x = ox
  HeartsUI.entity.y = oy + 76
  HeartsUI.entity.scale = 0.5

  GameWorld:add(MainPlayer)
  UIWorld:add(DefaultInputBox)
  UIWorld:add(HeartsUI)

  if SpawnTimer ~= nil then
    Timer.clear(SpawnTimer)
  end

  SpawnTimer = Timer.setInterval(function()
    SpawnLetter(GameWorld, MainPlayer)
  end, 1)
end

function SpawnLetter(world, player)
  local choice = Dictionary.GetRandomHiragana()
  local width, height = love.graphics.getDimensions()
  local x, y = love.math.random(-width, 2 * width), love.math.random(-height, 2 * height)

  local enemy = Letter:new(x, y, choice)
  enemy:setTarget(player)

  world:add(enemy)
end

function love.keypressed(key)
  if HeartsUI.lives <= 0 then
    InitGame()
  end

  if key == "backspace" then
    DefaultInputBox:process(key)
  end

  if key == "f8" then
    Entity.debug = not Entity.debug
  end

  if key == "return" then
    local value = DefaultInputBox:submit()
    local target = nil

    for _, candidate in pairs(GameWorld.entities) do
      if candidate.letter ~= nil and Dictionary.GetKanaOfRomaji(value) == candidate.letter and not candidate.killed then
        if target == nil then
          target = candidate
        else
          local tdx = target.entity.x - MainPlayer.entity.x
          local tdy = target.entity.y - MainPlayer.entity.y
          local cdx = candidate.entity.x - MainPlayer.entity.x
          local cdy = candidate.entity.y - MainPlayer.entity.y
          if cdx * cdx + cdy * cdy < tdx * tdx + tdy * tdy then
            target = candidate
          end
        end
      end
    end

    if target ~= nil then
      target.killed = true

      local bullet = Letter:new(MainPlayer.entity.x, MainPlayer.entity.y, Dictionary.GetKanaOfRomaji(value))
      bullet.entity.scale = 0.6
      bullet.bullet = true
      bullet.speed = 600
      bullet.onCollision = function(self, other)
        if other == target then
          WorldShaker:shake()
          GameWorld:remove(bullet)
          GameWorld:remove(other)
          Score = Score + 1
          if Score > BestScore then
            BestScore = Score
          end
        end
      end
      bullet:setTarget(target)
      GameWorld:add(bullet)
    end
  end
end

function love.textinput(key)
  DefaultInputBox:process(key)
end

function love.update(dt)
  if HeartsUI.lives > 0 then
    GameWorld:update(dt)
    UIWorld:update(dt)
    Timer.update(dt)
    WorldShaker:update(dt)
    flux.update(dt)
  end
end

function love.draw()
  WorldShaker:draw(function()
    GameWorld:draw()
    UIWorld:draw()

    love.graphics.setFont(UIScoreBig)
    love.graphics.print(tostring(Score), 10, 10)
    love.graphics.setFont(UIScoreSmall)
    love.graphics.print("Best: "..tostring(BestScore), 10, 80)
  end)

  if HeartsUI.lives <= 0 then
    local w, h = love.graphics.getDimensions()
    love.graphics.push("all")
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.pop()
    local swTitle = UIScoreBig:getWidth("GAME OVER")
    local swSubtitle = UIScoreSmall:getWidth("Press any key to restart")
    love.graphics.setFont(UIScoreBig)
    love.graphics.print("GAME OVER", w / 2 - swTitle / 2, h / 4)
    love.graphics.setFont(UIScoreSmall)
    love.graphics.print("Press any key to restart", w / 2 - swSubtitle / 2, h - h / 4)
  end
end
