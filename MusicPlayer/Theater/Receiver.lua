local modem = peripheral.find("modem")
modem.open(25565)

while true do
    local e, p,channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if (message ~= nil) and (message ~= "Finished") then
        print(message)
        shell.run('speaker play '..message)
        modem.transmit(25565, 60, "Finished")
    end
end