-- Created by Player_rs
-- V: 1.52

local version = 1.52
-- Langs
local lang = {}

lang.pt_br = {
    ['pocketName'] = "Escreva o nome que você quer para este Pocket",
    ['newInstance'] = "Vamos criar sua instância, por favor digite o nome dela",
    ['modemChannel'] = "Insira agora o canal que você vai usar nesta instância ( entre 0 e 65535 )",
    ['anotherInstance'] = "Deseja criar outra instância? (y/N)",
    ['allDone'] = "Tudo pronto! Aproveite seu %s XD\nRedirecionando..."
}

lang.en_us = {
    ['pocketName'] = "Write the name you want for this Pocket",
    ['newInstance'] = "Let's create your instance, please enter its name",
    ['modemChannel'] = "Now, enter the channel you will use for this instance (between 0 and 65535)",
    ['anotherInstance'] = "Do you want to create another instance? (y/N)",
    ['allDone'] = "All set! Enjoy your %s XD\nRedirecting..."
}

lang.__string = {}
for k,v in pairs(lang)do
    if k:sub(1) ~= "__string" then
        table.insert(lang.__string, k)
    end
end

-- Load Deps
local completion = require "cc.completion"
os.loadAPI('/deps/Utils')
local utils = Utils

-- LOG configuration
local configLogDir = '.configGenLogs/'
utils.initializeLOG(configLogDir, 1000)

local function createLog(item, data, type, notify)
    utils.createLog(item, data, configLogDir, type, notify)
end

utils.reset()

print("Please select your language!")
local selectedLang = utils.parsedCompletion(completion, lang.__string)
local LANG = lang[selectedLang]
createLog("LOG/INFO", "language set to: ".. selectedLang)
utils.saveData('data/config', selectedLang, 'language')

utils.reset()

print(LANG.pocketName)
term.write(">> ")
local _pocketName = read()
os.setComputerLabel(_pocketName)
createLog("LOG/INFO", "New Pocket name: ".. _pocketName)

utils.reset()

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
    utils.saveData('data/config', {name = _instanceName, channel = _instanceModem}, 'instances')
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

createLog("LOG/INFO", "All configurations made successfully! Exiting the configGen, V"..version)
print("\n".. LANG.allDone:format(_pocketName))
sleep(2)