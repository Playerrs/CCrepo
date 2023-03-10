-- By Player_rs and Reavik

-- [PROGRAM] play <song>
-- [PROGRAM] download <URL> <NAME>
-- [PROGRAM] list

local prefix = ""


-- Utils

local function _listOfSongs()
    if not fs.exists(prefix.."songs") then
        error([[The "songs" folder doesn't exists!]])
    end
    return fs.list(prefix.."songs")
end

---@param url string
---@param name string
local function downloadSongs(url, name)
    local path
    if string.find(name, ".dfpwm") then
        path = prefix.."songs/"..name
    else
        path = prefix.."songs/"..name..".dfpwm"
    end
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
if not fs.exists(prefix..'songs') then fs.makeDir(prefix..'songs') end
--if not fs.exists('available.lua') then error("The 'available.lua' archive doesn't exists!") end

local dfpwm = require("cc.audio.dfpwm")
local encoder = dfpwm.make_encoder()
local decoder = dfpwm.make_decoder()

local speaker = peripheral.find("speaker") -- Speakers
if speaker == nil then error("Without Speaker!") end

local listOfSongs = _listOfSongs()
--local available = _list()

---@param songName string
local function playSong(songName)
    local path = prefix.."songs/"..songName..".dfpwm"
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

local args = {...}

if args[1] == "list" then
    print("Songs = {")
    for _,v in ipairs(listOfSongs) do
        print("    "..v)
    end
    print("}\n")
elseif args[1] == "play" then
    playSong(args[2])
elseif args[1] == "download" then
    downloadSongs(args[2], args[3])
else
    if args[1] then
        local c = term.getTextColor()
        term.setTextColor(colors.red)
        print("["..args[1].."] is not a command!")
        term.setTextColor(c)
    else
        local c = term.getTextColor()
        term.setTextColor(colors.green)
        print("Uses: ")
        print([[[PROGRAM] play <song>
[PROGRAM] download <URL> <NAME>
[PROGRAM] list]])
        term.setTextColor(c)
    end
end
