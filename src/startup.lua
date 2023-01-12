-- By Player_rs and Reavik
-- This code support Sol System and doesn't download the music

local version = "1.1"

-- Utils

local rootDir = ...
if rootDir == nil then
    rootDir = ""
end

---@param data string
---@param name string
local function serialize(data, name)
    if not fs.exists(rootDir..'data') then
        fs.makeDir(rootDir..'data')
    end
    local f = fs.open(rootDir..'data/'..name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end

-- Loaders
if not fs.exists(rootDir..'songs') then fs.makeDir(rootDir..'songs') end
if not fs.exists(rootDir..'available.lua') then
    local f = fs.open(rootDir..'available.lua', 'w')
    f.write("name url")
    f.close()
end

serialize(version, ".versionMusic") -- Salva a versão do script em um arquivo

if not fs.exists(rootDir.."API/touchpoint") then
    print("Installing Touchpoint by Lyqyd")
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CC-Music-Player/master/src/API/touchpoint "..rootDir.."API/touchpoint")
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

local W, H = mon.getSize()

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

---@param songName string
local function playSong(songUrl)
    shell.run("speaker play "..songUrl)
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
local function writeMon(str, color)
    local x, y = mon.getCursorPos()
    mon.setCursorPos(3, 2)
    mon.setBackgroundColor(colors.black)
    mon.clearLine()
    local c = mon.getTextColor()
    mon.setTextColor(color)
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

    addButton(tpMonitor, v.name, function()
        term.setTextColor(colors.green)
        print("Playing "..v.name)
        writeMon("Playing "..v.name, colors.green)
        term.setTextColor(colors.orange)
        playSong(v.url)
    end, xMin, yMin, xMax, yMax, colors.blue, nil)

    yMin = yMax +2
    yMax = yMin +2
end

tpMonitor:draw()

tpMonitor:run(function()
    writeMon("Idle", colors.white)
end)

sleep(10)
print("\nRebooting...")
sleep(2)
os.reboot()
