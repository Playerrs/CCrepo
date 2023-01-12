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

    for input in io.lines(path, 16 * 1024) do
        local decoded = decoder(input)
        while not speaker.playAudio(decoded) do

            os.pullEvent("speaker_audio_empty")
        end
    end
    io.close()
end

--- testes
if not fs.exists('songs/musioca.dfpwm') then
    downloadSongs("https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download", "musioca")
end

if not fs.exists('songs/musioca2.dfpwm') then
    downloadSongs("https://drive.google.com/u/0/uc?id=1LPQhHAwzd_Nz1_PEnSK0HY0cxhJMDu5p&export=download", "musioca2")
end

for _,v in ipairs(listOfSongs) do
    print(v)
end
--shell.run("speaker play https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download")
playSong("musioca2.dfpwm")

