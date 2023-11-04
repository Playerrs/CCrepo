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

local function leverStatus()
    mon.setCursorPos(W/2, math.ceil(H/2)+3)
    lever = rs.getInput(inputSig)
    if lever then
        mon.setTextColor(colors.yellow)
        mon.write("Lever ON!")
    end
end

while true do

    local data = reader.getBlockData()

    leverStatus()

    printStatus(data)

    mon.clear()
    mon.setTextColor(color)
    mon.setCursorPos(1, 1)
    mon.write(string.rep(" ", W))

    mon.setTextColor(colors.white)
    mon.setCursorPos(1, 2)
    mon.write("   Mana Farm")

    mon.setTextColor(color)
    mon.setCursorPos(1, 3)
    mon.write(string.rep(" ", W))


    sleep(coolDown)
end