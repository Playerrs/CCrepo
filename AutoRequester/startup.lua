local label = "Bob - Automated Crafts"
local crafts_file_name = "crafts"


if not fs.exists("code.lua") then
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/AutoCrafter/code.lua")
    os.reboot()
end

multishell.launch({}, "code.lua", label, crafts_file_name)

if not fs.exists(crafts_file_name) then
    local f = fs.open(crafts_file_name, 'w')
    local t = {
        {"Oak_Planks", "minecraft:oak_planks", "100"}
    }
    f.write(textutils.serialize(t))
end

local function serialize(data, name)
    local f = fs.open(name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end

local function unserialize(name)
    if fs.exists(name) then
        local f = fs.open(name, 'r')
        data = textutils.unserialize(f.readAll())
        f.close()
    end
    return data
end

local items

while true do
    local terminal = term.current()
    term.redirect(term.native())
    local W, H = term.getSize()
    term.setTextColor(colors.green)
    term.clear()
    term.setCursorPos(1, 1)
    print(string.rep("#", W))
    print("# <name>       <tag>            <amount>\n# Oak_Planks minecraft:oak_planks 2500\n# add <name> <tag> <amount>\n# change <name> <nameORnil> <tagORnil> <amountORnil>\n# remove <name>\n# list")
    print(string.rep("#", W))
    print(" ")
    term.write("> ")
    --term.redirect(terminal)
    local input = read()
    --terminal = term.current()
    --term.redirect(term.native())

    local args = {}
    for arguments in input:gmatch("%S+") do
        table.insert(args, arguments)
    end

    local crafts = unserialize(crafts_file_name)
    if args[1] == "add" then
        table.insert(crafts, {args[2], args[3], tostring(args[4])})
        serialize(crafts, crafts_file_name)
        os.reboot()
    elseif args[1] == "change" then
        for a = 3, #args do
            if string.find(args[a], "nil") then
                args[a] = nil
            end
        end
        for i = 1, #crafts do
            if string.find(crafts[i][1], args[2]) then
                crafts[i] = {args[3] or crafts[i][1], args[4] or crafts[i][2], args[5] or crafts[i][3]}
                serialize(crafts, crafts_file_name)
                os.reboot()
            end
        end

    elseif args[1] == "remove" then
        for i = 1, #crafts do
            if string.find(crafts[i][1], args[2]) then
                table.remove(crafts, i)
                serialize(crafts, crafts_file_name)
                os.reboot()
            end
        end
    elseif args[1] == "list" then
        for i = 1, #crafts do
            print(string.format("      %s: [%s] [%s]", crafts[i][1], crafts[i][2], crafts[i][3]))
        end
        sleep(#crafts)
    end

    term.redirect(terminal)
end

