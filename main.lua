x = 105
y = 100
function love.draw()
    love.graphics.circle("fill", x, y, 100, 100)
end
function love.update()
if love.keyboard.isDown ("d") then
        x = x + 5
    end
if love.keyboard.isDown("a") then
    x = x - 5    
end

if love.keyboard.isDown("s") then
   y = y + 5 
end

if love.keyboard.isDown("w") then
    y = y - 5
    end
end