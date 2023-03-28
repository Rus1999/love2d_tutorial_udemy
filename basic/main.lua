message = 0

testScores = {7, 70, 700}
testScores.subject = "Mathmatic"

for i,s in ipairs(testScores) do
    message = message + s
end

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(testScores.subject)
end