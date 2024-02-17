---@meta

function printError(...) end

peripheral = {}

---@alias peripheral table

---@param peripheral_type string
---@param predicate fun(name: string, wrapped: peripheral)?
---@return peripheral ...
function peripheral.find(peripheral_type, predicate) end

rednet = {}
function rednet.open(modem) end

---@return boolean
function rednet.isOpen() end

term = {}

---@param text string
function term.write(text) end

function term.clear() end

---@param x number
---@param y number
function term.setCursorPos(x, y) end

---@return number
function term.getBackgroundColor() end

---@param color number
function term.setBackgroundColor(color) end

---@return number x, number y
function term.getCursorPos() end

colors = {}
colors.gray = 0x80
colors.black = 0x8000