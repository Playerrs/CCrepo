-- By Reavik and Player_rs

local cb = peripheral.find("chatBox")
if cb == nil then print("chatBox no found") end

local nameBot = "Eterium Sky"

local function Split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function loadTabela()
    local f = fs.open("EteriumSky/priceTable.lua", "r")
    local data = textutils.unserialize(f.readAll())
    f.close()
    return data
end

local function sendMessage(msg, player)
    cb.sendMessageToPlayer(msg, player, nameBot)
end

local function findItem(str, table)
    local bool, out = false

    for _, v in pairs(table) do
        if string.find(v.name:lower(), str) then
            bool = true
            out = v
        end
    end

    return bool, out
end

-- Main

local tabela = loadTabela()

while true do
    local e, player, msg = os.pullEvent("chat")
    local split_string = Split(msg, " ")
    msg = (split_string[1]):lower()

    if msg == "preço" or msg == "preco" or msg == "price" then
        local item = split_string[2]:lower()

        local stats, result = findItem(item, tabela)

        if stats then
            sendMessage(("[Tier %s] [%s]: %s"):format(result.tier, result.name, result.info))
        else
            sendMessage(("O item que você procurou não foi encontrado [%s]"):format(item), player)
        end
    end
end