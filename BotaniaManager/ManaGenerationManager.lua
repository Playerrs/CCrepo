-- Created by Player_rs
-- V: 0.2

local reader = peripheral.find("blockReader")
local mon = peripheral.wrap("left")
local outputSig = "back"
local inputSig = "right"
local coolDown = 10

local max = reader.getBlockData().manaCap or 10000000
mon.setTextScale(0.9)
local W, H = mon.getSize()
mon.clear()
mon.setCursorPos(1, 1)
local lever = false
local color = colors.white


local function turnSignalOn(msg)
    color = colors.red
    mon.setTextColor(color)
    rs.setOutput(outputSig, true)
    mon.write(msg)
end

local function turnSignalOff(msg)
    color = colors.green
    mon.setTextColor(color)
    rs.setOutput(outputSig, false)
    mon.write(msg)
end

local function printStatus(data)
    mon.setCursorPos(W/2, math.ceil(H/2)+1)
    if data.mana >= max or lever then
        turnSignalOn("OFF!")
    else
        turnSignalOff("ON!")
    end
end

local function leverStatus() -- TODO Add a button to change this value
    mon.setCursorPos(4, 8)
    lever = rs.getInput(inputSig)
    if lever then
        mon.setTextColor(colors.yellow)
        mon.write("Lever ON!")
    end
end

while true do
    mon.clear()
    local data = reader.getBlockData()

    leverStatus()

    printStatus(data)


    mon.setBackgroundColor(color)
    for i = 1, 3 do
        mon.setCursorPos(1, i)
        mon.write(string.rep(" ", W))
    end
    mon.setCursorPos(4, 2)
    mon.setTextColor(colors.white)
    mon.write("Mana Farm")
    mon.setBackgroundColor(colors.black)



    sleep(coolDown)
end