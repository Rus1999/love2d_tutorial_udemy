function love.load()
    button = {}
    button.x = 200
    button.y = 200
    button.size = 50

    score = 0
    timer = 0

    myFont = love.graphics.newFont(40)
end


function love.update(dt)

end


function love.draw()
    love.graphics.setFont(myFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(score)

    love.graphics.setColor(255/255, 70/255, 70/255)
    love.graphics.circle("fill", button.x, button.y, button.size)
end


-- call this function when mouse is click
function love.mousepressed(x, y, b, istouch)
    -- 1: primary, 2: secondary, 3: middle
    if b == 1 then
        if distanceBetween(
            button.x, button.y, 
            love.mouse.getX(), love.mouse.getY()) < button.size 
        then
            score = score + 1
            button.x = math.random(button.size, love.graphics.getWidth() - button.size)
            button.y = math.random(button.size, love.graphics.getHeight() - button.size
        )
        end
    end
end


function distanceBetween(x1, y1, x2, y2)
    return math.sqrt(((y2 - y1)^2) + ((x2 - x1)^2))
end