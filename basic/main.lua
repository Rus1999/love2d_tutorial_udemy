-- variable
-- global
message = 0
word = "Rus"
chicken = 10
output = chicken + 1
-- local
local var = "I'm local variable"


-- while loop
count = 0
while count < 100 do
    count = count + 1
end 


-- for loop
for count=0, 7, 1 do
    chicken = 7
end


-- function
function increaseMessage(i)
    message = message + i
end

-- return function
function double(val)
    val = val * 2
    return val
end

-- function called
increaseMessage(21)
increaseMessage(chicken)
double(3.5)
double(chicken)


-- comment
-- one line comment
--[[ 
    mutiple line comment
]]


function love.draw()
    -- newFont(font-size)
    love.graphics.setFont(love.graphics.newFont(50))
    -- love.graphics.print(message) -- message value
    -- love.graphics.print(double(3.5)) -- call function and return to print
end
