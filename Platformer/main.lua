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

  -- collider = physics object 
  -- new...Collider(x, y, width, height, collision class)
  player = world:newRectangleCollider(360, 100, 40, 100, {collision_class = "Player"})
  player:setFixedRotation(true)
  player.speed = 280
  player.animation = animations.idle
  player.isMoving = false
  -- 1: right, -1: left
  player.direction = 1
  player.grounded = true

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

  -- if player body is exists
  if player.body then
    -- detect platform on feet
    local colliders = world:queryRectangleArea(player:getX() - 20, 
    player:getY() + 50, 40, 2, {'Platform'})
    if #colliders > 0 then
      player.grounded = true
    else
      player.grounded = false
    end

    player.isMoving = false

    -- get player position 
    -- player:getPosition OR player:getX(), player:getY()
    -- to set player position 
    -- player:setPosition OR player:setX, player:setY
    local px, py = player:getPosition()
    if love.keyboard.isDown('right') then
      player:setX(px + player.speed * dt)
      player.isMoving = true
      player.direction = 1
    end
    if love.keyboard.isDown('left') then
      player:setX(px - player.speed * dt)
      player.isMoving = true
      player.direction = -1
    end

    -- player enter collider with 'Danger'
    if player:enter('Danger') then
      player:destroy()
    end
  end

  if player.grounded then
    if player.isMoving then
      player.animation = animations.run
    else
      player.animation = animations.idle
    end
  else
    player.animation = animations.jump
  end

  -- make animation update with framerate independent
  player.animation:update(dt)
end

-- **********************DRAW************************
function love.draw()
  world:draw()
  
  local px, py = player:getPosition()
  -- draw(spriteSheet, x, y, rotation, xscale, yscale(x), horizontalOffset, verticalOffset)
  player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
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