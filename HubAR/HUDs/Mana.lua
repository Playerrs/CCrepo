local ar = require("APIs/ARAPI")

local color = 0x00FFFF

print("\n\nMana HUD iniciada")

local hub = {}
ar.setRelativeMode(true, 1600, 900)

function hub.run(...)
    local arg = ...
    local var1 = arg[1]
    local var2 = arg[2]

    local str = var1.." / "..var2

    ar.clear()
    ar.drawItemIcon("botanicalmachinery:mana_battery", 705, 425)
    ar.horizontalLine(700, 780, 420, color)
    ar.drawCenteredString(str, 775, 425, color)
end

return hub