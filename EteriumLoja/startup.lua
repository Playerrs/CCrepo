-- By Reavik and Player_rs V2.0

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
    local out = {}
    for _, v in pairs(table) do
        if string.find(v.name:lower(), str) then
            out[#out+1] = v
        end
    end
    if #out == 0 then 
        return false, {}
    else
        return true, out
    end
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
    print("["..player.."]: "..msg)
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
            for i, v in pairs(result) do
                sendMessage(("[Tier %s] [%s]:\n %s"):format(v.tier, v.name, v.info), player)
                sleep(1)
            end
        else
            sendMessage(("[%s] não foi encontrado na tabela\nTente pesquisar por outro nome\nOu calcule o proço baseado nos item usado para o craft\nUse \"help\" para mais informações"):format(item), player)
        end
    end
    if msg == "sky" then
        sendMessage("------------------ [Eterium Sky]\nExiste um delay de 1s entre um comando e outro\nAss: Reavik, Player_rs", player)
    end
    if msg == "help" then
        sendMessage("----------------- [Eterium Sky]\nDigite no chat local os comandos a seguir sem usar /\nprice\ncalc\nsky\nhelp", player)
    end
    -- split_string[1] = calc
    -- split_string[2] = int
    -- split_string[3] = parametro
    -- split_string[4] = int
    if msg == "calc" or msg == "c" then
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
            local error = "[X] Você deve digitar apenas numeros e parametros matematicos"
        if split_string[3] == "+" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A soma de "..split_string[2].." mais "..split_string[4].." é ["..tonumber(split_string[2]) + tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "-" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A subitração de "..split_string[4].." de "..split_string[2].." é ["..tonumber(split_string[2]) - tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if tonumber(split_string[2]) and tonumber(split_string[4]) then
            if split_string[3] == "/" or split_string[3] == "%" then
                sendMessage("A divisão de "..split_string[2].." por "..split_string[4].." é ["..tonumber(split_string[2]) / tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "*" or split_string[3] == "x" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A divisão de "..split_string[2].." por "..split_string[4].." é ["..tonumber(split_string[2]) * tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "^" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A potência de "..split_string[2].." elevado "..split_string[4].." é ["..tonumber(split_string[2]) ^ tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[2] == "v" then
            if tonumber(split_string[3]) then
                sendMessage("A raiz quadrada de "..split_string[3].." é ["..math.sqrt(tonumber(split_string[3])).."]", player)
            else
                sendMessage(error,player)
            end
        end
        else
            sendMessage("Os parametros validos para a calculadora são:\n+ Soma\n- Subtração\n/ % Divisão\n* x Multilicação\n^ Potência\nv Raiz quadrada", player)
        end
        sleep(1)
    end
end
