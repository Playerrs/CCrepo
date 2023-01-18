-- By Reavik, Player_rs and HarryKaray V3.0s

local cb = peripheral.find("chatBox")
if cb == nil then print("chatBox no found") end
local modem = peripheral.find("modem")
if modem == nil then print("modem not found") end

local nameBot = "Robsom"
local woner = "Reavik"
local remove = false

local function Split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function loadTabela()
    local f = fs.open(nameBot.."/PriceTable.lua", "r")
    local data = textutils.unserialize(f.readAll())
    f.close()
    return data
end

local function sendMessage(msg, player)
    cb.sendMessageToPlayer(msg, player, nameBot)
end

local function findItem(str, table)
    local out = {}
    for index, v in pairs(table) do
        if string.find(v.name:lower(), str) then
            v["index"] = index
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
    if not fs.exists(nameBot) then
        fs.makeDir(nameBot)
    end
    shell.run("wgethttps://raw.githubusercontent.com/Reaviik/EteriumRobsonStore/main/PriceTable.lua "..nameBot.."/PriceTable.lua")
end

-- Main
if not fs.exists(nameBot.."/PriceTable.lua") then _downloadList() end
local tabela = loadTabela()
print("Tudo certo e funcionando!\n["..nameBot.."]")

while true do
    --editei msg para message
    local e, player, message = os.pullEvent("chat")
    if modem ~= nil then
        modem.transmit(7777,98,{player, message})
    end
    local split_string = Split(message, " ")
    msg = (split_string[1]):lower()

    if msg == "rp" or msg == "remove"  or msg == "add" and modem  ~= nil then
        print("["..player.."]: "..msg)
    end
    if msg == "rp" then
        local item
        local stats, result
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
        else
            sendMessage("Digite rp espaço nome do item, Ex: rp iron", player)
        end

        if stats then
            for i, v in pairs(result) do
                sendMessage(("\n[%s]: %s \nAndar: %s"):format(v.name, v.preco, v.andar), player)
                sleep(1)
            end
        else
            sendMessage(("[%s] Eu ainda não vendo isso, ou você digitou errado\nDigite rpreco no chat local para saber mais."):format(item), player)
        end
    end
    if msg == "remove" and player == woner then
        local item
        --    bolean/table
        local stats, result
        --tabela resultante da pesquisa na lista
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
        else
            sendMessage("Digite remove NomeDoItem para remover um item.", player)
        end

        if stats and remove == false then
            for i, v in pairs(result) do
                sendMessage(("Index: %s\n[%s]: %s \nAndar: %s"):format(v.index, v.name, v.preco, v.andar), player)
                sleep(1)
                --add o resultado da busca a uma tabela
            end
            sendMessage("Digite o Index do item que deseja remover", player)
            remove = true
        elseif stats and remove == true then
            print("Removendo")

            table.remove(tabela, tonumber(split_string[2]))

            --ler o arquivo com reescrever
            local f = fs.open(nameBot.."/PriceTable.lua", "w")

            --reescreve a tabela
            f.write(textutils.serialise(tabela))
            f.close()
            remove = false
        else
            sendMessage("Não existe um item para ser removido.", player)
        end
    end
    if msg == "add" and player == woner then
        print("Add")
        if #split_string == 4 then
        --tabela
        --pegar a mensagem do player remover add
        --resulta em algo assim {name = "Minhoca", info = "2.000/inv", tier = 1},
        table.remove(split_string, 1)
        --split 3 valores "mane" "info" "tier" e separas as palavras
        local name = string.gsub(split_string[1], "(%u)", " %1"):gsub("^%*", "",1)
        --R preço unitario / pack
        local preco = tonumber(split_string[2])
        --R andar
        local andar = tonumber(split_string[3])
        --R stack
        local stack = preco * 64
        --adicionar a tabela
            if type(andar) == "number" and type(preco) == "number" then
                table.insert(tabela,{name = name, preco = preco, andar = andar})
                --gravar a nova tabela
                local f = fs.open(nameBot.."/PriceTable.lua", "w")
                f.write(textutils.serialise(tabela))
                --fexar a tabela
                f.close()
                sendMessage("O item "..(name:gsub("^%*", "",1)).." foi adicionado a tabela por "..preco.." no andar "..andar, player)
            else
                sendMessage("O andar precisa ser um numero!")
        end
        else
            sendMessage("Você deve digitar: \"add name, preço, andar\"", player)
        end
    end
end


--fs "r" abre para leitura
--fs "w" abre para escrever e remover os dados existentes
--fs "a" abre para escrever e mantem os daddos existentes
