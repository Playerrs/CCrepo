-- By Reavik and Player_rs V1.6

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

local function _downloadList()
    if not fs.exists("EteriumSky") then
        fs.makeDir("EteriumSky")
    end
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/EteriumLoja/EteriumTable.lua EteriumSky/priceTable.lua")
end

-- Main
if not fs.exists("EteriumSky/priceTable.lua") then _downloadList() end
local tabela = loadTabela()
print("Tudo certo e funcionando!\n["..nameBot.."]")

while true do
    local e, player, msg = os.pullEvent("chat")
    local split_string = Split(msg, " ")
    msg = (split_string[1]):lower()

    if msg == "preço" or msg == "preco" or msg == "price" then
        local item
        local stats, result
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
        else
            sendMessage("Para mais informações digit \"sky\" ou \"help\" no chat", player)
        end

        if stats then
            sendMessage(("[Tier %s] [%s]:\r%s"):format(result.tier, result.name, result.info),player)
        else
            sendMessage(("[%s] não foi encontrado na tabela\nTente pesquisar por outro nome\nOu calcule o proço baseado nos item usado para o craft\nUse \"Sky help\" para mais informações"):format(item), player)
        end
    end
    if msg == "sky" or msg == "help" then
        sendMessage("-----------------[Eterium Sky]-----------------\n[price nomeDoItem] = mostra o preço do item na tabela do servidor\r[calc numero [+-/*] numero] = funciona como uma calculadora\r[sky help] = mostra esse menu de ajuda")
    end
    if msg == "calc" or msg == "c" then

        if split_string[3] == "+" then
            sendMessage(split_string[2].."+"..split_string[4].." = "..tonumber(split_string[2]) + tonumber(split_string[4]), player)
        end
        if split_string[3] == "-" then
            sendMessage(split_string[2].."-"..split_string[4].." = "..tonumber(split_string[2]) - tonumber(split_string[4]), player)
        end
        if split_string[3] == "/" or split_string[3] == "%" then
            sendMessage(split_string[2].."/"..split_string[4].." = "..tonumber(split_string[2]) / tonumber(split_string[4]), player)
        end
        if split_string[3] == "*" or split_string[3] == "x" then
            sendMessage(split_string[2].."*"..split_string[4].." = "..tonumber(split_string[2]) * tonumber(split_string[4]), player)
        end
    end
end
