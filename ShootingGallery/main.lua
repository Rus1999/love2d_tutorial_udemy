function love.load()
  target = {}
  target.x = love.graphics.getWidth() / 2
  target.y = love.graphics.getHeight() / 2
  target.radius = 50

  score = 0
  timer = 0 -- countdown
  gameState = 1 -- 1: main menu, 2: gameplay

  gameFont = love.graphics.newFont(40)

  -- set sprites
  sprites = {}
  sprites.sky = love.graphics.newImage('sprites/sky.png')
  sprites.target = love.graphics.newImage('sprites/target.png')
  sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

  -- game settings
  love.mouse.setVisible(false)
end

function love.update(dt) -- 60 fps
  if timer > 0 then
    timer = timer - dt
  end

  if timer < 0 then
    timer = 0
    gameState = 1
  end
end

function love.draw() -- 60 fps graphical related only
  love.graphics.draw(sprites.sky, 0, 0)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gameFont)
  love.graphics.print("Score: " .. score, 0, 5)
  love.graphics.print("Timer: " .. math.ceil(timer), love.graphics.getWidth() - 200, 5)

  if gameState == 1 then
    love.graphics.printf("Click anywhere to play!", 
                          0, 250, love.graphics.getWidth(), "center")
  end

  if gameState == 2 then
    love.graphics.draw(sprites.target, 
                        target.x - target.radius, target.y - target.radius)
  end
  love.graphics.draw(sprites.crosshairs, 
                      love.mouse.getX()-20, love.mouse.getY()-20)
end

function love.mousepressed(x, y, button, istouch, presses)
  --[[
    x, y : mouse position when mouse is pressesd
    button : which button is pressed (1:primary, 2:secondary, 3:middle)
  ]]
  if gameState == 2 then
    local distanceBetweenMouseToTarget = 
                distanceBetween(x, y, target.x, target.y)
    if distanceBetweenMouseToTarget < target.radius then
      -- mouse is over the target
      if button == 1 then
        score = score + 1
      elseif button == 2 then
        score = score + 2
        timer = timer - 1
        end
      target.x = math.random(target.radius, 
                              love.graphics.getWidth() - target.radius)
      target.y = math.random(target.radius + 50, 
                              love.graphics.getHeight() - target.radius)
    elseif distanceBetweenMouseToTarget > target.radius and score > 0 then
      score = score - 1
    end
  elseif button == 1 and gameState == 1 then
    gameState = 2
    timer = 28
    score = 0
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end