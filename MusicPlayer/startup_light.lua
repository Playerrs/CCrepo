-- By Player_rs and Reavik | v: 1.2
-- This code doesn't support Sol System and doesn't download the music

local function _list()
    local f = fs.open('available.lua', 'r')
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

-- Loaders
if not fs.exists('available.lua') then error("The 'available.lua' archive doesn't exists!") end

local dfpwm = require("cc.audio.dfpwm")

local speaker = peripheral.find("speaker") -- Speakers
local decoder = dfpwm.make_decoder()

local available = _list()

---@param songName string
local function playSong(songUrl)
    shell.run("speaker play "..songUrl)
end

--- main
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.orange)
print("Songs = {")
for _,v in ipairs(available) do
    print("    "..v.name)
end
print("}")
term.write("\n\n> ")
local input = tostring(read())
for _, v in ipairs(available)do
    if v.name == input then
        print("\nPlaying ".. v.name.."\n")
        playSong(v.url)
        break
    end
end

print("\nRebooting...")
sleep(2)
os.reboot()
