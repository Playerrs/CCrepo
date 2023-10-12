-- Created by Player_rs
-- V: 0.1


if not fs.exists('deps/touchpoint') then
    shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/touchpoint /deps/touchpoint')
end

if not fs.exists('deps/RemoteAPI') then
    shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/RemoteAPI /deps/RemoteAPI')
end

local tp = require('/deps/touchpoint')

local api = require("RemoteAPI")

local pocket = api.new("Sla", 1551)

pocket:run(pocket, function()
    for k,v in pairs(pocket.lastMessages)do
        print(k,v)
    end
    print("-----")
    print(pocket.typed)
end)