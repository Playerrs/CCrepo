local reader = peripheral.find("blockReader")
local mon = peripheral.find("monitor")
mon.setTextScale(0.5)
local W, H = mon.getSize()

local function drawBar(x,y,length,color)
    local oldBgColor = mon.getBackgroundColor()
    for i = x, (length + x) do
        mon.setCursorPos(i,y)
        mon.setBackgroundColor(color)
        mon.write(" ")
    end
    mon.setBackgroundColor(oldBgColor)
end

local function regra3(cur, total, wid)
    local porcent = cur/total
    if wid then
        return porcent*wid
    else
        return porcent
    end
end

local function printar(y ,str)
    mon.setCursorPos(math.ceil(W/2 - str:len()/2), y)
    mon.write(str)
end

print("Iniciando")
mon.setBackgroundColor(colors.black)
while true do
    mon.setCursorPos(1, 1)
    mon.clear()

    local data = reader.getBlockData()
    local var1 = data.mana
    local var2 = 10000000 -- Can be used data.manaCap in a Mana Pool or this number in a Mana Battery

    drawBar(2, 2, W-3, colors.white)
    drawBar(2, 2, regra3(var1, var2, W-3), colors.green)

    local percent = regra3(var1, var2)*100
    printar(4, var1.." / "..var2)
    printar(5, string.format("%0.0f", percent).."%")
    printar(7, "Pools: "..string.format("%0.1f", var1/var2))

    sleep(0.6)
end