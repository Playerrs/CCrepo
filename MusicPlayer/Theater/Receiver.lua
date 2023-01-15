local modem = peripheral.find("modem")
modem.open(25565)


local function waitStop()
    local e, p, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if (message == nil) and (message ~= "STOP") then
        waitStop()
    end
    return message
end

local function play()
    local e, p,channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if (message ~= nil) and (message ~= "Finished") then
        print(message)
        shell.run('speaker play '..message)
        modem.transmit(25565, 60, "Finished")
    end
end

local function runtime()
    while true do
        paralel.waitForAny(play, waitStop)
    end
end


runtime()