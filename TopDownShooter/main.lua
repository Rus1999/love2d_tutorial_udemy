-- =================================LOAD====================================================
function love.load()
  -- sprites
  sprites = {}
  sprites.background = love.graphics.newImage('sprites/background.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')

  -- player
  player = {}
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 210

  -- tables
  zombies = {}
  bullets = {}
end

-- =================================UPDATE===================================================
function love.update(dt)
  -- movement
  -- mutiply dt to make the movement framerate independent
  -- check if key is down continually
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end

  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end

  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end
  
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end

  -- zombies walk
  for i, z in ipairs(zombies) do
    -- use cos(radian angle) to get the x value that zombie will move to
    z.x = z.x + (math.cos(angleBetweenPlayerAndZombie(z)) * z.speed * dt)
    -- use sin(radian angle) to get the y value that zombie will move to 
    z.y = z.y + (math.sin(angleBetweenPlayerAndZombie(z)) * z.speed  * dt)

    if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
      for i, z in ipairs(zombies) do
        -- remove table element by assigning the nil value to the table element
        zombies[i] = nil
      end
    end
  end

  -- bullets travel
  for i, b in ipairs(bullets) do
    -- make bullet travel to the current mouse position (b.direction)
    b.x = b.x + (math.cos(b.direction) * b.speed * dt)
    b.y = b.y + (math.sin(b.direction) * b.speed * dt)
  end

  -- delete bullet
  -- #bullets return table size
  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b.x < 0 or b.y < 0 
      or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then 
        table.remove(bullets, i)
    end
  end

  -- compare every zombie to every bullet
  for i, z in ipairs(zombies) do
    for j, b in ipairs(bullets) do 
      -- check collision between zombie and bullet
      if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
      end
    end
  end

  -- remove zombies that has .dead = true
  for i=#zombies, 1, -1 do
    local z = zombies[i]
    if z.dead == true then
      table.remove(zombies, i)
    end
  end

  -- remove bullets that has .dead = true
  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b.dead == true then
      table.remove(bullets, i)
    end
  end
end

-- =================================DRAW====================================================
function love.draw()
  love.graphics.draw(sprites.background, 0, 0)
  love.graphics.draw(sprites.player, player.x, player.y, angleBetweenPlayerAndMouse(), 
                      nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

  for i, z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y, angleBetweenPlayerAndZombie(z), nil, nil,
                        sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
  end

  for i, b in ipairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, nil, 
                        sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
  end
end

-- =================================FUNCTION=================================================
-- check once if key is pressed
function love.keypressed(key)
  if key == "space" then
    spawnZombie()
  end
end

-- run when mouose is pressed once
function love.mousepressed(x, y, button)
  if button == 1 then
    spawnBullet()
  end
end

function angleBetweenPlayerAndMouse()
  -- return angle and flip it by adding pi (180 degree rotation)
  -- radian rotation = degree rotation * (Pi / 180)
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function angleBetweenPlayerAndZombie(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
  local zombie = {}
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 140
  zombie.dead = false
  
  -- set the spawn position (side) of the zombie
  local side = math.random(1, 4)
  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 3 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end
  
  table.insert(zombies, zombie)
end

function spawnBullet()
  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 700
  bullet.dead = false
  -- each bullet has it's own direction
  -- bullet will tarvel from player to the mouse position
  bullet.direction = angleBetweenPlayerAndMouse()
  table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end