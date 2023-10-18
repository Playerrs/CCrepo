-- Created by Player_rs
-- V: 0.1

local version = 0.1
-- Langs
local lang = {}

lang.pt_br = {
    ['pocketName'] = "Escreva o nome que você quer para este Pocket",
    ['newInstance'] = "Vamos criar sua instância, por favor digite o nome dela",
    ['modemChannel'] = "Insira agora o canal que você vai usar nesta instância ( entre 0 e 65535 )",
    ['anotherInstance'] = "Deseja criar outra instância? (y/N)",
    ['allDone'] = "Tudo pronto! Aproveite seu %s XD\n Redirecionando..."
}

lang.en_us = {
    ['pocketName'] = "Write the name you want for this Pocket",
    ['newInstance'] = "Let's create your instance, please enter its name",
    ['modemChannel'] = "Now, enter the channel you will use for this instance (between 0 and 65535)",
    ['anotherInstance'] = "Do you want to create another instance? (y/N)",
    ['allDone'] = "All set! Enjoy your %s XD\n Redirecting..."
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
local editableValue = { ... }
local loadedInstances
local instance
local modInstance

-- LOG configuration
local configLogDir = '.configLOG/'
utils.initializeLOG(configLogDir, 1000)

local function createLog(item, data, type, notify)
    utils.createLog(item, data, configLogDir, type, notify)
end
createLog("LOG/INFO", "Starting ConfigEdit program V:"..version)

utils.reset()

-- Select or load Language
local selectedLang
local LANG
if not fs.exists('data/config.lua') then
    print("Please select your language!")
    selectedLang = utils.parsedCompletion(completion, lang.__string)
    createLog("LOG/INFO", "language set to: ".. selectedLang)
    LANG = lang[selectedLang]
else
    LANG = utils.loadData('data/config').language or "en_us"
end

utils.reset()

-- Load Instances
if editableValue[1] == "instances" then
    loadedInstances = utils.loadData('data/config').instances
    instance = editableValue[2]
end

-- Functions
local function findInstance(instanceName)
    for i = 1, #loadedInstances do
        if loadedInstances[i].name == instanceName then
            return i
        end
    end
    return nil
end

-- USER
utils.printCenter(LANG.tip)

if editableValue[1] == "instances" then
    print("\n\n"..LANG.instances.changeName)
    term.write(">> ")
    local _instanceName = read()
    if _instanceName ~= "" and _instanceName ~= " " then
        modInstance.name = _instanceName
        createLog("LOG/WARN", "Instance ["..instance.name.."], NAME changed to: "..modInstance.name)
    else
        modInstance.name = instance.name
    end
    print()

    print(LANG.instances.changeChannel)
    term.write(">> ")
    local _instanceChannel = read()
    if _instanceChannel ~= "" and _instanceChannel ~= " " then
        modInstance.channel = _instanceChannel
        createLog("LOG/WARN", "'Instance ["..modInstance.name.."], CHANNEL changed to: "..modInstance.channel)
    else
        modInstance.channel = instance.channel
    end
    print()

    print(LANG.instances.delete)
    term.write(">> ")
    local _deleteInstance = read()
    if _deleteInstance == "DELETE" then
        modInstance = nil
        createLog("LOG/WARN", "INSTANCE DELETED, instance name: "..modInstance.name)
    end
    print()

    loadedInstances[findInstance(instance.name)] = modInstance

    utils.saveData('data/config', loadedInstances, 'instances')
    createLog("LOG/INFO", "New instances configs saved!")
end