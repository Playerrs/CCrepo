-- By Player_rs and Reavik
-- Doesn't work

local version = "1.0"

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

---@param name string
local function unserialize(name)
    local data
    if fs.exists(name) then
        local f = fs.open(name, 'r')
        data = textutils.unserialize(f.readAll())
        f.close()
    end
    return data
end

local function _listOfSongs()
    if not fs.exists(rootDir.."songs") then
        error([[The "songs" folder doesn't exists!]])
    end
    --local folder = fs.list(rootDir.."songs")
    --for k, v in pairs(folder)do
    --    print(k,v)
    --end
    return fs.list(rootDir.."songs")
end

---@param url string
---@param name string
local function downloadSongs(url, name)
    local path = rootDir.."songs/"..name..".dfpwm"
    shell.run(string.format('wget %s %s', url, path))
end

local function _list()
    local f = fs.open('available.lua', 'r')
    local t = {}
    for l in f.readLine do
        local s = {}
        for space in l:gmatch("%S+")do
            table.insert(s, space)
        end
        local c = {name = s[1], url = "https://drive.google.com/u/0/uc?id="..s[2].."&export=download"}
        table.insert(t, c)
    end
    f.close()
    return t
end

-- Loaders
if not fs.exists(rootDir..'songs') then fs.makeDir(rootDir..'songs') end
if not fs.exists(rootDir..'available.lua') then error("The 'available.lua' archive doesn't exists!") end

serialize(version, ".versionMusicHeavy") -- Salva a versão do script em um arquivo

--os.loadAPI('/API/Manager.lua')      -- API
--local api = Manager                 -- API
--local Menu = require('/API/Menus')
local dfpwm = require("cc.audio.dfpwm")
local encoder = dfpwm.make_encoder()
local decoder = dfpwm.make_decoder()

local speaker = peripheral.find("speaker") -- Speakers

local listOfSongs = _listOfSongs()
local available = _list()

---@param songName string
local function playSong(songName)
    local path = "songs/"..songName
    if not fs.exists(path) then
        error("I don't have this song :V")
    end
    for input in io.lines(path, 16 * 1024) do
        local decoded = decoder(input)
        while not speaker.playAudio(decoded) do
            os.pullEvent("speaker_audio_empty")
        end
    end
    io.close()
end

--downloadSongs("https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download", "musioca")
--downloadSongs("https://drive.google.com/u/0/uc?id=1LPQhHAwzd_Nz1_PEnSK0HY0cxhJMDu5p&export=download", "musioca2")

local downloaded = false
for _,v in pairs(available) do
    if not fs.exists("songs/"..v.name..".dfpwm") then
        downloadSongs(v.url, v.name)
        downloaded = true
    end
end
if downloaded then os.reboot() end
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.orange)
print("Songs = {")
for _,v in ipairs(listOfSongs) do
    print("    "..v)
end
print("}")
term.write("\n\n> ")
playSong(read()..".dfpwm")
print("\nRebooting...")
sleep(2)
os.reboot()

----- main
--term.clear()
--term.setCursorPos(1,1)
--term.setTextColor(colors.orange)
--print("Songs = {")
--for _,v in ipairs(listOfSongs) do
--    print("    "..v)
--end
--print("}")
--term.write("\n\n> ")
--playSong(read()..".dfpwm")
--print("\nRebooting...")
--sleep(2)
--os.reboot()


-- To Download

--local downloaded = false
--for _,v in pairs(available) do
--    if not fs.exists("songs/"..v.name..".dfpwm") then
--        downloadSongs(v.url, v.name)
--        downloaded = true
--    end
--end
--if downloaded then os.reboot() end
----- main
--term.clear()
--term.setCursorPos(1,1)
--term.setTextColor(colors.orange)
--print("Songs = {")
--for _,v in ipairs(listOfSongs) do
--    print("    "..v)
--end
--print("}")
--term.write("\n\n> ")
--playSong(read()..".dfpwm")
--print("\nRebooting...")
--sleep(2)
--os.reboot()

