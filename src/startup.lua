-- By Player_rs and Reavik



local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local again = true

local li = {
    "https://drive.google.com/u/0/uc?id=1uKuRgIOe07ngdMuznXZBbqPRbdLaZ7Gf&export=download",
    "https://drive.google.com/u/0/uc?id=1LPQhHAwzd_Nz1_PEnSK0HY0cxhJMDu5p&export=download",
    "https://drive.google.com/u/0/uc?id=1ONWankUbuqFDeoGkVgMnj-q6PCfsfk0N&export=download"
}
while again == true do

    print("Reproduzindo playlist")

    for i = 1, #li do
        print(li[i])
        shell.run("speaker play "..li[i])
    end

    write("Play another song? (y/n) ")
    again = read()
    if again == "n" then again = false
    else again = true end
end