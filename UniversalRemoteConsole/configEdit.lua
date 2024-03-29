-- Created by Player_rs
-- V: 0.49

local version = 0.49
-- Langs
local lang = {}

lang.pt_br = {
    tip = "SE NÃO QUISER ALTERAR ALGUMA INFORMAÇÃO APENAS DEIXE EM BRANCO",
    instances = {
        ['changeName'] = "Digite o novo nome para sua instância",
        ['changeChannel'] = "Digite o novo canal para ser usado em sua instância",
        ['delete'] = "Para deletar esta instância, digite: DELETE",
    }
}

lang.en_us = {
    tip = "IF YOU DO NOT WANT TO CHANGE ANY INFORMATION, JUST LEAVE IT BLANK",
    instances = {
        ['changeName'] = "Enter the new name for your instance",
        ['changeChannel'] = "Enter the new channel to be used in your instance",
        ['delete'] = "To delete this instance, type: DELETE",
    }
}

lang.__string = {}
for k,v in pairs(lang)do
    if k:sub(1) ~= "__string" then
        table.insert(lang.__string, k)
    end
end

-- Load Deps
os.loadAPI('/deps/Utils')
local utils = Utils
local args = { ... }
local editableType = args[1]
table.remove(args, 1)
local loadedInstances
local instance
local modInstance = {}
local _configFile = utils.loadData('data/config')

-- LOG configuration
local configLogDir = '.configEditLogs/'
utils.initializeLOG(configLogDir, 1000)

local function createLog(item, data, type, notify)
    utils.createLog(item, data, configLogDir, type, notify)
end
createLog("LOG/INFO", "Starting ConfigEdit program V:"..version)

utils.reset()

-- load Language
local selectedLang
local LANG = lang[utils.loadData('data/config').language or "en_us"]

utils.reset()

-- Load Instances
if editableType == "instances" then
    loadedInstances = utils.loadData('data/config').instances
    instance = { name = args[1], channel = args[2] }
end

-- Functions
local function writeActualValue(value)
    local _color = term.getTextColor()
    term.setTextColor(colors.green)
    print(string.format(">> %s <<", value))
    term.setTextColor(_color)
end

local function findInstance(instanceName)
    for i = 1, #loadedInstances do
        if loadedInstances[i].name == instanceName then
            return i
        end
    end
    return nil
end

-- USER
utils.printMultiLines(LANG.tip, 2, colors.yellow)

if editableType == "instances" then
    print('\n\n')
    writeActualValue(instance.name)
    print(LANG.instances.changeName)
    term.write(">> ")
    local _instanceName = read()
    if _instanceName ~= "" and _instanceName ~= " " then
        modInstance.name = _instanceName
        createLog("LOG/WARN", "Instance ["..instance.name.."], NAME changed to: "..modInstance.name)
    else
        modInstance.name = instance.name
    end
    print()

    writeActualValue(instance.channel)
    print(LANG.instances.changeChannel)
    term.write(">> ")
    local _instanceChannel = read()
    if _instanceChannel ~= "" and _instanceChannel ~= " " then
        modInstance.channel = tonumber(_instanceChannel)
        createLog("LOG/WARN", "'Instance ["..modInstance.name.."], CHANNEL changed to: "..modInstance.channel)
    else
        modInstance.channel = tonumber(instance.channel)
    end
    print()

    print(LANG.instances.delete)
    term.write(">> ")
    local _deleteInstance = read()
    if _deleteInstance == "DELETE" then
        createLog("LOG/WARN", "INSTANCE WIL BE DELETED, instance name: "..modInstance.name)
        modInstance = nil
    end
    print()

    loadedInstances[findInstance(instance.name)] = modInstance

    _configFile['instances'] = loadedInstances
end

utils.saveData('data/config', _configFile, nil, nil, true)
createLog("LOG/INFO", "Edited settings saved!")

if fs.exists('.editArgs') then
    shell.run("delete .editArgs")
    os.reboot()
end