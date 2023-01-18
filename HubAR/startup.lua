-- By Player_rs
-- License MIT
-- V 1.1

local modemPort
-->Eg: = 216 (random number... See more in https://tweaked.cc/peripheral/modem.html)

local delay
-->Eg: = 3 (in seconds)

local cbName = ""
-->Eg: = "Robot"

local whiteList = {
-->Eg:  "Player_rs",
}

-- Dirs
local __APIDir = "APIs/"
local __HUDsDir = "HUDs/"

-- Peripherals
local cb = peripheral.find("chatBox")
local __UseCB = true

term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.yellow)
if not cb then __UseCB = false textutils.slowPrint("[ Chat Box Not Found ]\n") end
term.setTextColor(colors.white)

-- Checks
if not fs.exists(__HUDsDir) then fs.makeDir(__HUDsDir) end
if not fs.exists(__APIDir) then fs.makeDir(__APIDir) end
if not modemPort or not delay or not whiteList[1] then
    error("View the file to change some settings!")
end

if not fs.exists(__APIDir.."ARAPI") then
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/ARAPI "..__APIDir.."ARAPI")
end
if not fs.exists(__APIDir.."ModemAPI") then
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/ModemAPI "..__APIDir.."ModemAPI")
end

-- APIs
local mAPI = require(__APIDir.."ModemAPI")
local ar = require(__APIDir.."ARAPI")

-- Start
local modem = mAPI.startModem(modemPort)
local hud

-- HUDs

local function openDataFileHUD()
    if fs.exists("HUD") then
        local f = fs.open("HUD", "r")
        local _ = f.readAll()
        f.close()
        return _
    end
    return nil
end

local function saveDataFileHUD(Hud)
    local f = fs.open("HUD", "w")
    f.write(Hud)
    f.close()
    return true
end

local function _loadAllHUDs()
    return fs.list(__HUDsDir)
end

local function requireHUD(HUDName, player)
    if not HUDName then return nil end
    HUDName = tostring(HUDName)
    for _,v in ipairs(_loadAllHUDs())do
        if string.find(v:lower(), HUDName:lower()) then
            local file
            if v:sub(#v - 3) == ".lua" then
                file = v:sub(1, #v - 4)
            else
                file = v
            end
            local str = "Changing HUD to ["..file.."]"
            if player then
                cb.sendMessageToPlayer(str, player, cbName)
            end
            print(str)
            saveDataFileHUD(file)
            return require(__HUDsDir..file)
        end
    end
    local str = "HUD ["..HUDName.."] not found!"
    if player then
        cb.sendMessageToPlayer(str, player, cbName)
    end
    print(str)
    return require(__HUDsDir..openDataFileHUD())
end

local function choseHUD()
    local oldColor = term.getTextColor()
    term.setTextColor(colors.green)
    print("\n{ ")
    for _, v in ipairs(_loadAllHUDs())do
        print("    "..v)
    end
    print("\n}\n")
    term.setTextColor(colors.yellow)
    term.write("> ")
    term.setTextColor(oldColor)
    return read()
end

-- ChatBox

local function waitForChat()
    local _, player, msg = os.pullEvent("chat")
    if msg then
        for i = 1, #whiteList do
            if player == whiteList[i]then
                local args = {}
                for arguments in msg:gmatch("%S+") do
                    table.insert(args, arguments)
                end
                local command = args[1]:lower()

                if command == "change" then
                    table.remove(args, 1)
                    table.insert(args, 1, player)
                    return args
                elseif command == "off" then
                    cb.sendMessageToPlayer("Turning off!", player, cbName)
                    ar.clear()
                    os.shutdown()
                end
            end
        end
    end
    return waitForChat()
end

-- Runtime
local function runtime()
    print("\nHUD AR Started")
    hud = requireHUD(openDataFileHUD())

    if __UseCB then
        while true do
            if hud then
                local function A()
                    local t = waitForChat()
                    hud = requireHUD(t[2], t[1])
                end
                local function B()
                    local c, msg = mAPI.receive()
                    hud.run(msg)
                    sleep(delay)
                end
                parallel.waitForAny(A, B)
            else
                hud = requireHUD(choseHUD())
            end
        end
    else
        while true do
            if hud then
                local c, msg = mAPI.receive()
                hud.run(msg)
                sleep(delay)
            else
                hud = requireHUD(choseHUD())
            end
        end
    end
end

runtime()
