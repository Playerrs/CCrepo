local en_US = {}

en_US.messages = { -- If there are %s in any messages PLEASE DO NOT REMOVE!

    -- If the Chat Box is not found next to the computer the script will use the PocketAPI
    ['cbNotFound'] = "chatbox not found, using RemoteAPI.",

    -- ALL COMMANDS: If an item with the given argument is not found
    ["notfound"] = "No items found with what you provided me!",

    -- If the requested program is not found in the HELP COMMAND
    ['commandNotFound'] = "Command not found!",

    -- CLEAR COMMAND
    ['clearCommand'] = "Clearing inventory from slot %s to %s!",

    -- TAKE COMMAND: If there is not enough space in the inventory
    ['notEnoughSpace'] = "Hold on buddy, you only have %s slots or %s items available!",

    -- ["notfound"] COMMAND TAKE

    -- TAKE COMMAND: If there is no requested item in the system
    ['noSuchItem'] = "No such item in the system!",

    -- TAKE COMMAND: If the system is able to export the item
    ['successfullyExported'] = "Successfully exported: Item: %s, Amount: %s, Slot: %s!",

    -- COMMAND TAKE: Word to mean any slot
    ['anySlot'] = "any",

    -- TAKE COMMAND: If the system is unable to export the item
    ['unableToExport'] = "Unable to export this item from the system!",

    -- ["notfound"] COMMAND CONSULT

    -- CONSULT COMMAND: The result of the CONSULT command
    ['consultResult'] = "Name: %s, Amount: %s, Craftable: %s",

    -- ["notfound"] CRAFT COMMAND

    -- CRAFT COMMAND: If the item is not automated for auto-crafting
    ['craftNotAutomated'] = "This item is not automated :(",

    -- CRAFT COMMAND: When the system manages to send the craft order
    ['crafting'] = "Crafting: %s, %s",

    -- CRAFT COMMAND: If the system is unable to craft the item
    ['unableToCraft'] = "Unable to craft! (%s, %s)",

    -- ADDFAV COMMAND: If an argument of (alias/nickname/shortcut) is not provided
    ['missingAliasToAdd'] = "You need to put an alias to add it!",

    -- ADDFAV COMMAND: When the alias is added
    ['aliasAdded'] = "Alias: %s, to: %s, successfully added!",

    -- REMOVEFAV COMMAND: If no alias is given
    ['missingAliasToRemove'] = "You need to put an alias to delete!",

    -- REMOVEFAV COMMAND: When the command is removed
    ['aliasRemoved'] = "Alias: %s, successfully removed!",
}

en_US.systemPrint = { -- \n means skip line
    ['openingFile'] = "\nOpening file to edit!",
    ['configLoaded'] = "Config loaded!",
    ['systemReady'] = "System ready! Use help to see available commands!",
}

en_US.error = {

    -- If the Inventory Manager is not found next to the computer
    ['imNotFound'] = "inventoryManager not found",

    -- If no Bridge is contracted, namely: RS Bridge or ME Bridge
    ['bridgeNotFound'] = "You need to place a block to link with your AE2 or Refined system",

    -- If more than one Bridge is found connected to the computer
    ['onlyOneBridge'] = "You can only add ONE system to work",

    -- If the script fails to get the player that is inside the Inventory Manager
    ['imMissingMemoryCard'] = "You need to put the linked memory card with you in the Inventory Manager",
}

en_US.commandsDescription = {
    ["HELP"] = "Show the descriptions!",
    ["CLEAR"] = "Remove items from inventory: COMMAND <from> <to>",
    ["TAKE"] = "Get an item from the system: COMMAND *item* <amount> <slot>",
    ["CONSULT"] = "Shows the amount you have in the system if CHAT_NAME is enabled: COMMAND *item*",
    ["CRAFT"] = "Have the system craft the desired item if possible",
    ["ADDFAV"] = "Adds an alias to the favorites group: COMMAND *alias* (*ID* or hold item in hand)",
    ["LISTFAV"] = "Shows all saved aliases",
    ["REMOVEFAV"] = "Remove an alias: COMMAND *alias*",
    ["FORCE"] = "Force an item to be found by going through ALL system items (LAGS THE SERVER!)",
}

en_US.commandsCall = {
    ["HELP"] = "help",
    ["CLEAR"] = "clear",
    ["TAKE"] = "give",
    ["CONSULT"] = "cons",
    ["CRAFT"] = "craft",
    ["ADDFAV"] = "add",
    ["LISTFAV"] = "fav",
    ["REMOVEFAV"] = "remove",
    ["FORCE"] = "f",
}


return en_US