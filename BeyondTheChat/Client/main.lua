---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by josue.
--- DateTime: 12/04/2023 20:46
---
local args = {...}

if not fs.exists("Client/Cache") then
    term.clear()
    term.setCursorPos(1,1)
    print("What's your name?")
    local t = fs.open("Client/Cache", "w")
    t.writeLine(read())
    t.writeLine(os.getComputerID())
    t.writeLine(math.random(1050, 65200))
    t.close()
end

--- Imports

os.loadAPI("API/touchpoint")
local modemAPI = require("../API/ModemAPI")

--- Classes

local Chat = require("../Classes/Chat")
local Message = require("../Classes/Message")

--- Load

local f = fs.open("Client/Cache", "r")
local userName = f.readLine()
local computerID = tonumber(f.readLine())
local modemPort = tonumber(f.readLine())


f.close()
local screen = touchpoint.new()
local modem = modemAPI.startModem(modemPort)





while true do
    term.clear()
    term.setCursorPos(1,1)
    local r = read()
    local chatTest = Chat:new({"Player"}, 1, {})
    local messageTest = Message:new(chatTest, r, userName)
    modem.transmit(20358, 21358, messageTest) --- TODO: Nao está enviando a msgem
    sleep(5)

end