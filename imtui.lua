local M = {}

local function new_ui()
    return {}
end

function M.run(draw)
    local ui = new_ui()
    draw(ui)
    while true do
        local event_data = { os.pullEvent() }
        local event_name = event_data[1]

        term.clear()
        draw(ui)
    end
end

local ui = {}

function ui:new_line()
    term.write("\n")
end

function ui:label(text)
    term.write(text)
    self:new_line()
end

---@param text string
---@param size number
function ui:text_input(text, size)

end

local function is_module()
    return pcall(debug.getlocal, 4, 1)
end

if is_module() then
    return M
end

local args = { ... }
if args[1] == "update" then
    local response = http.get("https://raw.githubusercontent.com/JustAPotota/cc-programs/main/imtui.lua")
    if response then
        local text = response.readAll()
        local file = fs.open(shell.getRunningProgram(), "w")
        if file then
            file.write(text)
        end
    end
end
