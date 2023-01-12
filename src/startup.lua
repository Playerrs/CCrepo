-- By Player_rs and Reavik

local function _listOfSongs()
    if not fs.exists("songs") then
        error([[The "songs" folder doesn't exists!]])
    end
    return fs.list("songs")
end

local function downloadSongs(url, name)
    shell.run(string.format('wget %s %s', url, "songs/"..name..".dfpwm"))
end

local function _list()
    local f = fs.open('list', 'r')
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
if not fs.exists('songs') then fs.makeDir('songs') end

local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local speaker = peripheral.find("speaker") -- Speakers

local listOfSongs = _listOfSongs()

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

--- testes
if not fs.exists('list') then error("The 'list' archive doesn't exists!") end
local downloaded = false
for _,v in pairs(_list()) do
    if not fs.exists("songs/"..v.name..".dfpwm") then
        downloadSongs(v.url, v.name)
        downloaded = true
    end
end
if downloaded then os.reboot() end
--- main
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
os.reboot()
