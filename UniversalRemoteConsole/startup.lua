-- Created by Player_rs
-- V: 0.2

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

if not fs.exists('data/instances.json') then
    shell.run('wget run https://raw.githubusercontent.com/Playerrs/CCrepo/master/UniversalRemoteConsole/configGen.lua')
end

-- load requirements
os.loadAPI('/deps/touchpoint')
local tp = touchpoint
local remote = require('/deps/RemoteAPI')
os.loadAPI('/deps/Utils')
local utils = Utils

-- variables
local backgroundColor = colors.green
local W, H = term.getSize()
local actualInstance
local listInstances
local listeningModem = true

-- create a RemoteAPI object
local pocket = remote.new("Sla", 1520)

-- menus
local actualMenu
local main_menu = tp.new()
local instances_menu = tp.new()

-- data
local function loadInstances()
    local f = fs.open('data/instances.json', 'r')
    local data = f.readAll()
    f.close()
    data = textutils.unserializeJSON(data)
    return data.instances
end

-- screen
local function background(clear)
    if clear then utils.reset() end
    local _color = term.getBackgroundColor()
    local rows = 1
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

local function writeInstanceName(instance)
    local _color = term.getBackgroundColor()
    term.setCursorPos(W - (#instance+1), 1)
    term.setBackgroundColor(backgroundColor)
    term.write(instance)
    term.setBackgroundColor(_color)
end

main_menu:add("Instances", function()
    actualMenu = instances_menu
    listeningModem = false
    background(true)
end, 1, 1, 11, 1, backgroundColor, backgroundColor)

local function setInstanceToPocket(instance)
    pocket = remote.new(instance.name, instance.channel)
end

-- Runtimes (in plural ?)

actualMenu = main_menu
actualInstance = loadInstances()[1]

local function handleInstances()
    listInstances = loadInstances()
    local x, y = 1, 3
    local n = 0

    for k,v in pairs(instances_menu.buttonList) do
        instances_menu:remove(k)
    end

    for i =1, #listInstances do
        for k,v in pairs(listInstances[i]) do
            --utils.debug(k,v)
            --sleep(1)
            if k == "name" then
                instances_menu:add(v, function()
                    actualInstance = listInstances[i]
                    actualMenu = main_menu
                    setInstanceToPocket(listInstances[i])
                end, x, y-1, W, y+1, colors.blue, backgroundColor)
                y = y+3
            end
        end
    end

    instances_menu:add("<", function()
        actualMenu = main_menu
        listeningModem = true
        background(true)
    end, 1, H, 5, H, backgroundColor, backgroundColor)
end

local function runAlways()
    local _color = term.getBackgroundColor()

    background(true)

    if actualMenu == main_menu then
        for k,v in pairs(pocket.lastMessages)do
            print(v)
        end

        term.setCursorPos(1, H)
        term.write("> " .. pocket.typed)

        background()
        actualMenu:draw(false)
        writeInstanceName(actualInstance.name)

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

