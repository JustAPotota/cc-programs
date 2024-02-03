local M = {}

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

return M
