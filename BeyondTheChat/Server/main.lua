---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by josue.
--- DateTime: 12/04/2023 23:14
---

--- Imports
local args = {...}
os.loadAPI("Dependencies/touchpoint")
local mon = peripheral.find("monitor")
local modemAPI = require("../Dependencies/ModemAPI")
local chatHandler = require("../Dependencies/chatHandler")

--- Classes

local Chat = require("../Classes/Chat")
local Message = require("../Classes/Message")
local Device = require("../Classes/Device")


--- Load

local tpMon = touchpoint.new("up")
local bridgeModem = modemAPI.startModem(tonumber(args[1]))
local _serverSettingPort = tonumber(args[1])+5
local serverModem = modemAPI.startModem(_serverSettingPort)


--- Functions

local function create_chat(members, replyChannel)
    math.randomseed(os.clock()*10000000)
    local id = math.random(11112, 99998)
    local chat = Chat:new(members, id, {Message:new("Novo Chat Criado, o id deste Chat é: "..id, Device:new("Admin", -1, 0))})
    chatHandler.saveChat(chat)
    serverModem.transmit(replyChannel, _serverSettingPort, {"done", chat})
    return chat
end

local function loadChat(chatObj)
    local ch = Chat:new({}, chatObj.id, {})
    for _,v in ipairs(chatObj.members) do
        ch:addMember(Device:new(v.userName, v.computerID, v.modemPort))
    end

    for _,t in ipairs(chatObj.messages) do
        local user = Device:new(t.device.userName, t.device.computerID, t.device.modemPort)
        ch:addMessage(Message:new(t.content, user))
    end

    chatHandler.saveChat(ch)
    return ch
end

while true do
    print("------")
    local channel, receivedMessage, rChannel = modemAPI.receive()
    if channel == tonumber(args[1]) then
        local ch = chatHandler.decodeChat(receivedMessage[2].id)
        if ch then
            ch = loadChat(ch)
        end
        ch:addMessage(Message:new(receivedMessage[2].content, Device:new(receivedMessage[3].userName, receivedMessage[3].computerID, receivedMessage[3].modemPort)))
        loadChat(ch)

    elseif channel == _serverSettingPort then
        if receivedMessage[1] == "create_chat" then
            local chat = create_chat(receivedMessage[2].members, rChannel)

        elseif receivedMessage[1] == "enter_chat" then
            local _tryLoad = chatHandler.decodeChat(receivedMessage[2].id)

            if not _tryLoad then
                serverModem.transmit(rChannel, channel, {"error", "Nenhum chat com este id encontrado!"})
            else
                local chat = loadChat(_tryLoad)
                chat:addMember(Device:new(receivedMessage[2].device.userName, receivedMessage[2].device.computerID, receivedMessage[2].device.modemPort))
                chatHandler.saveChat(chat)
                serverModem.transmit(rChannel, channel, {"done", chat})

            end
        end
    end
end
