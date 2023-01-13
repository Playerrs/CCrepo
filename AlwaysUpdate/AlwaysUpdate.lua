-- Updater
local args = {...}

local function _finder(semiURL, file)
    local f = fs.open(file, 'r')
    for l in f.readLine do
        if string.find(l, 'class src="'..semiURL) then
            print(l)
        end
    end
    print(string.find(f.readAll(), 'class src="'..semiURL))
end


if args[1] == "file" then
    local item = args[2]
    local name = args[3]

    local github = "https://raw.githubusercontent.com/"
    local user = "Playerrs/"

    local repos = {"CC-projects/", "CC-Music-Player/"}
    local branches = {"main/", "master/"}

    for _, repo in ipairs(repos) do
        for _, branch in ipairs(branches) do
            local url = github..user..repo..branch..item
            print(shell.run("wget "..url.." "..name))
        end
    end

elseif args[1] == "dw" then
    local item = args[2]
    local name = args[3]
    print(shell.run("wget "..item.." "..name))

elseif args[1] == "solve" then
    local url = args[2]
    local file = args[3]

    _finder(url, file)
    --local f = fs.open(item, 'r')
    --for l in f.readLine do
    --    if string.find() then
    --
    --    end
    --end
end