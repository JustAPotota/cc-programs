local M = {}

local CLICK_LEFT = 1
local CLICK_RIGHT = 2
local CLICK_MIDDLE = 3

---@class UI
---@field focus number
---@field focus_taken boolean
local UI = {}

---@return UI
local function new_ui()
    return setmetatable({ focus = 0 }, { __index = UI })
end

local function component_id()
    return debug.getinfo(3, "l").currentline
end

---@param draw fun(ui: UI): boolean?
function M.run(draw)
    local normal_background_color = term.getBackgroundColor()

    local ui = new_ui()
    term.clear()
    term.setCursorPos(1, 1)
    draw(ui)
    while true do
        term.setCursorPos(1, 1)
        local event_data = { os.pullEventRaw() }
        local event_name = table.remove(event_data, 1)

        if event_name == "terminate" then
            term.setBackgroundColor(normal_background_color)
            term.clear()
            error()
        end

        ui:__set_event(event_name, event_data)

        term.clear()
        if draw(ui) then
            break
        end

        if event_name == "mouse_click" and not ui.focus_taken then
            ui.focus = 0
        end
        ui.focus_taken = false
    end

    term.setBackgroundColor(normal_background_color)
end

---@param name string
---@param data table
function UI:__set_event(name, data)
    self.event_name = name
    self.event_data = data
end

function UI:new_line()
    local _, y = term.getCursorPos()
    term.setCursorPos(1, y + 1)
end

function UI:label(text)
    term.write(text)
    self:new_line()
end

---Sets the terminal background color and returns the previous color
---@param color number?
---@return number previous_color
function UI:background_color(color)
    local previous_color = term.getBackgroundColor()
    term.setBackgroundColor(color)
    return previous_color
end

---@param text string
---@param width number
---@return string
local function fitted_text(text, width)
    if #text > width then
        return text:sub(-width)
    elseif #text < width then
        return text .. (" "):rep(width - #text)
    else
        return text
    end
end

---@param point_x number
---@param point_y number
---@param rectangle_x number
---@param rectangle_y number
---@param width number
---@param height number
---@return boolean
local function point_in_rectangle(point_x, point_y, rectangle_x, rectangle_y, width, height)
    return point_x >= rectangle_x and point_x < rectangle_x + width and
        point_y >= rectangle_y and point_y < rectangle_y + height
end

---@param text string
---@param size number
---@return string new_text, boolean changed
function UI:text_input(text, size)
    local id = component_id()

    local focused = false
    local new_text = text
    if self.focus == id then
        focused = true
        if self.event_name == "char" and type(self.event_data[1]) == "string" then
            local new_char = self.event_data[1]
            new_text = text .. new_char
        elseif self.event_name == "key" and self.event_data[1] == keys.backspace then
            new_text = text:sub(1, -2)
        end
    elseif self.event_name == "mouse_click" then
        local cursor_x, cursor_y = term.getCursorPos()
        local click_x, click_y = self.event_data[2], self.event_data[3]
        if point_in_rectangle(click_x, click_y, cursor_x, cursor_y, size, 1) then
            self.focus = id
            self.focus_taken = true
            focused = true
        end
    end

    local previous_bg_color = self:background_color(colors.black)
    term.write(fitted_text(new_text .. (focused and "_" or ""), size))
    self:background_color(previous_bg_color)
    self:new_line()

    return new_text, new_text ~= text
end

---@param draw fun(ui: UI): boolean?
---@return boolean?
function UI:same_line(draw)
    self.new_line = function(self)
        term.write(" ")
    end

    local output = draw(self)

    self.new_line = UI.new_line
    self:new_line()

    return output
end

local function is_module()
    return pcall(debug.getlocal, 4, 1)
end

if is_module() then
    return M
end

local args = { ... }
if args[1] == "update" then
    print("Fetching latest version...")
    local response = http.get("https://raw.githubusercontent.com/JustAPotota/cc-programs/main/imtui.lua")
    if response then
        print("Reading...")
        local text = response.readAll()
        local file = fs.open(shell.getRunningProgram(), "w")
        if file then
            print("Saving...")
            file.write(text)
        end
    end
end
