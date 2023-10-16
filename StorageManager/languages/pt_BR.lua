local pt_BR = {}

pt_BR.messages = { -- Se houver %s em alguma mensagem FAVOR NÃO RETIRAR!

    -- Se o Chat Box não for encontrado ao lado do computer o script vai usar o RemoteAPI
    ['cbNotFound'] = "chatBox não encontrado, usando RemoteAPI",

    -- TODOS OS COMANDOS: Se não for encontrado um item com o argumento fornecido
    ["notfound"] = "Nenhum item encontrado com o que você me forneceu!",

    -- Se o programa solicitado não for encontrado no COMANDO HELP
    ['commandNotFound'] = "Comando não encontrado!",

    -- COMANDO CLEAR
    ['clearCommand'] = "Limpando inventário do slot %s ao %s!",

    -- COMANDO TAKE: Se não houver espaço suficiente no inventário
    ['notEnoughSpace'] = "Calma lá amigão, você só tem %s slots ou %s itens disponíveis!",

    -- ["notfound"] COMANDO TAKE

    -- COMANDO TAKE: Se não houver nenhum item do solicitado no sistema
    ['noSuchItem'] = "Nenhum item desse no sistema!",

    -- COMANDO TAKE: Se o sistema conseguir exportar o item
    ['successfullyExported'] = "Exportado com sucesso: Item: %s, Quantia: %s, Slot: %s!",

    -- COMANDO TAKE: Palavra para significar qualquer slot
    ['anySlot'] = "qualquer",

    -- COMANDO TAKE: Se o sistema não conseguir exportar o item
    ['unableToExport'] = "Não foi possível exportar esse item do sistema!",

    -- ["notfound"] COMANDO CONSULT

    -- COMANDO CONSULT: O resultado do comando CONSULT
    ['consultResult'] = "Nome: %s, Quantia: %s, É craftavel: %s",

    -- ["notfound"] COMANDO CRAFT

    -- COMANDO CRAFT: Se o item não estiver automatizado para auto-crafting
    ['craftNotAutomated'] = "Este item não está automatizado :(",

    -- COMANDO CRAFT: Quando o sistema conseguir enviar a ordem de craft
    ['crafting'] = "Craftando: %s, %s",

    -- COMANDO CRAFT: Se o sistema não conseguir craftar o item
    ['unableToCraft'] = "Não foi possível craftar! (%s, %s)",

    -- COMANDO ADDFAV: Se não for fornecido um argumento de (alias/apelido/atalho)
    ['missingAliasToAdd'] = "Você precisa colocar um alias para adiciona-lo!",

    -- COMANDO ADDFAV: Quando o apelido for for adicionado
    ['aliasAdded'] = "Alias: %s, para: %s, adicionado com sucesso!",

    -- COMANDO REMOVEFAV: Se não for fornecido nenhum apelido
    ['missingAliasToRemove'] = "Você precisa colocar um alias para deletar!",

    -- COMANDO REMOVEFAV: Quando o comando for removido
    ['aliasRemoved'] = "Alias: %s, removido com sucesso!",


}

pt_BR.systemPrint = { -- \n significa pular linha
    ['openingFile'] = "\nAbrindo arquivo para editar!",
    ['configLoaded'] = "Config carregada!",
    ['systemReady'] = "Sistema pronto! Use ajuda para ver os comandos disponíveis!",
}

pt_BR.error = {

    -- Se o Inventory Manager não for encontrado ao lado do computer
    ['imNotFound'] = "inventoryManager não encontrado",

    -- Se não forem contrados nenhum Bridge sendo eles: RS Bridge ou ME Bridge
    ['bridgeNotFound'] = "Você precisa colocar um bloco para lincar com seu sistema AE2 ou Refined",

    -- Se forem encontrados mais de um Bridge conectados ao computer
    ['onlyOneBridge'] = "Você só pode adicionar UM sistema para funcionar",

    -- Se o script não conseguir pegar o player que está dentro do Inventory Manager
    ['imMissingMemoryCard'] = "Você precisa colocar o memory card lincado com você no Inventory Manager",
}

pt_BR.commandsDescription = {
    ["HELP"] = "Mostra as descrições!",
    ["CLEAR"] = "Tira itens do inventário: COMANDO <de> <até>",
    ["TAKE"] = "Pega um item do sistema: COMANDO *item* <quantia> <slot>",
    ["CONSULT"] = "Mostra quantia que tem no sistema se o CHAT_NAME estiver habilitado: COMANDO *item*",
    ["CRAFT"] = "Faz o sistema craftar o item desejado se possível",
    ["ADDFAV"] = "Adiciona um alias ao grupo de favoritos: COMANDO *alias* (*ID* ou segurar o item na mão)",
    ["LISTFAV"] = "Mostra todos os aliases salvos",
    ["REMOVEFAV"] = "Remove um alias: COMANDO *alias*",
    ["FORCE"] = "Passa por TODOS os itens do sistema para achar o item(LAGA SERVIDOR!!)",
}

pt_BR.commandsCall = {
    ["HELP"] = "ajuda",
    ["CLEAR"] = "limpar",
    ["TAKE"] = "pegar",
    ["CONSULT"] = "cons",
    ["CRAFT"] = "craft",
    ["ADDFAV"] = "add",
    ["LISTFAV"] = "fav",
    ["REMOVEFAV"] = "remove",
    ["FORCE"] = "f",
}

return pt_BR