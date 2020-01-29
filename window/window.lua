hs.loadSpoon("WindowGrid")
hs.loadSpoon("WindowHalfsAndThirds")

local win = {'cmd', 'option' }
local hyper = { 'cmd','ctrl'}
local hotkey = require 'hs.hotkey'
local layout = require 'hs.layout'
local window = require 'hs.window'

moveToScreen = function(win, n, showNotify)
    local screens = hs.screen.allScreens()
    if n > #screens then
        if showNotify then
            hs.alert.show("No enough screens " .. #screens)
        end
    else
        local toScreen = hs.screen.allScreens()[n]:name()
        if showNotify then
            hs.alert.show("Move " .. win:application():name() .. " to " .. toScreen)
        end
        hs.layout.apply({{nil, win:title(), toScreen, hs.layout.maximized, nil, nil}})
    end
end

function resizeToCenter()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local winScale = 0.7

    f.x = max.x + (max.w * (1 - winScale) / 2)
    f.y = max.y + (max.h * (1 - winScale) / 2)
    f.w = max.w * winScale
    f.h = max.h * winScale
    win:setFrame(f)
end


-- Move application to screen.
hs.hotkey.bind(hyper, "1", function() moveToScreen(hs.window.focusedWindow(), 1, true) end)
hs.hotkey.bind(hyper, "2", function() moveToScreen(hs.window.focusedWindow(), 2, true) end)
-- Window operations.
hs.hotkey.bind(win, "1", function() window.focusedWindow():moveToUnit(layout.left50) end)
hs.hotkey.bind(win, "2", function() window.focusedWindow():moveToUnit(layout.right50) end)
hs.hotkey.bind(win, '4', resizeToCenter)
hs.hotkey.bind(win, "5", function() window.focusedWindow():toggleFullScreen() end)

Install:andUse("WindowHalfsAndThirds", {config = {use_frame_correctness = true}, hotkeys = {max_toggle = {win, "3"}}})
Install:andUse("WindowGrid", {config = {gridGeometries = {{"6x4"}}}, hotkeys = {show_grid = {hyper, ","}}, start = true})
