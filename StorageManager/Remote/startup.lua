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

-- load requirements
os.loadAPI('/deps/touchpoint')
local tp = touchpoint
local remote = require('/deps/RemoteAPI')
os.loadAPI('/deps/Utils')
local utils = Utils

-- variables
local backgroundColor = colors.green
local W, H = term.getSize()

-- create a RemoteAPI object
local pocket = remote.new("Sla", 1551)

-- menus
local main_menu = tp.new()

-- screen
local function background()
    utils.reset()

    local rows
    for iH = 1, rows do
        for iW = 1, W do
            term.setCursorPos(iW, iH)
            term.write(" ")
        end
    end
end

main_menu:add("Butão", function()
    error("So de zueira")
end, 1, 1, 7, 1, colors.white, backgroundColor)

-- RemoteAPI Runtime
pocket:run(pocket, function()
    background()
    main_menu:draw()
    for k,v in pairs(pocket.lastMessages)do
        print(v)
    end
    print("-----")
    print(pocket.typed)
end)