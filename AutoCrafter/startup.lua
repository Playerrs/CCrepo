-- By Player_rs
local V = 1.5

local name_inventory_crafters = "metalbarrels:diamond_tile" -- You Can change
local name_inventory_input = "metalbarrels:gold_tile_0"     -- You Can change
local chest_postion_related_bridge = "south"                -- You Can change


-- WRAP THINGS
local completion = require "cc.completion"
local crafters = {}
local inventory_input
local __i

local __chestPatternRecipes = peripheral.wrap("top")
local __me = peripheral.find("meBridge")
local __rs =  peripheral.find("rsBridge")
local bridge = __me or __rs

-- VERIFICATIONS
if not fs.exists("recipes")then fs.makeDir("recipes") end
if not bridge then error("[X] You need to use a rsBridge or meBridge to connect with your system!") end


local __list_recipes = fs.list("recipes")
local complete = {
    commands = {"new", "craft", "list"}
}

-- FUNCTIONS

local function clearBox(xMin, xMax, yMin, yMax)
    term.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax do
            term.setCursorPos(xPos, yPos)
            term.write(" ")
        end
    end
end

local function prepareTerminal()
    local terminal = term.current()
    term.redirect(term.native())
    local W, H = term.getSize()
    term.setTextColor(colors.green)
    term.clear()
    local oldBGColor = term.getBackgroundColor()
    term.setBackgroundColor(colors.gray)
    clearBox(1, W, 1, H)
    term.getBackgroundColor(oldBGColor)
    term.setCursorPos(1, 1)

    local str = "Player_rs's Auto Crafter V"..V
    print(string.rep("#", W))
    term.setCursorPos(math.ceil(W/2 - str:len()/2), 2)
    print(str)
    print(string.rep("#", W))

    return terminal
end

local function printColor(str, color)
    local oldColor = term.getTextColor()
    term.setTextColor(color)
    print(str)
    term.setTextColor(oldColor)
end

local function __loadPeripherals()
    crafters = {}
    __i = 1
    for _, v in ipairs(peripheral.getNames()) do
        if peripheral.getType(v) == name_inventory_crafters then
            crafters["crafter"..__i] = peripheral.wrap(v)
            __i = __i + 1
        end
        if peripheral.getType(v) == name_inventory_input then
            inventory_input = peripheral.wrap(v)
        end
    end
end

local function serialize(data, name)
    if not fs.exists("recipes")then
        fs.makeDir("recipes")
    end
    local f = fs.open("recipes/"..name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end

local function unserialize(name)
    if fs.exists("recipes/"..name) then
        local f = fs.open("recipes/"..name, 'r')
        data = textutils.unserialize(f.readAll())
        f.close()
    end
    return data
end

local function _loadIngredientsAndResult()
    local t, ing, result = __chestPatternRecipes.list(), {}, {}

    for i = 1, #t do
        if i ~= #t then
            table.insert(ing, t[i])
        else
            table.insert(result, t[i])
        end
        sleep(0.2)
    end
    return ing, result
end

local function _saveRecipe(name, ingredients, result, crafter)
    serialize({ingredients = ingredients, result = result, crafter = crafter}, name)
end

local function findRecipe(str)
    local list = fs.list("recipes")
    for _,v in pairs(list)do
        if string.match(v:lower(), str:lower()) then
            return unserialize(v)
        end
    end
    return false
end

local function isItemCrafting(item)
    if __me then
        return bridge.isItemCrafting({name = item.name, nbt = item.nbt or nil})
    else
        return bridge.isItemCrafting(item.name)
    end
end

local function verifyItem(pack, times)
    for _, v in pairs(pack.ingredients)do
        local item = bridge.getItem({name = v.name, nbt = v.nbt or nil})
        if item.amount < (v.count * times) then
            return false, {name = v.name, amount = (v.count * times) - item.amount}
        end
    end
    return true
end

local function _craft(pack, times)
    for _ = 1, times do
        for _, v in pairs(pack.ingredients)do
            bridge.exportItem({name = v.name, count = v.count, nbt = v.nbt or nil}, chest_postion_related_bridge)
            crafters[pack.crafter].pullItems(name_inventory_input, 1)
        end
        sleep(2)
    end
end

local function craftBridge(item)
    local stored = bridge.getItem({name = item.name, nbt = item.nbt or nil})
    if not isItemCrafting({name = item.name, nbt = item.nbt or nil}) then
        local canCraft = bridge.craftItem({name = item.name, count = item.amount, nbt = item.nbt or nil})
        if canCraft then
            local crafted = false
            while not crafted do
                local crafted_item = bridge.getItem({name = item.name, nbt = item.nbt or nil})
                if crafted_item.amount >= (stored.amount + item.amount) then
                    crafted = true
                end
                sleep(4)
            end
        else
            printColor(string.format("[X] Not Able to Craft [%s] [%s]", item.name, item.amount), colors.red)
            sleep(5)
            os.reboot()
        end
    end
end

local function tryCraft(recipe, times)
    local bool, miss = verifyItem(recipe, times)
    if not bool then
        printColor(string.format("[X] Missing item [%s] [%s]", miss.name, miss.amount ), colors.red)
        printColor(string.format("To Craft [%s] [%s]\n", recipe.result[1].name, times), colors.red)
        if bridge.isItemCraftable(miss) then
            printColor(string.format("[CB] Crafting [%s] [%s]\n", miss.name, miss.amount), colors.yellow)
            craftBridge(miss)
        end
    end
    bool = verifyItem(recipe, times)
    if not bool then
        tryCraft(recipe, times)
        return
    end
    print("[C] Crafting...\n")
    _craft(recipe, times)
end

local function readAndComplete(comp, space)
    print(" ")
    term.write("> ")
    local oldColor = term.getTextColor()
    term.setTextColor(colors.white)
    local _ = read(nil, nil, function(text) return completion.choice(text, comp, space) end)
    term.setTextColor(oldColor)
    print(" ")
    return _
end

-- RUNTIME
__loadPeripherals()
while true do
    local terminal = prepareTerminal()
    local input = readAndComplete(complete.commands)

    local args = {}
    for i in input:gmatch("%S+")do
        table.insert(args, i)
    end
    input = args[1]

    if input == "new" then
        __loadPeripherals()
        print("[?] Name for the recipe: (Create or Override)\n   [?] ..")
        local fileName = readAndComplete(__list_recipes)
        print("[...] Processing...\n")
        local ing, result = _loadIngredientsAndResult()
        print("[?] Which Crafter? [ "..name_inventory_crafters.." ]\n")
        print("{")
        local crf = {}
        for k,_ in pairs(crafters) do
            print("    "..k)
            table.insert(crf, k)
        end
        print("}")
        local crafter = readAndComplete(crf)
        _saveRecipe(fileName, ing, result, crafter)
        print(" ")
        print(string.format("[V] RECIPE SAVED\n\nName = [%s]\nResult = [%s] [%d]\nCrafter = [%s]\n", fileName,
                result[1].name, result[1].count, crafter))
        __list_recipes = fs.list("recipes")
        sleep(2)

    elseif input == "craft" then
        print("[?] Recipe:\n   [?] ..")
        local recipeName = readAndComplete(__list_recipes)
        print("[?] Amount:")
        local amount = readAndComplete({})
        print("[...] Processing...\n")
        local recipe = findRecipe(recipeName)
        if not recipe then
            printColor("[X] ERROR Não consegui encontrar nenhuma recipe!\n", colors.red)
        else
            tryCraft(recipe, amount)
            print(string.format("[V] Done! [%s] [%s]\n", recipe.result[1].name, amount))
        end
        sleep(2)

    elseif input == "list" then
        for i = 1, #__list_recipes do
            local rec = unserialize(__list_recipes[i])
            print(string.format("* Name = [%s] #Ing = [%s]\n    Result = [%s]\n    Crafter = [%s]\n",
                    __list_recipes[i], #rec.ingredients, rec.result[1].name, rec.crafter))
        end
        print("\n")
        sleep(#__list_recipes)
    end

    term.redirect(terminal)
end