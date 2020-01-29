hs.loadSpoon("KSheet")

local hyper = { 'cmd','ctrl'}

local ksheetIsShow = false
local ksheetAppPath = ""

hs.hotkey.bind(
    hyper, "R",
    function ()
        local currentAppPath = hs.window.focusedWindow():application():path()

        -- Toggle ksheet window if cache path equal current app path.
        if ksheetAppPath == currentAppPath then
            if ksheetIsShow then
                spoon.KSheet:hide()
                ksheetIsShow = false
            else
                spoon.KSheet:show()
                ksheetIsShow = true
            end
            -- Show app's keystroke if cache path not equal current app path.
        else
            spoon.KSheet:show()
            ksheetIsShow = true

            ksheetAppPath = currentAppPath
        end
end)
