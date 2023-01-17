-- By Player_rs
-- License MIT
-- V 0.0

-- Dirs
local __APIDir = "APIs/"
local __HUDsDir = "HUDs/"

-- Peripherals
--local cb = peripheral.find("chatBox")

-- Checks
if not fs.exists(__HUDsDir) then fs.makeDir(__HUDsDir) end
if not fs.exists(__APIDir) then fs.makeDir(__APIDir) end

if not fs.exists(__APIDir.."ARAPI") then shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/ARAPI "..__APIDir.."ARAPI") os.reboot() end
if not fs.exists(__APIDir.."ModemAPI") then shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/ModemAPI "..__APIDir.."ModemAPI") os.reboot() end

-- APIs
local mAPI = require(__APIDir.."ModemAPI")
local ar = require(__APIDir.."ARAPI")


-- Start
local modem = mAPI.startModem(165)


-- Load HUDs

local function _loadAllHUDs()
    return fs.list(__HUDsDir)
end

local function getHUB(HUBName)
    for _,v in ipairs(_loadAllHUDs())do
        if string.find(v, HUBName) then
            return require(__HUDsDir..v)
        end
    end
    print("HUB not found")
end



-- Runtime
local function runtime()
    print("HUB AR Started")
    local hub = getHUB(read())

    while true do
        local c, msg = modem:receive()
        hub.run(msg)
        sleep(2)
    end
end

runtime()
