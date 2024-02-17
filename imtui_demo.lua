local imtui = require("imtui")

local my_text = ""
local my_text2 = ""
imtui.run(function(ui)
    ui:background_color(colors.gray)

    ui:same_line(function(ui)
        ui:label("◖woohoo▌")
        my_text = ui:text_input(my_text, 10)
    end)
    ui:same_line(function(ui)
        ui:label("woohoo")
        my_text2 = ui:text_input(my_text2, 10)
    end)
end)
