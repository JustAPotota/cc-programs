local function getTardis()
    return peripheral.find("vortexmod:vortex_interface_be")
end

---@return boolean
local function openRednet()
    peripheral.find("modem", rednet.open)
    return rednet.isOpen()
end

---@return string?
local function readHostname()
    local file = io.open("hostname")
    if not file then
        return
    end

    local hostname = file:read("a")
    file:close()

    return hostname
end

---@param hostname string
local function writeHostname(hostname)
    local file = io.open("hostname", "w")
    if file then
        file:write(hostname)
        file:close()
    end
end

---@param x string|number
---@param y string|number
---@param z string|number
---@return string
local function toCoordString(x, y, z)
    local x, y, z = tostring(x), tostring(y), tostring(z)
    return ("%s %s %s"):format(x, y, z)
end

local function addDimensions(dropdown)
    local dimensions = { "overworld", "the_nether", "the_end" }
    for _, dimension in ipairs(dimensions) do
        dropdown:addItem(dimension)
    end
end

local tardis = getTardis()
if not tardis then
    printError("Computer must be placed next to the Vortex Interface")
    return
end

if not openRednet() then
    printError("Unable to open rednet. Make sure there is a wireless or ender modem connected to this computer")
end


local basalt = require("basalt")

local ui = basalt.createFrame()

local button = ui:addButton():setPosition(4, 4):setSize(16, 3):setText("Click me!")
button:onClick(function()
    basalt.debug("Clicked")
end)

local x_label = ui:addLabel():setText("X:"):setPosition(1, 1)
local y_label = ui:addLabel():setText("Y:"):setPosition(1, 2)
local z_label = ui:addLabel():setText("Z:"):setPosition(1, 3)
local x_input = ui:addInput():setSize(10, 1):setPosition(3, 1):setInputType("number")
local y_input = ui:addInput():setSize(10, 1):setPosition(3, 2):setInputType("number")
local z_input = ui:addInput():setSize(10, 1):setPosition(3, 3):setInputType("number")

local dimension_label = ui:addLabel():setText("Dimension:"):setPosition(1, 4)
local dimension_selection = ui:addDropdown():setPosition(11, 4)
addDimensions(dimension_selection)

basalt.autoUpdate()
