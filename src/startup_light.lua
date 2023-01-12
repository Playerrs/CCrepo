-- By Player_rs and Reavik

local function _list()
    local f = fs.open('available.lua', 'r')
    local t = {}
    for l in f.readLine do
        local s = {}
        for space in l:gmatch("%S+")do
            table.insert(s, space)
        end
        local c = {name = s[1], url = s[2]}
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
        playSong(v.url)
        break
    end
end

print("\nRebooting...")
sleep(2)
os.reboot()
