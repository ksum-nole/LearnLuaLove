x = 105
y = 100
bulletspeed = 300
bullets = {}
spawnTimer = 0
spawnInterval = 0.20 

for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    bullet.x = bullet.x - 15

    if love.mouse.isDown(2) then
        -- Shield is active
        local shieldX = x + 30
        local shieldY = y - 30
        local shieldW = 10
        local shieldH = 70

        -- Bullet center: bullet.x + 5, bullet.y + 5
        if checkCollision(bullet.x + 5, bullet.y + 5, bullet.radius, shieldX, shieldY, shieldW, shieldH) then
            table.remove(bullets, i) -- Shield blocks bullet
        end
    else
        -- No shield, check collision with player
        if checkCollision(bullet.x + 5, bullet.y + 5, bullet.radius, x - 25, y - 25, 50, 50) then
            alive = false
        end
    end
end

alive = true

function love.load()
    rect = {}
    rect.width = 640
    rect.height = 480
end

function checkCollision(circleX, circleY, circleRadius, rectX, rectY, rectWidth, rectHeight)
    local closestX = math.max(rectX, math.min(circleX, rectX + rectWidth))
    local closestY = math.max(rectY, math.min(circleY, rectY + rectHeight))
    local distanceX = circleX - closestX
    local distanceY = circleY - closestY
    return (distanceX * distanceX + distanceY * distanceY) < (circleRadius * circleRadius)

end

function love.draw()
    if alive then
        love.graphics.circle("fill", x, y, 25, 25)
        if love.mouse.isDown(2) then
            love.graphics.rectangle("fill", x + 30, y - 30, 10, 70)
            for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    bullet.x = bullet.x - 15

    if love.mouse.isDown(2) then
        -- Shield is active
        local shieldX = x + 30
        local shieldY = y - 30
        local shieldW = 10
        local shieldH = 70

        -- Bullet center: bullet.x + 5, bullet.y + 5
        if checkCollision(bullet.x + 5, bullet.y + 5, bullet.radius, shieldX, shieldY, shieldW, shieldH) then
            table.remove(bullets, i) -- Shield blocks bullet
        end
    else
        -- No shield, check collision with player
        if checkCollision(bullet.x + 5, bullet.y + 5, bullet.radius, x - 25, y - 25, 50, 50) then
            alive = false
        end
    end
end

        end
    else
        love.graphics.print("Game Over", rect.width / 2 - 30, rect.height / 2)
    end
    for key, bullet in pairs(bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, 10, 10)
    end
    love.graphics.print("Bullet count " .. #bullets, 32, 32)
end

function love.update(dt)
    if alive then
        if love.keyboard.isDown("d") and x <= rect.width then
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
        spawnTimer = spawnTimer + dt
        if spawnTimer >= spawnInterval then
            spawnTimer = 0
            local bullet = {
                x = rect.width, 
                y = math.random(0, rect.height),
                radius = 10
            }
            bullets[#bullets+1] = bullet
        end
    end
    for key, bullet in pairs(bullets) do
        bullet.x = bullet.x - 15
        bullet.y = bullet.y - 0
        if checkCollision(x, y, 25, bullet.x, bullet.y, 10, 10) then
            alive = false
        end
    end
end