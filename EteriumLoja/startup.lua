-- By Reavik and Player_rs V1

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

local function serialize(data)
    if not fs.exists('EteriumSky') then
        fs.makeDir('EteriumSky')
    end
    local f = fs.open('EteriumSky/priceTable.lua', 'w')
    f.write(textutils.serialize(data))
    f.close()
end

local tablet = {
    {name = "Minhoca", info = "2000/inv", tier = 1},
    {name = "Terra", info = "600/pack - SUGERIDO: 800/pack", tier = 1},
    {name = "Grama", info = "700/pack - SUGERIDO: 1000/pack", tier = 1},
    {name = "Oak Lok", info = "800/pack - SUGERIDO: 1000/pack", tier = 1},
    {name = "Cobblestone", info = "1000/pack - SUGERIDO: 1000/pack", tier = 1},
    {name = "Bread", info = "500/16un - SUGERIDO: 850/16un ", tier = 1},
    {name = "Apple", info = "300/16un - SUGERIDO: 450/16un", tier = 1},
    {name = "String", info = "600/pack - SUGERIDO: 750/pack", tier = 1},
    {name = "Wool", info = "2500/pack - SUGERIDO: 3000/pack", tier = 1},
    {name = "Feater", info = "750/pack - SUGERIDO: 1000/pack", tier = 1},
    {name = "Flint", info = "4500/inv", tier = 2},
    {name = "Nether Quartz", info = "5000/pack - SUGERIDO: 7000/pack", tier = 2},
    {name = "Coal", info = "1000/pack - SUGERIDO: 1000/pack", tier = 2},
    {name = "Arcane Crystal", info = "11000/pack - SUGERIDO: 15000/pack", tier = 2},
    {name = "Iron", info = "5500/pack - SUGERIDO: 6000/pack ", tier = 2},
    {name = "Redstone", info = "3000/pack - SUGERIDO: 3500/pack", tier = 2},
    {name = "Lapis Lazuli", info = "3000/pack - SUGERIDO: 3700/pack", tier = 2},
    {name = "Gold", info = "8000/pack - SUGERIDO: 10000/pack", tier = 2},
    {name = "Diamond", info = "7500/pack - SUGERIDO: 8500/pack", tier = 2},
    {name = "Emerald", info = "7600/pack - SUGERIDO: 8000/pack", tier = 2},
    {name = "Netherite", info = "25000/pack - SUGERIDO: 30000/pack", tier = 2},
    {name = "Copper", info = "7150/pack - SUGERIDO: 7500/pack", tier = 2},
    {name = "Tin", info = "150/pack - SUGERIDO: 7750/pack", tier = 2},
    {name = "Aluminum", info = "7000/pack - SUGERIDO: 7500/pack", tier = 2},
    {name = "Zinc", info = "7150/pack - SUGERIDO: 8000/pack", tier = 2},
    {name = "Silver", info = "7150/pack - SUGERIDO: 7600/pack", tier = 2},
    {name = "Nickel", info = "7150/pack - SUGERIDO: 7500/pack", tier = 2},
    {name = "Uranium", info = "8000/pack - SUGERIDO: 8750/pack", tier = 2},
    {name = "Osmium", info = "8500/pack - SUGERIDO: 9000/pack", tier = 2},
    {name = "Platinum", info = "8500/pack - SUGERIDO: 9000/pack", tier = 2},
    {name = "Crimson", info = "15000/pack - SUGERIDO: 20000/pack", tier = 2},
    {name = "Bismut", info = "15000/pack - SUGERIDO: 16500/pack", tier = 2},
    {name = "Lead", info = "15000/pack - SUGERIDO: 17250/pack", tier = 2},
    {name = "Leather", info = "4000/pack - SUGERIDO: 4500/pack", tier = 2},
    {name = "Bone", info = "6000/pack - SUGERIDO: 6000/pack", tier = 2},
    {name = "Phantom Membrane", info = "32000/pack - SUGERIDO: 32000/pack", tier = 2},
    {name = "Gunpowder", info = "7000/pack - SUGERIDO: 7500/pack", tier = 2},
    {name = "Flux Dust", info = "5000/pack - SUGERIDO: 6500/pack", tier = 2},
    {name = "Clay", info = "4000/pack - SUGERIDO: 5000/pack", tier = 2},
    {name = "Gelo", info = "5000/pack - SUGERIDO: 5500/pack", tier = 2},
    {name = "Crusher Silent", info = "30000/un - SUGERIDO: 35000/un", tier = 2},
    {name = "Thermal", info = "30000/un - SUGERIDO: 40000/un", tier = 2},
    {name = "Litherite", info = "32500/16un - SUGERIDO: 35000/16un", tier = 2},
    {name = "Erodium", info = "65000/16un - SUGERIDO: 80000/16un", tier = 2},
    {name = "Upgrades Industrial", info = "20000/un - SUGERIDO: 25000/un", tier = 2},
    {name = "Prosperity Shard", info = "6000/pack - SUGERIDO: 8000/pack", tier = 2},
    {name = "Inferium", info = "6250/pack - SUGERIDO: 10625/pack", tier = 2},
    {name = "Prudentium", info = "25000/pack - SUGERIDO: 41250/pack", tier = 2},
    {name = "Seeds tier 1", info = "15000/un - SUGERIDO: 20000/un", tier = 2},
    {name = "Seeds tier 2", info = "25000/un - SUGERIDO: 30000/un", tier = 2},
    {name = "Draconium Ingot", info = "15000/un - SUGERIDO: 16000/un", tier = 2},
    {name = "Coke", info = "45000/inv", tier = 3},
    {name = "Energized Steel", info = "40000/pack - SUGERIDO: 50000/pack", tier = 3},
    {name = "Blazing Crystal", info = "60000/pack - SUGERIDO: 75000/pack", tier = 3},
    {name = "Slime Ball", info = "20000/pack - SUGERIDO: 25000/pack", tier = 3},
    {name = "Magma Cream", info = "25000/pack - SUGERIDO: 30000/pack", tier = 3},
    {name = "Ender Pearl", info = "16000/16un - SUGERIDO: 20000/16un", tier = 3},
    {name = "Silicon", info = "20000/pack - SUGERIDO: 25000/pack", tier = 3},
    {name = "Steel", info = "35000/pack - SUGERIDO: 40000/pack", tier = 3},
    {name = "Uraninite", info = "50000/pack - SUGERIDO: 55000/pack ", tier = 3},
    {name = "Wither Rose", info = "50000/un - SUGERIDO: 55000/un ", tier = 3},
    {name = "Rubber", info = "25000/pack - SUGERIDO: 28000/pack", tier = 3},
    {name = "Signalum", info = "40000/pack - SUGERIDO: 43500/pack", tier = 3},
    {name = "Lumium", info = "37000/pack - SUGERIDO: 40000/pack", tier = 3},
    {name = "Gobber", info = "35000/pack - SUGERIDO: 40000/pack", tier = 3},
    {name = "Glowstone", info = "20000/pack - SUGERIDO: 22000/pack", tier = 3},
    {name = "Dragon Breath", info = "40000/2un - SUGERIDO: 50000/2un", tier = 3},
    {name = "Fluid Extractor", info = "45000/un - SUGERIDO: 50000/un", tier = 3},
    {name = "Latex Processor Unit", info = "45000/un - SUGERIDO: 60000/un", tier = 3},
    {name = "Multiservo Press", info = "45000/un - SUGERIDO: 55000/un", tier = 3},
    {name = "Alloy Smelter", info = "45000/un - SUGERIDO: 60000/un", tier = 3},
    {name = "Metalurgic Infuser", info = "75000/un - SUGERIDO: 90000/un", tier = 3},
    {name = "Industrial Foregoing", info = "45000/un - SUGERIDO: 50000/un", tier = 3},
    {name = "Upgrade Basic Mekanism", info = "40000/un - SUGERIDO: 50000/un", tier = 3},
    {name = "Kyronite", info = "100000/16un = SUGERIDO: 110000/16un", tier = 3},
    {name = "Mekanism", info = "60000/un - SUGERIDO: 75000/un", tier = 3},
    {name = "Laser Drill", info = "60000/un - SUGERIDO: 80000/un", tier = 3},
    {name = "Tertium", info = "100000/pack - SUGERIDO: 125000/pack", tier = 3},
    {name = "Simple Machine Casing", info = "15000/un - SUGERIDO: 20000/un", tier = 3},
    {name = "Advanced Machine Casing", info = "25000/un - SUGERIDO: 30000/un", tier = 3},
    {name = "Supreme Machine Casing", info = "35000/un - SUGERIDO: 40000/un", tier = 3},
    {name = "Seeds tier 3", info = "80000/un - SUGERIDO: 90000/un\nname = POWAH > 200000/un - SUGERIDO: 250000/un\nname = Mobs = 120000/un - SUGERIDO: 150000/un", tier = 3},
    {name = "Seeds tier 1", info = "35000/un - SUGERIDO: 40000/un", tier = 3},
    {name = "Seeds tier 2", info = "55000/un - SUGERIDO: 75000/un", tier = 3},
    {name = "HDPE", info = "80000/inv", tier = 4},
    {name = "Spirited Crystal", info = "100000/pack - SUGERIDO: 130000/pack", tier = 4},
    {name = "Nitro Crystal", info = "150000/pack - SUGERIDO: 200000/pack", tier = 4},
    {name = "Applied Singularity", info = "120000/4un - SUGERIDO: 150000/4un", tier = 4},
    {name = "Mica", info = "160000/16un - SUGERIDO: 160000/16un", tier = 4},
    {name = "Medal of Heroism", info = "150000/un - SUGERIDO: 160000/un", tier = 4},
    {name = "Crystal Matrix", info = "100000/pack - SUGERIDO: 120000/pack", tier = 4},
    {name = "Enderium", info = "200000/pack - SUGERIDO: 230000/pack", tier = 4},
    {name = "Alfsteel", info = "200000/pack - SUGERIDO: 225000/pack", tier = 4},
    {name = "Invitation", info = "100000/3un - SUGERIDO: 150000/3un", tier = 4},
    {name = "Rune of Element", info = "100000/pack - SUGERIDO: 120000/pack", tier = 4},
    {name = "PowerPot Mk1", info = "250000/un - SUGERIDO: 350000/un", tier = 4},
    {name = "PowerPot Mk2", info = "500000/un - SUGERIDO: 700000/un", tier = 4},
    {name = "Ionite", info = "400000/16un - SUGERIDO: 500000/16un", tier = 4},
    {name = "Elite tier Instaler", info = "150000/un - SUGERIDO: 200000/un", tier = 4},
    {name = "Supremium", info = "1600000/pack - SUGERIDO: 2000000/pack", tier = 4},
    {name = "Seeds tier 5", info = "500000/un - SUGERIDO: 750000/un\nname = POWAH > 700000/un - SUGERIDO: 1000000/un", tier = 4},
    {name = "Simulation Chamber", info = "240000/un - SUGERIDO: 250000/un", tier = 4},
    {name = "Loot Fabricator", info = "150000/un - SUGERIDO: 170000/un", tier = 4},
    {name = "Quantum Circuit", info = "193000/un - SUGERIDO: 200000/un", tier = 4},
    {name = "Eterium Alloy", info = "82000/un - SUGERIDO: 85000/un", tier = 4},
    {name = "Eterium Processor", info = "82000/un - SUGERIDO: 85000/un", tier = 4},
    {name = "Niotic Crystal", info = "80000/pack - SUGERIDO: 100000/pack", tier = 4},
    {name = "Ink Sac", info = "60000/pack - SUGERIDO: 65000/pack", tier = 4},
    {name = "Blaze Rod", info = "60000/pack - SUGERIDO: 64000/pack", tier = 4},
    {name = "Ghast Tear", info = "65000/pack - SUGERIDO: 70000/pack", tier = 4},
    {name = "Phantom Membrane", info = "80000/pack - SUGERIDO: 80000/pack", tier = 4},
    {name = "Prismarine", info = "85000/pack - SUGERIDO: 90000/pack", tier = 4},
    {name = "Nether Star", info = "70000/pack - SUGERIDO: 70000/pack", tier = 4},
    {name = "Egg", info = "70000/pack - SUGERIDO: 70000/pack", tier = 4},
    {name = "Hop Graphite", info = "100000/pack - SUGERIDO: 120000/pack", tier = 4},
    {name = "Terrasteel", info = "90000/pack - SUGERIDO: 120000/pack", tier = 4},
    {name = "Lithium", info = "120000/pack - SUGERIDO: 130000/pack", tier = 4},
    {name = "Gaia Spirit", info = "120000/pack - SUGERIDO: 120000/pack ", tier = 4},
    {name = "Soul Shard", info = "100000/pack - SUGERIDO: 100000/pack ", tier = 4},
    {name = "Certus Quartz", info = "50000/pack - SUGERIDO: 55000/pack", tier = 4},
    {name = "Dragon Egg", info = "60000/2un - SUGERIDO: 65000/2un", tier = 4},
    {name = "Botany Pot", info = "100000/un - SUGERIDO: 130000/un", tier = 4},
    {name = "Pladium", info = "160000/16un - SUGERIDO: 180000/16un", tier = 4},
    {name = "Advanced tier Installer", info = "50000/un - SUGERIDO: 100000/un", tier = 4},
    {name = "Applied Press", info = "30000/un - SUGERIDO: 50000/un", tier = 4},
    {name = "Imperium "= "400000/pack - SUGERIDO: 500000/pack", tier = 4},
    {name = "Seeds tier 4", info = "200000/un - SUGERIDO: 250000/un\nname = POWAH > 400000/un - SUGERIDO: 500000/un\nname = Mobs > 250000/un - SUGERIDO: 400000/un", tier = 4},
    {name = "Plutonium", info = "500000/inv ~ Pollonium - 1000000/inv", tier = 5},
    {name = "Ultimate tier Instaler", info = "800000/un", tier = 5},
    {name = "Insanium", info = "6400000/pack", tier = 5},
    {name = "Nitro Seed", info = "3000000/un", tier = 5},
    {name = "Seed de Netherstar", info = "2000000/un", tier = 5},
    {name = "Awakened Draconium Seed", info = "8000000/un", tier = 5},
    {name = "Dragon Egg Seed", info = "7500000/un", tier = 5},
    {name = "Elementium singularity", info = "10100000/un", tier = 5},
    {name = "Lapis lazuli singularity", info = "2500000/un", tier = 5},
    {name = "Draconium Singularity", info = "2150000/un", tier = 5},
    {name = "Tin Singularity", info = "5400000/un", tier = 5},
    {name = "Iron Singularity", info = "3850000/un", tier = 5},
    {name = "Diamond Singularity", info = "5000000/un", tier = 5},
    {name = "Terrasteal Singularity", info = "51700000/un", tier = 5},
    {name = "Redstone Singularity", info = "2300000/un", tier = 5},
    {name = "Quartz Singularity", info = "4050000/un", tier = 5},
    {name = "Awakened Singularity", info = "170000000/un", tier = 5},
    {name = "Manasteel Singularity", info = "7600000/un", tier = 5},
    {name = "Gold Singularity", info = "5800000/un", tier = 5},
    {name = "Emerald Singularity", info = "4800000/un", tier = 5},
    {name = "Netherite Singularity", info = "15200000/un", tier = 5},
    {name = "Clay Singularity", info = "350000/un", tier = 5},
    {name = "Lead Singularity", info = "10400000/un", tier = 5},
    {name = "Cobalt Singularity", info = "9200000/un", tier = 5},
    {name = "Manyullyn Singularity", info = "11600000/un", tier = 5},
    {name = "Nickel Singularit", info = "5400000/un", tier = 5},
    {name = "Infinity Catalist", info = "350000000/un", tier = 5},
    {name = "Aethium", info = "1000000/16un", tier = 5},
    {name = "Nanorite", info = "2000000/16un", tier = 5},
    {name = "Xerothium", info = "4000000/16un", tier = 5},
    {name = "Awakened Draconium Ingot", info = "250000/un", tier = 5},
    {name = "Awakened Draconium", info = "250000/un", tier = 5},
    {name = "Draconium Core", info = "10000/un", tier = 5},
    {name = "Wyvern Core", info = "970000/un", tier = 5},
    {name = "Draconic Core", info = "4760000/un", tier = 5},
    {name = "AntiMatter Pellet", info = "550000/un", tier = 5}
}


-- Main
serialize(tablet)
if not fs.exists("EteriumSky/priceTable.lua") then _downloadList() end
local tabela = loadTabela()

while true do
    local e, player, msg = os.pullEvent("chat")
    local split_string = Split(msg, " ")
    msg = (split_string[1]):lower()

    if msg == "preço" or msg == "preco" or msg == "price" then
        local item = split_string[2]:lower()

        local stats, result = findItem(item, tabela)

        if stats then
            sendMessage(("[Tier %s] [%s]: %s"):format(result.tier, result.name, result.info))
        else
            sendMessage(("O item que você procurou não foi encontrado [%s]"):format(item), player)
        end
    end
end