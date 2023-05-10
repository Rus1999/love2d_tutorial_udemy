-- **********************LOAD************************
function love.load()
  wf = require 'libraries/windfield/windfield'
  -- newWorld(gravityX, gravityY, sleep(not calculate physic when sleep))
  world = wf.newWorld(0, 800, false)
  world:setQueryDebugDrawing(true)

  -- add collission class to the world
  world:addCollisionClass('Platform')
  world:addCollisionClass('Player'--[[ , {ignores = {'Platform'}} ]])
  world:addCollisionClass('Danger')

  -- collider = physics object 
  -- new...Collider(x, y, width, height)
  player = world:newRectangleCollider(360, 100, 80, 80, {collision_class = "Player"})
  player:setFixedRotation(true)
  player.speed = 280

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
    -- get player position 
    -- player:getPosition OR player:getX(), player:getY()
    -- to set player position 
    -- player:setPosition OR player:setX, player:setY
    local px, py = player:getPosition()
    if love.keyboard.isDown('right') then
      player:setX(px + player.speed * dt)
    end
    if love.keyboard.isDown('left') then
      player:setX(px - player.speed * dt)
    end

    -- player enter collider with 'Danger'
    if player:enter('Danger') then
      player:destroy()
    end
  end
end

-- **********************DRAW************************
function love.draw()
  world:draw()
end

-- **********************FUNCTION************************
function love.keypressed(key)
  if key == 'up' then
    local colliders = world:queryRectangleArea(player:getX() - 40, player:getY() + 40, 80, 2, {'Platform'})
    if #colliders > 0 then
      player:applyLinearImpulse(0, -5000)
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