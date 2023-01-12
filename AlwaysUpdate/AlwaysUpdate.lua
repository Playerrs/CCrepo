-- Updater
local args = {...}

if args[1] == "dw" then
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

else
    local item = args[2]
    local name = args[3]
    print(shell.run("wget "..item.." "..name))
end