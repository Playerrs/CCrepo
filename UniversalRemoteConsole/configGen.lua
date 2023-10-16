-- Created by Player_rs
-- V: 1.1


-- Langs
local lang = {}

lang.pt_br = {
    ['pocketName'] = "Escreva o nome que você quer para este Pocket",
    ['newInstance'] = "Vamos criar sua primeira instância, por favor digite o nome dela",
    ['modemChannel'] = "Insira agora o canal que você vai usar nesta instância ( entre 0 e 65535 )",
    ['anotherInstance'] = "Deseja criar outra instância? (y/N)",
    ['allDone'] = "Tudo pronto! Agora aproveite seu Remote Console XD"
}

lang.en_us = {
    ['pocketName'] = "Write the name you want for this Pocket",
    ['newInstance'] = "Let's create your first instance, please enter its name",
    ['modemChannel'] = "Now, enter the channel you will use for this instance (between 0 and 65535)",
    ['anotherInstance'] = "Do you want to create another instance? (y/N)",
    ['allDone'] = "All set! Now enjoy your Remote Console XD"
}

lang.__string = {}
for k,v in pairs(lang)do
    if k:sub(1) ~= "__string" then
        table.insert(lang.__string, k)
    end
end

-- Load Deps
local completion = os.loadAPI("rom/modules/main/cc/completion")
os.loadAPI('/deps/Utils')
local utils = Utils

-- LOG configuration
local configLogDir = '.configLOG/'
utils.initializeLOG(configLogDir, 1000)

local function createLog(item, data, type, notify)
    utils.createLog(item, data, configLogDir, type, notify)
end

utils.reset()

print("Please select your language!")
local selectedLang = utils.parsedCompletion(completion, lang.__string)
local LANG = lang[selectedLang]
createLog("LOG/INFO", "language set to: ".. selectedLang)

utils.reset()

print(LANG.pocketName)
term.write(">> ")
local _pocketName = read()
os.setComputerLabel(_pocketName)
createLog("LOG/INFO", "New Pocket name: ".. _pocketName)

utils.reset()

local function saveInstance(instance)
    if not fs.exists('data/instances.json') then
        local f = fs.open('data/instances.json', 'w')
        f.write(textutils.serializeJSON({ instances = {instance} }))
        f.close()
    else
        local f = fs.open('data/instances.json', 'r')
        local data = textutils.unserializeJSON(f.readAll())
        f.close()
        table.insert(data.instances, instance)
        f = fs.open('data/instances.json', 'w')
        f.write(textutils.serializeJSON(data))
        f.close()
    end
end

local function createInstance()
    print(LANG.newInstance)
    term.write(">> ")
    local _instanceName = read()
    print()
    print(LANG.modemChannel)
    term.write(">> ")
    local _instanceModem = tonumber(read())
    textutils.tabulate({name = _instanceName, channel = _instanceModem})
    createLog("LOG/INFO", "New Instance Created, Name: ".._instanceName..", Modem Channel: ".._instanceModem )
    saveInstance({name = _instanceName, channel = _instanceModem})
    print()
    print(LANG.anotherInstance)
    local answer = utils.getAnswer(true)
    if answer:lower() ~= "y" then
        return
    else
        createInstance()
    end
end

createInstance()

print("\n".. LANG.allDone)