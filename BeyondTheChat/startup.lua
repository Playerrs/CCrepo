---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by josue.
--- DateTime: 11/04/2023 21:09
---

os.loadAPI('/Dependencies/Manager.lua')
local api = Manager
settings.load(".settings")
--settings.set("default-port", 20358)
--settings.save(".settings")

local _defaultPort = settings.get("default-port")


if fs.exists("Client") then
    print("Starting Client Mode")
    shell.run("Client/main.lua", _defaultPort)
elseif fs.exists("Server") then
    print("Starting Server Mode")
    shell.run("Server/main.lua", _defaultPort)
end

print("Startup Final!")

