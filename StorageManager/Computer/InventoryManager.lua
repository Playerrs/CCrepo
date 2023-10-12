-- Created by Player_rs
-- License MIT
-- V: 2.7
-- Supports AE2 and Refined Storage
-- Supports ChatBox (Advanced Peripheral) and PocketAPI (URL)


local langs = {
    {name = "pt_BR", pb = "wWYY291c"},
    {name = "en_US", pb = "Z8kvRen1"}
}


if not fs.exists('language.lua') then
    local stringLangs = "\n-- "
    for _,v in pairs(langs) do
        stringLangs = stringLangs..v.name..", "
    end


    local config = fs.open('language.lua', 'w')
    config.write([=[--[[write, save, exit...]]

local language = "pt_BR" ]=]..stringLangs..'\n\n\nreturn language')
    config.close()

    shell.run("edit language.lua")
end

local codeLang = require('language')
local dirMessage

local function downloadLang()

    local language = {}
    for _,v in pairs(langs) do
        if v.name == codeLang then
            language = v
            break
        end
    end

    if language.name == nil then
        error([[THIS LANGUAGE IS NOT AVALIABLE FOR DOWNLOAD,
        if you want to add your language, just make the file add it in the languages folder
        and change the name in the language.lua]])
    end

    shell.run('pastebin get '..language.pb..' languages/'..language.name)
    shell.run('clear')
    dirMessage = 'languages/'..language.name
end

if not fs.exists('/languages/') then
    fs.makeDir('languages')

    downloadLang()
else
    if fs.exists('/languages/'..codeLang) or fs.exists('/languages/'..codeLang..'.lua') then
        dirMessage = 'languages/'..codeLang
    else
        downloadLang()
    end
end

local message = require(dirMessage)

if not fs.exists('config') then
    shell.run('label set "CC:IM criado por: Player_rs"')
    term.clear()
    term.setCursorPos(1,1)
    print('Creating the "config" file')
    local config_txt = [===[CHAT_NAME = "SYSTEM"  --Coloque: CHAT_NAME = nil Se quiser desativar o chat
--Put: CHAT_NAME = nil If you want to disable the system chat

MODEM_CHANNEL = 0
-- se for usar o RemoteAPI por favor escolher um canal ÚNICO de 0 á 65535 para ser usado!
-- if you are going to use RemoteAPI, please choose a SINGLE channel from 0 to 65535 to be used!

chestIn = "back"
chestOut = "right"
sysDirectionOut = ""
--A direção em que o baú que está do lado do Bridge está
--exemplo: "north", "west", "east" ou "south".

--The direction the chest on the Bridge side is in
--example: "north", "west", "east" or "south".

]===]
    local favorites_txt = [===[{
    ["hdpe"] = "mekanism:hdpe_sheet",

}]===]
    local config = fs.open('config', 'w')
    config.write(config_txt)
    config.close()

    if not fs.exists('favorites') then
        local favorites = fs.open('favorites', 'w')
        favorites.write(favorites_txt)
        favorites.close()
    end

    print(message.systemPrint.openingFile)
    sleep(2)
    shell.run("edit config")
end

-- Loaders
local im = peripheral.find("inventoryManager")
local cb = peripheral.find("chatBox")
local rs = peripheral.find("rsBridge")
local me = peripheral.find("meBridge")

if im == nil then error(message.error.imNotFound) end
if cb == nil then print(message.messages.cbNotFound) end
if rs == nil and me == nil then error(message.error.bridgeNotFound) end
if rs ~= nil and me ~= nil then error(message.error.onlyOneBridge) end


local system
if rs ~= nil then system = rs else system = me end
local Player = im.getOwner() or error(message.error.imMissingMemoryCard)

local commands = {
    {name = "HELP", chat = "", description = ""},
    {name = "CLEAR", chat = "", description = ""},
    {name = "TAKE", chat = "", description = ""},
    {name = "CONSULT", chat = "", description = ""},
    {name = "CRAFT", chat = "", description = ""},
    {name = "ADDFAV", chat = "", description = ""},
    {name = "LISTFAV", chat = "", description = ""},
    {name = "REMOVEFAV", chat = "", description = ""},
    {name = "FORCE", chat = "", description = ""},
}

os.loadAPI("config")
local cbName = config.CHAT_NAME
local mAPI
local modem
if cb == nil then
    if not fs.exists('ModemAPI') then
        shell.run('wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/APIs/ModemAPI ModemAPI')
    end
    mAPI = require('ModemAPI')
    modem = mAPI.startModem(config.MODEM_CHANNEL)
end

print(message.systemPrint.configLoaded)

for _,v in pairs(commands) do
    v.description = message.commandsDescription[v.name]
    v.chat = message.commandsCall[v.name]
end

local f = fs.open('favorites', 'r')
local favorites = textutils.unserialize(f.readAll())
f.close()

-- Stuff
local function sendReply(string)
    print(string)
    if cbName and cb ~= nil then
        cb.sendMessageToPlayer(string, Player, cbName)
    else
        modem.transmit(config.MODEM_CHANNEL, config.MODEM_CHANNEL, string)
    end
end

local function matchFavorite(string)
    if favorites ~= nil then
        for k,v in pairs(favorites) do
            if string == k then
                return v
            end
        end
    else
        return string
    end
    return string
end

-- Functions
local functions = {}

function functions.FORCE(system, args) -- Made by Harry and Reavik
    local command = args[1]
    local item = args[2]
    table.remove(args, 1)
    table.remove(args, 2)

    local Tabela = system.listItems()
    local search
    local exato
    local parecido
    local parecido2

    for a = 1, #Tabela, 1 do
        local splitOn = Tabela[a]["displayName"]
        -- Ajusto na string.
        local t = {}
        for w in string.gsub(item, "([%u][%l]*)", "%1 "):gmatch("%S+") do
            table.insert(t, w)
        end
        local ItemTextoGrande = ""
        for i, word in ipairs(t) do
            ItemTextoGrande = ItemTextoGrande .. word .. " "
        end
        ItemTextoGrande = string.sub(ItemTextoGrande, 1, -2) -- remove o último espaço em branco

        -- Buscando Item
        local inicio, fim = string.find(string.lower(Tabela[a]["displayName"]), string.lower(t[1])) -- First Word
        local inicio2 = nil
        local inicio3 = nil
        if t[2] ~= nil then inicio2 = string.find(string.lower(Tabela[a]["displayName"]), string.lower(t[2])) end -- Second Word
        if t[3] ~= nil then inicio3 = string.find(string.lower(Tabela[a]["displayName"]), string.lower(t[3])) end -- Third Word

        if (string.lower(splitOn) == string.lower("[" .. ItemTextoGrande .. "]") and exato == nil) then
            exato = Tabela[a]
        elseif inicio3 ~= nil and inicio2 ~= nil and inicio ~= nil then
            parecido = Tabela[a]
            parecido2 = Tabela[a]
        elseif inicio2 ~= nil and inicio ~= nil and parecido2 == nil then
            parecido = Tabela[a]
        elseif inicio ~= nil and parecido == nil then
            parecido = Tabela[a]
        end
    end

    if exato ~= nil then
        search = exato
    elseif parecido ~= nil then
        search = parecido
    end

    if search == nil then
        sendReply(message.messages["notfound"])
    else
        for _, comando in ipairs(commands) do
            if command == comando.chat then
                for k,v in pairs(functions) do
                    if k == comando.name then
                        table.insert(args, 1, search["name"])
                        v(system, args)
                        return
                    end
                end
                break
            end
        end
    end
end

function functions.HELP(_, args)
    local command = args[1]
    if command then
        for _,v in pairs(commands) do
            if command == v.chat then
                sendReply(string.format(">> %s =  %s", v.chat, v.description))
                return
            end
        end
        return sendReply(message.messages.commandNotFound)
    end
    for k,v in pairs(commands) do
        sendReply(string.format("--------- [%s/%s] ---------", k, #commands))
        sleep(1)
        sendReply(string.format(">> %s =  %s", v.chat, v.description))
        sleep(1)
    end
end

function functions.CLEAR(_, args)
    local from = tonumber(args[1]) or 9
    local to = tonumber(args[2]) or 35
    local chestOut = config.chestOut
    local myInv = im.getItems()
    local foo = {}

    sendReply(string.format(message.messages.clearCommand, from, to))
    for k,v in pairs(myInv) do
        table.insert(foo,k,v.count)
    end
    if from == 0 then
        im.removeItemFromPlayer(chestOut, 1, 0)
    end
    for k,v in pairs(foo) do
        if k>=from and k<=to then
            im.removeItemFromPlayer(chestOut,v,k)
        end
    end
end

function functions.TAKE(system, args)
    local item = matchFavorite(args[1])
    local count = tonumber(args[2]) or 1
    local slots = tonumber(args[3])
    local content = system.getItem({name = item})
    local chestIn = config.chestIn
    local chestOut = config.sysDirectionOut

    if im.getEmptySpace() < count/64 then
        sendReply(string.format(message.messages.notEnoughSpace, im.getEmptySpace(), im.getEmptySpace()*64))
        return
    end
    if content == nil then
        sendReply(message.messages["notfound"])
        return
    end
    if system == me then
        if content.amount == 0 then
            sendReply(message.messages.noSuchItem)
            return
        end
    end
    if content.amount <= count then
        count = content.amount
    end
    local beenExported = system.exportItem({name = item, count = count}, chestOut)

    if beenExported >= 1 then
        sendReply(string.format(message.messages.successfullyExported, item, count, slots or message.messages.anySlot))
        im.addItemToPlayer(chestIn, count, slots or -1, item)
    else
        sendReply(message.messages.unableToExport)
    end
end

function functions.CONSULT(system, args)
    local item = matchFavorite(args[1])
    local content = system.getItem({name = item})

    if content == nil then
        sendReply(message.messages["notfound"])
        return
    end

    sendReply(string.format(message.messages.consultResult, content.name, content.amount, content.isCraftable))
end

function functions.CRAFT(system, args)
    local item = matchFavorite(args[1])
    local count = tonumber(args[2]) or 1

    local content = system.getItem({name = item})
    if content == nil then
        sendReply(message.messages["notfound"])
        return
    end
    if system ~= me then
        if not system.isItemCraftable({name = item, count = count}) then
            sendReply(message.messages.craftNotAutomated)
            return
        end
    end
    local craft
    craft = system.craftItem({name = item, count = count})
    if craft then
        sendReply(string.format(message.messages.crafting, count, item))
    else
        sendReply(string.format(message.messages.unableToCraft, count, item))
    end
end

function functions.LISTFAV()
    term.setTextColor(colors.yellow)
    sendReply("------ [ALIAS] ------")
    for k, v in pairs(favorites) do
        sleep(1)
        sendReply(string.format(">> %s = %s ", k, v))
    end
    sleep(1)
    sendReply("------ [FINAL] ------")
    term.setTextColor(colors.white)
end

function functions.ADDFAV(_, args)
    local alias = args[1]
    if not alias then
        sendReply(message.messages.missingAliasToAdd)
        return
    end
    local id = args[2] or im.getItemInHand().name
    favorites[alias] = id
    local f = fs.open('favorites', 'w')
    f.write(textutils.serialize(favorites))
    f.flush()
    f.close()
    sendReply(string.format(message.messages.aliasAdded, alias, id))
end

function functions.REMOVEFAV(_, args)
    local alias = args[1]
    if not alias then
        sendReply(message.messages.missingAliasToRemove)
        return
    end
    favorites[alias] = nil
    local f = fs.open('favorites', 'w')
    f.write(textutils.serialize(favorites))
    f.flush()
    f.close()
    sendReply(string.format(message.messages.aliasRemoved, alias))
end


-- Roda Roda Jequitti
sendReply(message.systemPrint.systemReady)
while true do
    local _, player, msg, channel, rChannel

    if cb ~= nil then
        _, player, msg = os.pullEvent("chat")
    else
        _, msg, rChannel = mAPI.receive()
    end

    local args = {}
    for argumentos in msg:gmatch("%S+") do
        table.insert(args, argumentos)
    end

    if player == Player or cb == nil then
        for _, comando in ipairs(commands) do
            if args[1] == comando.chat then
                for k,v in pairs(functions) do
                    if k == comando.name then
                        table.remove(args, 1)
                        v(system, args)
                        break
                    end
                end
                break
            end
        end
    end
end
