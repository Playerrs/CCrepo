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
    for k, v in pairs(table) do
        if str == v then
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
    local message = "Teste"


    if msg == "preço" or msg == "preco" then

    end

end