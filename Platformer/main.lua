-- **********************LOAD************************
function love.load()
  anim8 = require 'libraries/anim8/anim8'

  sprites = {}
  sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

  -- newGrid(width, height, spritesSheetWidth, spritesSheetHeight)
  local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

  animations = {}
  -- newAnimation(grid('columnRange', row), FPS)
  animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
  animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
  animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)

  wf = require 'libraries/windfield/windfield'
  -- newWorld(gravityX, gravityY, sleep(not calculate physic when sleep))
  world = wf.newWorld(0, 800, false)
  world:setQueryDebugDrawing(true)

  -- add collission class to the world
  world:addCollisionClass('Platform')
  world:addCollisionClass('Player'--[[ , {ignores = {'Platform'}} ]])
  world:addCollisionClass('Danger')

  -- import player.lua
  require('player')

  -- platform
  platform = world:newRectangleCollider(250, 400, 300, 100, {collision_class = "Platform"})
  platform:setType('static')

  -- danger
  dangerZone = world:newRectangleCollider(0, 550, 800, 50, {collision_class = "Danger"})
  dangerZone:setType('static')
end

-- **********************UPDATE************************
function love.update(dt)
  world:update(dt)
  playerUpdate(dt)
end

-- **********************DRAW************************
function love.draw()
  world:draw()
  drawPlayer()
end

-- **********************FUNCTION************************
function love.keypressed(key)
  if key == 'up' then
    if player.grounded then
      player:applyLinearImpulse(0, -3500)
    end
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    -- store all colliders that has been find in the query area to variable
    local colliders = world:queryCircleArea(x, y, 200, {'Platform', 'Danger'})
    for i, c in ipairs(colliders) do
      c:destroy()
    end
  end
end