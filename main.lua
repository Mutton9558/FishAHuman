--run: ctrl + alt + win + L
-- Fish fishes humans
-- each human -> 10 corals
-- different poles -> different amount of corals
-- powerups and more in shop

function love.load()

    screenWidth, screenHeight = love.graphics.getDimensions()
    love.window.setTitle("Fish a Human")

    logo = love.image.newImageData('sprites/logo.png')
    background = love.graphics.newImage('sprites/background.png')
    menuSign = love.graphics.newImage('sprites/sign.png')

    love.window.setIcon(logo)
    font = love.graphics.newFont(32)
    love.graphics.setFont(font)

    player = {}
    player.x = screenWidth * 0.5 - 25
    player.y = screenHeight - 100
    player.speed = 5

    scenes = {"MainMenu", "FishArea", "Shop"}
    curScene = scenes[1]

    buttonText = {"New Game", "Load Game", "Quit"}
    
    background:setFilter("nearest", "nearest")
    menuSign:setFilter("nearest", "nearest")
    isEscaped = false

    mouseLeftClick = love.mouse.isDown(1)
    humanObtained = nil
    humanDisplayed = false
end

function love.update(dt)
    if (curScene ~= "MainMenu" and not isEscaped) then
        if love.keyboard.isDown("a", "left") and love.keyboard.isDown("d", "right") then
            return
        elseif love.keyboard.isDown("d", "right") then
            player.x = player.x + player.speed
        elseif love.keyboard.isDown("a", "left") then
            if curScene == "FishArea" and math.floor(player.x) <= 0 then
                return
            else
                player.x = player.x - player.speed
            end
        end

        if curScene == "FishArea" and player.x > screenWidth then
            curScene = scenes[3]
            player.x = 0
        elseif curScene == "Shop" and player.x < 0 then
            curScene = scenes[2]
            player.x = screenWidth-50
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f11" then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false, "desktop")
        else
            love.window.setFullscreen(true, "desktop")
        end   
        screenWidth, screenHeight = love.graphics.getDimensions()
        player.x = screenWidth * 0.5 - 25
        player.y = screenHeight - 100
    end
end

function registerMouseAction(event)
    if event == "New Game" then
        curScene = scenes[2]
    elseif event == "Quit" then
        love.window.close()
    end
end

function love.draw()
    

    local bgWidth, bgHeight = background:getDimensions()
    
    local scaleX = screenWidth/bgWidth
    local scaleY = screenHeight/bgHeight
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10, 0, 0.5, 0.5)

    if curScene ~= "MainMenu" then
        love.graphics.rectangle("fill", player.x, player.y, 50,50)
        
        if curScene == "FishArea" then
            love.graphics.print("Fishing", screenWidth*0.5-(font:getWidth("Fishing")/2), 100)
            if humanObtained ~= nil then
                local locImgFile = 'sprites/' .. humanObtained .. ".png"
                local humanImg = love.graphics.newImage(locImgFile)
                humanImg:setFilter("nearest", "nearest")
                local imgX, imgY = humanImg:getDimensions()
                humanScaleX = 3
                humanScaleY = 3
                love.graphics.draw(humanImg, (screenWidth*0.5)-(imgX*0.5*humanScaleX), (screenHeight*0.5)-(imgY*0.5*humanScaleY), 0, humanScaleX, humanScaleY)
                humanDisplayed = true
            end
        else
            love.graphics.print("Shop", screenWidth*0.5-(font:getWidth("Shop")/2), 100)
        end
    else

        local menuWidth, menuHeight = menuSign:getDimensions()

        local menuScaleX = (screenWidth/(menuWidth*1.5))
        local menuScaleY = (screenHeight/menuHeight)

        love.graphics.draw(menuSign, (screenWidth*0.5)-(111*menuScaleX), (screenHeight*0.35) + 10 -(55*menuScaleY), 0, menuScaleX, menuScaleY)

        buttonWidth = screenWidth*0.175
        buttonHeight = buttonWidth*0.75

        love.graphics.push("all")

        for i = 1, 3, 1
        do
            bx = (screenWidth*0.25*i) - (buttonWidth*0.5)
            by = screenHeight*0.75

            love.graphics.setColor(0.24, 0.29, 0.4, 1.0)
            love.graphics.rectangle("fill", bx, by, buttonWidth, buttonHeight)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(buttonText[i], bx + (buttonWidth*0.5) - ((font:getWidth(buttonText[i]))*0.375), by + (buttonHeight*0.5), 0, 0.75, 0.75)
        end
        love.graphics.pop()
    end
end

function generateMan()
    local randNum = math.random(1, 2)
    if randNum == 1 then
        return "steve"
    else 
        return "alex"
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if (button == 1 and curScene == scenes[2] and humanDisplayed == false) then
        humanObtained = generateMan()
    elseif button == 1 and curScene == scenes[2] and humanDisplayed then
        humanObtained = nil
        humanDisplayed = false
    end

    if button == 1 and curScene == scenes[1] then
        for i = 1, 3 do
            local bx = (screenWidth * 0.25 * i) - (buttonWidth * 0.5)
            local by = screenHeight * 0.75

            if x >= bx and x <= bx + buttonWidth and y >= by and y <= by + buttonHeight then
                registerMouseAction(buttonText[i]) -- Call your function when clicked
            end
        end
    end
end
