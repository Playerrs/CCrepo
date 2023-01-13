local version = "1.3"

function serialize(data, name)
    if not fs.exists('SS/data') then
        fs.makeDir('SS/data')
    end
    local f = fs.open('SS/data/'..name, 'w')
    f.write(textutils.serialize(data))
    f.close()
end
serialize(version, ".versionMenus")

local pathManager
if fs.exists("/SS/API/Manager.lua") then
    pathManager = "/SS/API/Manager.lua"
else
    if not fs.exists("/API/Manager.lua") then
        error('Menus.lua tried to loadAPI "Manager.lua" and did not find the file')
    end
    pathManager = "/API/Manager.lua"
end

os.loadAPI(pathManager)
local api = Manager
local W,H = term.getSize()


MenuItem = {}

function MenuItem:new(atributes)
    local instance = {
        name,
        id,
        item,
        MaxItems
    }
    setmetatable(instance, { __index = self })

    if atributes then
        if atributes.name then
            instance.name = atributes.name
        end
        if atributes.id then
            instance.id = atributes.id
        end
        if atributes.item then
            for i = 1, #atributes.item do
                instance.item = atributes.item
            end
        end
    end

    return instance
end

function MenuItem:run(index, arg)
    local maxItemSelectables = 0
    for i = 1, #self.item do
        if self.item[i].selectable then
            maxItemSelectables = maxItemSelectables + 1
            self.MaxItems = maxItemSelectables
        end
    end
    if arg or arg == nil then
        api.reset()
    end
    local selectable = 0
    for i = 1, #self.item do
        if self.item[i].list then
            api.printMultiLines(self.item[i].name, self.item[i].ypos)
        else
            if self.item[i].print == "left" then
                if self.item[i].selectable then
                    selectable = selectable + 1
                    if self.item[i].idtoselect == nil then
                        self.item[i].idtoselect = selectable
                        api.printLeft(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    else
                        api.printLeft(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    end
                else
                    api.printLeft(self.item[i].name, self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                end
            end
            if self.item[i].print == "center" or self.item[i].print == nil then
                if self.item[i].selectable then
                    selectable = selectable + 1
                    if self.item[i].idtoselect == nil then
                        self.item[i].idtoselect = selectable
                        api.printCenter(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    else
                        api.printCenter(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    end
                else
                    api.printCenter(self.item[i].name, self.item[i].clearLine, self.item[i].ypos, self.item[i].color,  self.item[i].bgcolor)
                end
            end
            if self.item[i].print == "right" then
                if self.item[i].selectable then
                    selectable = selectable + 1
                    if self.item[i].idtoselect == nil then
                        self.item[i].idtoselect = selectable
                        api.printRight(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    else
                        api.printRight(api.isSelected(self.item[i].name, selectable, index), self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                    end
                else
                    api.printRight(self.item[i].name, self.item[i].clearLine, self.item[i].ypos, self.item[i].color)
                end
            end
        end
    end
end

function MenuItem:getName()
    return self.name
end

function MenuItem:setName(value)
    self.name = value
    return self.name
end

function MenuItem:getItem(x)
    if x then
        return self.item[x]
    else
        return self.item
    end
end

function MenuItem:setItem(value)
    if self.item then
        table.insert(self.item, #self.item+1, value)
    else
        self.item = value
    end
end

function MenuItem:getID()
    return self.id
end

function MenuItem:setID(value)
    self.id = value
    return self.id
end

function MenuItem:getItemID(numItem)
    return self.item[numItem].idtoselect
end

function MenuItem:setItemID(numItem, id)
    self.item[numItem].idtoselect = id
    return self.item[numItem].idtoselect
end

function MenuItem:getMaxItems()
    return self.MaxItems
end

function MenuItem:setMaxItems(value)
    self.MaxItems = value
    return self.MaxItems
end

function MenuItem:getAction(numItem) ---doesn't work yet
return self.item[numItem].action
end

function MenuItem:removeAction(numItem, toDel)
    if toDel then
        self.item[numItem].action[toDel] = nil
    else
        self.item[numItem].action = nil
    end
end

function MenuItem:setAction(numItem, action)
    if self.item[numItem].selectable then
        self.item[numItem].action = action
    else
        error('This item "'.. self.item[numItem].name .. '" is not selectable!')
    end
    return self.item[numItem].action
end

function MenuItem:runAction(arg, arg2)
    local selected = 1
    while true do
        local v = api.getInputKey(self.MaxItems, selected)
        if type(v) == "number" then
            self:run(v)
            selected = v
        elseif v == "enter" then
            for i=1, #self.item do
                if self.item[i].idtoselect then
                    if string.find(selected, self.item[i].idtoselect) then
                        if self.item[i].action then
                            api.reset()
                            return self.item[i].action(arg, arg2)
                        else
                            error('Item "'..self.item[i].name..'" has no action defined')
                        end
                    end
                end
            end
        end
    end
end

return MenuItem