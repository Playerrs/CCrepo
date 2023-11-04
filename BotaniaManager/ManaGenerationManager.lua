-- Created by Player_rs
-- V: 0.1

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


local function turnSignalOn(msg)
    mon.setTextColor(colors.green)
    rs.setOutput(outputSig, true)
    mon.write(msg)
end

local function turnSignalOff(msg)
    mon.setTextColor(colors.green)
    rs.setOutput(outputSig, false)
    mon.write(msg)
end

local function printStatus(data)
    mon.setCursorPos(W/2, math.ceil(H/2))
    if data.mana >= max or lever then
        turnSignalOn("OFF!")
    else
        turnSignalOff("ON!")
    end
end

local function leverStatus()
    mon.setCursorPos(W/2, math.ceil(H/2)+2)
    lever = rs.getInput(inputSig)
end

while true do

    local data = reader.getBlockData()
    mon.clear()
    mon.setTextColor(colors.white)
    mon.setCursorPos(1, 2)
    mon.write("   Mana Farm")

    leverStatus()

    printStatus(data)


    sleep(coolDown)
end