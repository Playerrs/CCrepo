-- By Player_rs and Reavik




-- Utils

local rootDir = ...
if rootDir == nil then
    rootDir = ""
end

local function serialize(data, name)
    if not fs.exists(rootDir..'data') then
        fs.makeDir(rootDir..'data')
    end
    local f = fs.open(rootDir..'data/'..name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end

local function unserialize(name)
    local data
    if fs.exists(name) then
        local f = fs.open(name, 'r')
        data = textutils.unserialize(f.readAll())
        f.close()
    end
    return data
end


-- Loaders
local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
