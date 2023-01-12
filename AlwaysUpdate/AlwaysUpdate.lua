-- Updater
local args = ...
local item = args[1]
local name = args[2]

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