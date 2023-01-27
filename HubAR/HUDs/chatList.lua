local ar = require("APIs/ARAPI")

local color = 0x00FFFF

local hub = {chat = {}}
ar.setRelativeMode(true, 1600, 900)

function hub.run(...)
    local args = ...
    local content = args[2]..": "..args[3]

    --print(content)
    if #hub.chat < 10 then
        table.insert(hub.chat, 1, content)
    else
        table.remove(hub.chat, #hub.chat)
        table.insert(hub.chat, 1, content)
    end

    local y = 400
    local row = 0

    ar.clear()
    for k, v in ipairs(hub.chat) do
        ar.drawRightBoundString(v, 775, y-row, color)
        row = 15 * k
    end
end

return hub