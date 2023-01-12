-- By Player_rs and Reavik


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



-- Loaders
if not fs.exists(rootDir..'songs') then fs.makeDir(rootDir..'songs') end

serialize(version, ".versionMusic") -- Salva a versão do script em um arquivo

--os.loadAPI('/API/Manager.lua')      -- API
--local api = Manager                 -- API
--local Menu = require('/API/Menus')
local dfpwm = require("cc.audio.dfpwm")
local encoder = dfpwm.make_encoder()
local decoder = dfpwm.make_decoder()

local speaker = peripheral.find("speaker") -- Speakers

local listOfSongs = _listOfSongs()

---@param songName string
local function playSong(songName)
    local path = rootDir.."songs/"..songName
    --local f = fs.open(rootDir..songName, 'rb')
    shell.run("speaker play "..path)--)
    --f.close()


    --local out = fs.open(path, "wb")
    --for input in io.lines(path, 16 * 1024) do
    --    local decoded = decoder(input)
    --    local output = {}
    --
    --    -- Read two samples at once and take the average.
    --    for i = 1, #decoded, 2 do
    --        local value_1, value_2 = decoded[i], decoded[i + 1]
    --        output[(i + 1) / 2] = (value_1 + value_2) / 2
    --    end
    --
    --    out.write(encoder(output))
    --
    --    sleep(0) -- This program takes a while to run, so we need to make sure we yield.
    --end
    --out.close()

    --for chunk in io.lines(path, 16 * 1024) do
    --    local buffer = decoder(chunk)
    --    print(buffer)
    --    print("--------")
    --    print(chunk)
    --
    --    while not speaker.playAudio(buffer) do
    --        os.pullEvent("speaker_audio_empty")
    --    end
    --end
end

--- testes
if not fs.exists('songs/musioca.dfpwm') then
    downloadSongs("https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download", "musioca")
end

for _,v in ipairs(listOfSongs) do
    print(v)
end
--shell.run("speaker play https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download")
shell.run("speaker play /songs/musioca.dfpwm")
--playSong(listOfSongs[1])
