local ar = require("APIs/ARAPI")

print("Mana HUB iniciada")

local hub = {}

function hub.run(...)
    local arg = {}
    local var1 = arg[1]
    local var2 = arg[2]

    ar.clear()
    ar.horizontalLine(400, 500, 225, 0x00FFFF)
    ar.drawCenteredString(var1.." / "..var2, 450, 235, 0x00FFFF)
end

return hub