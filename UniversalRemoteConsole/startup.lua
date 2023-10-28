-- Created by Player_rs
-- V: 0.5

-- check requirements
if not fs.exists('deps/touchpoint') then
    shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/touchpoint /deps/touchpoint')
end

if not fs.exists('deps/RemoteAPI') then
    shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/RemoteAPI /deps/RemoteAPI')
end

if not fs.exists('deps/Utils') then
    shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/Utils /deps/Utils')
end

if not fs.exists('data/config.lua') then
    shell.run('wget run https://raw.githubusercontent.com/Playerrs/CCrepo/master/UniversalRemoteConsole/configGen.lua')
end

if fs.exists('.editArgs') then
    local f = fs.open('.editArgs', 'r')
    local data = textutils.unserialize(f.readAll())
    f.close()
    local function run()
        shell.run("configEdit.lua ", data[1], data[2], data[3], data[4])
    end
    local function wait()
        while true do
            sleep(1)
        end
    end
    parallel.waitForAll(run, wait)
end

-- load requirements
os.loadAPI('/deps/touchpoint')
local tp = touchpoint
local remote = require('/deps/RemoteAPI')
os.loadAPI('/deps/Utils')
local utils = Utils

-- variables
local backgroundColor = colors.green
local buttonsColor = colors.lime
local W, H = term.getSize()
local actualInstance
local listInstances
local listeningModem = true

-- create a RemoteAPI object
local pocket = remote.new("Sla", 1520)

-- menus
local actualMenu
local main_menu = tp.new()
local console_menu = tp.new()
local instances_menu = tp.new()
local editInstance_menu = tp.new()

-- data
local function loadInstances()
    local f = fs.open('data/config.lua', 'r')
    local data = f.readAll()
    f.close()
    data = textutils.unserialize(data)
    return data.instances
end

-- screen

local function setInstanceToPocket(instance)
    pocket = remote.new(instance.name, instance.channel)
end

local function background(clear, nRows)
    if clear then utils.reset() end
    local _color = term.getBackgroundColor()
    local rows = nRows or 1
    for iH = 1, rows do
        for iW = 1, W do
            term.setCursorPos(iW, iH)
            term.setBackgroundColor(backgroundColor)
            term.write(" ")
        end
    end

    term.setBackgroundColor(_color)
    term.setCursorPos(1, 3)
end


local function getUserInput()
    local x, y = 1, math.floor((H/2)-3)
    term.setBackgroundColor(backgroundColor)

    for _width = 1, W do
        for _height = y, y+4 do
            if _width == 1 or _width == W then term.setBackgroundColor(buttonsColor) end
            if _height == y or _height == y+4 then term.setBackgroundColor(buttonsColor) end

            term.setCursorPos(_width, _height)
            term.write(" ")
            term.setBackgroundColor(backgroundColor)
        end
    end
    term.setCursorPos(x+1, y+2)
    term.write("> ")
    local msg = read()
    return msg
end


main_menu:add("Instances", function()
    actualMenu = instances_menu
    listeningModem = false
    background(true)
end, (W/2)-5, (H/2)-2, (W/2)+5, (H/2), buttonsColor, buttonsColor)

main_menu:add("Settings", function()
    -- TODO Settings
end, (W/2)-5, (H/2)+2, (W/2)+5, (H/2)+4, buttonsColor, buttonsColor)

console_menu:add("Instances", function()
    actualMenu = instances_menu
    listeningModem = false
    background(true)
end, 1, 1, 11, 1, backgroundColor, backgroundColor)

--- TODO mudar display para ficar ok de ver os enviados e recebidos
--- TODO USAR O PROPRIO CONSOLE PARA EDITAR/DELETAR CRIAR UMA INSTANCIA COM CHANNEL -1 E ELE LER ISSO; COMO ? NAO SEI AINDA

-- Runtimes (in plural ?)

actualMenu = main_menu

local function handleInstances()
    listInstances = loadInstances()
    local x, y = 1, 3
    local n = 0

    for k,v in pairs(instances_menu.buttonList) do
        instances_menu:remove(k)
    end

    for i =1, #listInstances do
        for k,v in pairs(listInstances[i]) do
            if n < 6 then
                if k == "name" then
                    instances_menu:add(v, function()
                        actualInstance = listInstances[i]
                        actualMenu = console_menu
                        setInstanceToPocket(listInstances[i])
                    end, x, y-1, W, y+1, buttonsColor, buttonsColor)
                    y = y+3
                    n = n+1
                end
            end
        end
    end

    if actualInstance then
        instances_menu:add("<", function()
            actualMenu = console_menu
            listeningModem = true
            background(true)
        end, 1, H, 5, H, buttonsColor, buttonsColor)
    end

    instances_menu:add("+", function()
        os.shutdown() --- TODO THIS
    end, W-5, H, W, H, buttonsColor, buttonsColor)
end

local function editInstance(instance)
    background(true)

    editInstance_menu:add("Rename", function()
        instance.name = getUserInput()
    end, (W/2)-5, (H/2)-2, (W/2)+5, (H/2), buttonsColor, buttonsColor)

    editInstance_menu:add("Channel", function()
        instance.channel = getUserInput()
        utils.debug(instance.channel)
        sleep(2)
    end, (W/2)-5, (H/2)+2, (W/2)+5, (H/2)+4, buttonsColor, buttonsColor)

    actualMenu = editInstance_menu
    -- TODO save the Instance
end

local function runAlways()
    local _color = term.getBackgroundColor()

    background(true)

    if actualMenu == console_menu then
        for k,v in pairs(pocket.lastMessages)do
            print(v)
        end

        term.setCursorPos(1, H)
        term.write("> " .. pocket.typed)

        background()

        for k,v in pairs(actualMenu.buttonList) do
            if k ~= "Instances" then
                actualMenu:remove(k)
            end
        end
        actualMenu:add(actualInstance.name, function() -- TODO download only one time?
            if fs.exists('configEdit.lua') then
                shell.run("delete configEdit.lua")
            end
            shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/UniversalRemoteConsole/configEdit.lua")
            local f = fs.open('.editArgs', 'w')
            local data = {"instances", actualInstance.name, actualInstance.channel}
            f.write(textutils.serialize(data))
            f.close()
            --multishell.launch({}, 'configEdit.lua', "instances", actualInstance.name, actualInstance.channel)
            --shell.exit()
            --shell.run('configEdit.lua', "instances", actualInstance.name, actualInstance.channel)
            --shell.run("delete configEdit.lua")
            os.reboot()
        end, W - (#actualInstance.name+1), 1, W, 1, backgroundColor)

        actualMenu:draw(false)

    elseif actualMenu == editInstance_menu then
        background(true)
        editInstance_menu:draw()

    elseif actualMenu == main_menu then
        background(true, 3)
        main_menu:draw(false)
        utils.printCenter("  Universal Remote Console", false, 2, nil, backgroundColor)

    else
        background()
        handleInstances()
        instances_menu:draw(false)
        utils.printCenter(" Instances", false, 1, nil, backgroundColor)

    end

    term.setBackgroundColor(_color)
    term.setCursorPos(1, 3)
end

-- RemoteAPI Runtime
while true do
    local function pocketRun()
        pocket:run(pocket, function()
            runAlways()
        end, function()
            runAlways()
        end)
    end

    local function callEvent()
        local event, button = actualMenu:handleEvents(os.pullEvent())
        if event == "button_click" then
            actualMenu.buttonList[button].func()
            --waitFinish()
        end
    end

    parallel.waitForAny(pocketRun, callEvent)
end

--- OLD
--local function writeInstanceName(instance)
--    local _color = term.getBackgroundColor()
--    term.setCursorPos(W - (#instance+1), 1)
--    term.setBackgroundColor(backgroundColor)
--    term.write(instance)
--    term.setBackgroundColor(_color)
--end