local function getTardis()
    return peripheral.find("vortexmod:vortex_interface_be")
end

---@return boolean
local function openRednet()
    peripheral.find("modem", rednet.open)
    return rednet.isOpen()
end

---@return string?
local function getHostname()
    local file = io.open("hostname")
    if not file then
        return
    end

    local hostname = file:read("a")
    file:close()

    return hostname
end

---@param hostname string
local function setHostname(hostname)
    local file = io.open("hostname", "w")
    if file then
        file:write(hostname)
        file:close()
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

local x_textfield = ui:addTextfield():setPosition(1, 1)
local y_textfield = ui:addTextfield():setPosition(1, 2)
local z_textfield = ui:addTextfield():setPosition(1, 3)

basalt.autoUpdate()
