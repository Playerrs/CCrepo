-- By Player_rs and Reavik
-- This code support Sol System and doesn't download the music

local version = "0.2"

-- Utils

local rootDir = ...
if rootDir == nil then
    rootDir = ""
end

---@param data string
---@param name string
local function serialize(data, name)
    if not fs.exists('data') then
        fs.makeDir('data')
    end
    local f = fs.open('data/'..name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end

-- Loaders
if not fs.exists(rootDir..'available.lua') then
    local f = fs.open(rootDir..'available.lua', 'w')
    f.write("name url")
    f.close()
end

serialize(version, ".versionTheater") -- Salva a versão do script em um arquivo

if not fs.exists(rootDir.."API/touchpoint") then
    print("Installing Touchpoint by Lyqyd")
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/MusicPlayer/API/touchpoint "..rootDir.."API/touchpoint")
    sleep(3)
    os.reboot()
end

os.loadAPI(rootDir.."API/touchpoint")  --Touchpoinz API by Lyqyd
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

-- peripherals
local speaker = peripheral.find("speaker") -- Speaker

local sideMonitor
local mon
for _, side in pairs({ 'back', 'top', 'left', 'right', 'bottom' }) do
    if peripheral.getType(side) == 'monitor' then
        mon = peripheral.wrap(side)
        sideMonitor = side
        break
    end
end

local modem = peripheral.find('modem')
modem.open(25565)

local W, H = mon.getSize()
mon.setTextScale(0.5)

local tpMonitor = touchpoint.new(sideMonitor)
local buttons = {}

-- Functions
-- Speaker

local function downloadSongs(url, name)
    shell.run(string.format('wget %s %s', url, rootDir.."songs/"..name..".dfpwm"))
end

local function _available()
    local f = fs.open(rootDir..'available.lua', 'r')
    local t = {}
    for l in f.readLine do
        local s = {}
        for space in l:gmatch("%S+")do
            table.insert(s, space)
        end
        local url
        if s[2]:sub(1, 1):match("1") then
            url = "https://drive.google.com/u/0/uc?id="..s[2].."&export=download"
        else
            url = s[2]
        end
        local c = {name = s[1], url = ""}
        c.url = url
        table.insert(t, c)
    end
    f.close()
    return t
end

local available = _available()

local function waitFinish()
    local e, p, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if message == nil then
        waitFinish()
    end
    return message
end

---@param songName string
local function playSong(songUrl)
    modem.transmit(25565, 70, songUrl)
    --shell.run("speaker play "..songUrl)
    --local e, p, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    --print(waitFinish())
    term.setTextColor(colors.red)
    print("Music ended!")
    term.setTextColor(colors.white)
end

-- Monitor

---@param handler table
---@param name string
---@param func function
---@overload x,y number
local function addButton(handler, name, func, xMin, yMin, xMax, yMax, inactiveColor, activeColor, inactiveText, activeText)
    handler:add(name, func, xMin, yMin, xMax, yMax, inactiveColor, activeColor, inactiveText, activeText)
end

---@param str string
---@param color number
local function writeMon(str, color, xTo, yTo)
    local x, y = mon.getCursorPos()
    mon.setCursorPos(xTo or 3, yTo or 2)
    mon.setBackgroundColor(colors.black)
    mon.clearLine()
    local c = mon.getTextColor()
    mon.setTextColor(color or c)
    mon.write(str)
    mon.setTextColor(c)
    mon.setCursorPos(x, y)
end

-- Main
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.orange)
local xMin, yMin = 3, 3
local xMax, yMax = 12, 2
for _,v in ipairs(available) do
    if v.name == "name" then
        writeMon("No songs in 'available.lua' file!", colors.red)
        sleep(100)
        os.reboot()
    else
        addButton(tpMonitor, v.name, function()
            tpMonitor:toggleButton(v.name)
            term.setTextColor(colors.green)
            print("Playing "..v.name)
            writeMon("Playing "..v.name, colors.green)
            writeMon("By: Player_rs, Reavik", colors.white, 1, H)
            term.setTextColor(colors.orange)
            playSong(v.url)
        end, xMin, yMin, xMax, yMax, colors.blue)
    end

    yMin = yMax +2
    yMax = yMin +2
end


addButton(tpMonitor, "STOP", function()
    modem.transmit(25565, 40, "STOP")
    print(shell.run("speaker stop"))
end, W/2, 4, (W/2)+12, 6, colors.red)



local function runtime()
    tpMonitor:draw()
    writeMon("Idle", colors.white)
    writeMon("By: Player_rs, Reavik", colors.white, 1, H)
    while true do
        local event, button = tpMonitor:handleEvents(os.pullEvent())
        if event == "button_click" then
            local function callEvent()
                tpMonitor.buttonList[button].func()
            end
            parallel.waitForAny(callEvent, waitFinish)
        end
        tpMonitor:draw()
        writeMon("Idle", colors.white)
        writeMon("By: Player_rs, Reavik", colors.white, 1, H)
    end
end


runtime()

--tpMonitor:run(function()
--    writeMon("Idle", colors.white)
--    writeMon("By: Player_rs, Reavik", colors.white, 1, H)
--end)