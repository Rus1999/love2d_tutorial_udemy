function love.load()
  target = {}
  target.x = love.graphics.getWidth() / 2
  target.y = love.graphics.getHeight() / 2
  target.radius = 50

  score = 0
  timer = 2 -- countdown

  gameFont = love.graphics.newFont(40)
end

function love.update(dt) -- 60 fps
  if (timer > 0) then
    timer = timer - dt
  end

  if (timer < 0) then
    timer = 0
  end
end

function love.draw() -- 60 fps graphical related only
  love.graphics.setColor(255/255, 77/255, 77/255)
  love.graphics.circle("fill", target.x, target.y, target.radius)
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gameFont)
  love.graphics.print(score, 0, 0)
  love.graphics.print(math.ceil(timer), 100, 0)
end

function love.mousepressed(x, y, button, istouch, presses)
  --[[
    x, y : mouse position when mouse is pressesd
    button : which button is pressed (1:primary, 2:secondary, 3:middle)
  ]]
  if (button == 1) then
    local distanceBetweenMouseToTarget = 
                distanceBetween(x, y, target.x, target.y)
    if (distanceBetweenMouseToTarget < target.radius) then
      -- mouse is over the target
      score = score + 1
      target.x = math.random(target.radius, 
                              love.graphics.getWidth() - target.radius)
      target.y = math.random(target.radius, 
                              love.graphics.getHeight() - target.radius)
    end
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end