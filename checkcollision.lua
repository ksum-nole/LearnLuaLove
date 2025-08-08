x = 100
y = 100
function love.draw()
    love.graphics.circle("fill", x, y, 25, 25 )
end
    function love.update ()
        if love.keyboard.is.Down("d") then
            x = x + 5
    end
end 