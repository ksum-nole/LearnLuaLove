angleOffset = 0
rainbowColors = {
    {1, 0, 0}, -- red (i think)
    {1, 0.5, 0}, -- orange idk
    {1, 1, 0},--maybe yellow
    {0 , 1, 0}, -- i think pink
    {0, 0 , 1}, -- probably blue
    {0.29, 0 , 0.51},-- this might be indigo
    {0.56, 0 , 1} -- purple
    -- im guessing about the colors
}
function drawRainbowCircle(cx, cy, radius, segments)
    local numColors = #rainbowColors
    local angleStep = (2 * math.pi) / numColors


    for i, color in ipairs(rainbowColors) do
        local angle1 = (i - 1) * angleStep + angleOffset
        local angle2 = i * angleStep + angleOffset
        local x1 = cx + math.cos(angle1) * radius
        local y1 = cy + math.sin(angle1) * radius
        local x2 = cx + math.cos(angle2) * radius
        local y2 = cy + math.sin(angle2) * radius

        love.graphics.setColor(color)
        love.graphics.polygon("fill", cx, cy, x1, y1, x2, y2)
    end
end

    
wall = nil
x = 105
y = 100
burstduration = 3
bulletspeed = 800
bullets = {}
spawnTimer = 0
spawnInterval = 0.20 
rockets = {}
spawntimer2 = 0
rocketspawninterval = 1
rocketspeed = 400
burstsinterval = 21
burststimer = 0
rocketblocked = 0
bleg = 0
burstactive = false
blockedbullets = {}
shadowbullets = {}
spawnInterval3 = 3
spawnTimer3 = 0
shadowbulletspeed = 400

---backgroundImage = love.image.newImageData(0, 0)

function love.load()
    rect = {}
    rect.width = 640
    rect.height = 480
    alive = true

    backgroundImage = love.graphics.newImage("citybackground.png")
    print(string.format("backgroundImage: %d, %d", backgroundImage:getWidth(), backgroundImage:getHeight()))
end

-- Circle-rectangle collision (for shield)
function checkCollisionCircleRect(circleX, circleY, circleRadius, rectX, rectY, rectWidth, rectHeight)
    local closestX = math.max(rectX, math.min(circleX, rectX + rectWidth))
    local closestY = math.max(rectY, math.min(circleY, rectY + rectHeight))
    local distanceX = circleX - closestX
    local distanceY = circleY - closestY
    return (distanceX * distanceX + distanceY * distanceY) < (circleRadius * circleRadius)
end

-- Circle-circle collision (for player-bullet/rocket)
function checkCollisionCircleCircle(x1, y1, r1, x2, y2, r2)
    local dx = x1 - x2
    local dy = y1 - y2
    return (dx * dx + dy * dy) < ((r1 + r2) * (r1 + r2))
end

function love.update(dt)
    angleOffset = (angleOffset + dt) % (2 * math.pi)
    for i = 0, love.graphics.getWidth() / backgroundImage:getWidth() do
        for j = 0, love.graphics.getHeight() / backgroundImage:getHeight() do
            love.graphics.draw(backgroundImage, i * backgroundImage:getWidth(), j * backgroundImage:getHeight())
        end
    end
    -- wall rehehehehe
    if love.keyboard.isDown("e") and wall == nil then
    wall = {
        x = x + 40,
        y = y,
        width = 10,
        height = 70,
        duration = 5  -- seconds
    }
end


    if wall then
    wall.duration = wall.duration - dt
    if wall.duration <= 0 then
        wall = nil
    end
end


    if alive then
        -- Player movement with full boundaries
        if love.keyboard.isDown("d") and x + 25 <= rect.width then
            x = x + 5
        end
        if love.keyboard.isDown("a") and x - 25 >= 0 then
            x = x - 5
        end
        if love.keyboard.isDown("s") and y + 25 <= rect.height then
            y = y + 5
        end
        if love.keyboard.isDown("w") and y - 25 >= 0 then
            y = y - 5
        end
        
        -- Spawn shadowbullets rehehehehe
        spawnTimer3 = spawnTimer3 + dt
        if spawnTimer3 >= spawnInterval3 then
            spawnTimer3 = 0
            shadowbullet = {
            x = rect.width,
            y = math.random(0, rect.height),
            radius = 5
            }
            table.insert(shadowbullets, shadowbullet)
        end
        -- Spawn bullets
        spawnTimer = spawnTimer + dt
        if spawnTimer >= spawnInterval then
            spawnTimer = 0
            local bullet = {
                x = rect.width,
                y = math.random(0, rect.height),
                radius = 5
            }
            bullets[#bullets + 1] = bullet
        end

        -- Spawn rockets
        spawntimer2 = spawntimer2 + dt
        if spawntimer2 >= rocketspawninterval then
            spawntimer2 = 0
            local  rocket = {
                x = rect.width,
                y = math.random(0, rect.height),
                radius = 20
            }
            rockets[#rockets + 1] = rocket
        end
bleg = bleg + dt
        -- spawn bursts
        burststimer = burststimer + dt
        if not burstactive and burststimer >= burstsinterval then
            burstactive = true
            
            burststimer = 0
            spawnInterval = 0.000000000000000000000000001
        end
       
            if bleg >= 4 then
                burstactive = false
                bleg = 0
                burstsimer = 0
                spawnInterval = 0.20
            end
       
        --update shadowbullets rehehehehe
        for i = #shadowbullets, 1, -1 do
            local shadowbullet = shadowbullets[i]
            shadowbullet.x = shadowbullet.x - shadowbulletspeed * dt

    -- Check collision with player only
    if checkCollisionCircleCircle(x, y, 25, shadowbullet.x, shadowbullet.y, shadowbullet.radius) then
        alive = false
    end

    if shadowbullet.x < -10 then
        table.remove(shadowbullets, i)
    end
end

        end
        -- Update bullets
        for i = #bullets, 1, -1 do
             bullet = bullets[i]
            bullet.x = bullet.x - bulletspeed * dt

            if bullet.x < -10 then
                table.remove(bullets, i)
            else
                local blocked = false
                if love.mouse.isDown(2) then
                    local shieldX = x + 30
                    local shieldY = y - 30
                    local shieldW = 10
                    local shieldH = 70
                    if checkCollisionCircleRect(bullet.x + 5, bullet.y + 5, bullet.radius, shieldX, shieldY, shieldW, shieldH) then
                        table.remove(bullets, i)
                        blocked = true

                       
                    end
                end
            end
                if not blocked then
                    if checkCollisionCircleCircle(x, y, 25, bullet.x + 5, bullet.y + 5, bullet.radius) then
                        alive = false
                    end
                end
                if wall and checkCollisionCircleRect(bullet.x, bullet.y, bullet.radius, wall.x, wall.y - wall.height/2, wall.width, wall.height) then
                    table.remove(bullets, i)
            end
        end

        -- Update rockets
        for i = #rockets, 1, -1 do
            local rocket = rockets[i]
            rocket.x = rocket.x - rocketspeed * dt

            if rocket.x < -20 then
                table.remove(rockets, i)
            else
                local blocked = false
                if love.mouse.isDown(2) then
                    local shieldX = x + 30
                    local shieldY = y - 30
                    local shieldW = 10
                    local shieldH = 70
                    if checkCollisionCircleRect(rocket.x + 10, rocket.y + 10, rocket.radius, shieldX, shieldY, shieldW, shieldH) then
                    blocked = true
                        if alive then
                            rocketblocked = rocketblocked + 1
                        end

                        
                        
                    end
                end
                if not blocked then
                    if checkCollisionCircleCircle(x, y, 25, rocket.x + 10, rocket.y + 10, rocket.radius) then
                        alive = false
                    end
                end
            end
                if wall and checkCollisionCircleRect(rocket.x + 10, rocket.y + 10, rocket.radius, wall.x, wall.y - wall.height/2, wall.width, wall.height) then
                    table.remove(rockets, i)
                else
    if not blocked and checkCollisionCircleCircle(x, y, 25, rocket.x + 10, rocket.y + 10, rocket.radius) then
        alive = false
    end
end
     
            end
        end
    


function love.draw()
    if alive then
        -- Draw player
        love.graphics.setColor(0, 0 , 1)
        drawRainbowCircle(x, y, 25 )
        if burstactive then
            love.graphics.setColor(1, 1, 1, 0.1) -- white flash
            love.graphics.rectangle("fill", 0, 0, rect.width, rect.height)
        end


        -- Draw shield if active
        
        if love.mouse.isDown(2) then
            love.graphics.rectangle("fill", x + 30, y - 30, 10, 70)
        end
   
        -- Draw bullets
        for _, bullet in ipairs(bullets) do
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", bullet.x, bullet.y, 10, 10)
        end

        -- Draw rockets

        for _, rocket in ipairs(rockets) do
            love.graphics.rectangle("fill", rocket.x, rocket.y, 20, 20)
        end

        love.graphics.print("Bullet count " .. #bullets, 32, 32)
    else
        love.graphics.print("Game Over", rect.width / 2 - 30, rect.height / 2)
    end
    -- draw wall
    if wall then
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", wall.x, wall.y - wall.height/2, wall.width, wall.height)
    end
    --drawshadowbullets
    for _, shadowbullet in ipairs(shadowbullets) do
    love.graphics.setColor(0.2, 0.2, 0.2) -- dark gray for shadow bullets
    alpha = 0.5
    love.graphics.circle("fill", shadowbullet.x, shadowbullet.y, shadowbullet.radius)
end
end


