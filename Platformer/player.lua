
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

function playerUpdate(dt)
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

function drawPlayer()
  local px, py = player:getPosition()
  -- draw(spriteSheet, x, y, rotation, xscale, yscale(x), horizontalOffset, verticalOffset)
  player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end