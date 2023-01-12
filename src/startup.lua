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

---@
--local function


-- Loaders
serialize(version, ".versionMusic") -- Salva a versão do script em um arquivo

os.loadAPI('/SS/API/Manager.lua')   -- API
local api = Manager                 -- API
local Menu = require('/SS/API/Menus')
local dfpwm = require("cc.audio.dfpwm")

local speaker = peripheral.find("speaker") -- Speakers


