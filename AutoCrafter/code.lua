local args = {...}

label = args[1]

me = peripheral.find("meBridge") --MeBridge
if not me then
    me = peripheral.find("rsBridge")
end
mon = peripheral.find("monitor") --Monitor

if not me or not mon then
    error("[X]  Peripheral: Monitor or Bridge(ME or RS) missing!  [X]")
end

--List of the items which should be checked
--Display Name - Technical Name - Minimum Amount

local function unserialize(name)
    if fs.exists(name) then
        local f = fs.open(name, 'r')
        data = textutils.unserialize(f.readAll())
        f.close()
    end
    return data
end

meItems = unserialize(args[2])
--{
--    [1] = {"Oak Planks", "minecraft:oak_planks", "3000"},
--}

function checkMe(checkName, name, low)
    --melist = me.listCraftableItems()
    --for a = 1, #melist do
        --Only craft the items we have in our table
        if me.isItemCraftable({name = checkName}) then
            local item = me.getItem({name = checkName})
            size = tostring(item.amount)
            ItemName = item.name
            row = row + 1
            CenterT(name, row, colors.black, colors.lightGray, "left", false)
            --Number of items in the system lower than the minimum amount?
            if tonumber(size) < tonumber(low) then
                --Craft us some delicious items
                CenterT(size .. "/" .. low, row, colors.black, colors.red, "right", true)
                --If the items is already being crafted - don't start a new crafting job
                if not me.isItemCrafting({name = checkName}) then
                    --Prepare the table for "craftItem"
                    craftedItem = {name = checkName, count = low - size}
                    me.craftItem(craftedItem)
                    print("Craftando [" .. checkName .. "] " .. craftedItem.count .. " times")
                end
            else
                --Everything is fine. Print the amount in green
                CenterT(size .. "/" .. low, row, colors.black, colors.green, "right", true)
            end
            --break
        end
    --end
end

function checkTable()
    row = 2
    --Loop through our me items and check if they need to be crafted
    for i = 1, #meItems do
        checkName = meItems[i][2]
        name = meItems[i][1]
        low = meItems[i][3]
        checkMe(checkName, name, low)
    end
end

function prepareMonitor()
    mon.clear()
    CenterT(label, 1, colors.black, colors.white, "head", false)
end

--A util method to print text centered on the monitor
function CenterT(text, line, txtback, txtcolor, pos, clear)
    monX, monY = mon.getSize()
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX - length)
    x = math.floor(dif / 2)

    if pos == "head" then
        mon.setCursorPos(x + 1, line)
        mon.write(text)
    elseif pos == "left" then
        if clear then
            clearBox(2, 2 + length, line, line)
        end
        mon.setCursorPos(2, line)
        mon.write(text)
    elseif pos == "right" then
        if clear then
            clearBox(monX - length - 8, monX, line, line)
        end
        mon.setCursorPos(monX - length, line)
        mon.write(text)
    end
end

--Clear a specific area, prevents flickering
function clearBox(xMin, xMax, yMin, yMax)
    mon.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax do
            mon.setCursorPos(xPos, yPos)
            mon.write(" ")
        end
    end
end

prepareMonitor()

while true do
    checkTable()
    --Update every 3 seconds
    sleep(15)
end