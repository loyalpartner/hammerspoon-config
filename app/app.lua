local hyper = { 'cmd','ctrl'}
local win = {'cmd', 'option' }
local application = require 'hs.application'
local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local event = require 'hs.eventtap.event'
local fs = require 'hs.fs'
local hints = require 'hs.hints'

-- Init.
hs.window.animationDuration = 0 -- don't waste time on animation when resize window

-- Key to launch application.
local key2App = {
   n = {'/Applications/iTerm.app', 'English', 2},
   t = {'/Applications/Microsoft Edge.app', 'English', 1},
   h = {'/Applications/Emacs.app', 'English', 2},
   l = {'/System/Library/CoreServices/Finder.app', 'English', 1},
   -- f = {'/Applications/Chromium.app', 'English', 1},
   k = {'/Applications/Kindle.app', 'English', 2},
   w = {'/Applications/WeChat.app', 'Chinese', 1},
   -- e = {'/Users/andy/fast-photo/node_modules/electron/dist/Electron.app', 'Chinese', 1},
   -- a = {'/Applications/wechatwebdevtools.app', 'English', 2},
   d = {'/Applications/Dash.app', 'English', 1},
   -- s = {'x-apple.systempreferences:', 'English', 1},
   p = {'/Applications/Preview.app', 'Chinese', 2},
   -- b = {'/Applications/MindNode.app', 'Chinese', 1},
   -- j = {'/Applications/NeteaseMusic.app', 'Chinese', 1},
   m = {'/Applications/虾米音乐.app', 'English', 2},
}

-- Show launch application's keystroke.
local showAppKeystrokeAlertId = ""
local function showAppKeystroke()
    if showAppKeystrokeAlertId == "" then
        -- Show application keystroke if alert id is empty.
        local keystroke = ""
        local keystrokeString = ""
        for key, app in pairs(key2App) do
            keystrokeString = string.format("%-10s%s", key:upper(), app[1]:match("^.+/(.+)$"):gsub(".app", ""))
            if keystroke == "" then
                keystroke = keystrokeString
            else
                keystroke = keystroke .. "\n" .. keystrokeString
            end
        end

        showAppKeystrokeAlertId = hs.alert.show(keystroke, hs.alert.defaultStyle, hs.screen.mainScreen(), 10)
    else
        -- Otherwise hide keystroke alert.
        hs.alert.closeSpecific(showAppKeystrokeAlertId)
        showAppKeystrokeAlertId = ""
    end
end

-- Manage application's inputmethod status.
local function Chinese()
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.Dvorak")
end

function updateFocusAppInputMethod()
    for key, app in pairs(key2App) do
        local appPath = app[1]
        local inputmethod = app[2]

        if window.focusedWindow():application():path() == appPath then
            if inputmethod == 'English' then
                English()
            else
                Chinese()
            end

            break
        end
    end
end

function findApplication(appPath)
    local apps = application.runningApplications()
    for i = 1, #apps do
        local app = apps[i]
        if app:path() == fs.pathToAbsolute(appPath) then
            return app
        end
    end

    return nil
end

function launchApp(appPath)
  application.launchOrFocus(appPath)
end

keyStroke = function(modifiers, character)
    event.newKeyEvent(modifiers, string.lower(character), true):post()
    event.newKeyEvent(modifiers, string.lower(character), false):post()
end

-- Toggle an application between being the frontmost app, and being hidden
function toggleApplication(app)
    local appPath = app[1]
    local inputMethod = app[2]

    -- Tag app path use for `applicationWatcher'.
    -- startAppPath = appPath

    local app = findApplication(appPath)
    local setInputMethod = true

    if not app then
        -- Application not running, launch app
        launchApp(appPath)
    else
        -- Application running, toggle hide/unhide
        -- application:activate(application:allWindows())

        local winnum = #app:allWindows()
        local mainwin = app:mainWindow()
        if hs.application.frontmostApplication() == app then
            -- hs.window.switcher.new{app:name()}:nextWindow()
            if app:name() == "Emacs" then
                keyStroke({'option'}, '`')
            else
                keyStroke({'cmd'}, '`')
            end
        elseif mainwin then
            if app:isFrontmost() then
                setInputMethod = false
            else
                -- Focus target application if it not at frontmost.
                mainwin:application():activate(true)
                mainwin:application():unhide()
                mainwin:focus()
            end
        else
            if app:hide() then
                launchApp(appPath)
            end
        end
    end

    if setInputMethod then
        if inputMethod == 'English' then
            English()
        else
            Chinese()
        end
    end
end


hs.hotkey.bind(hyper, "z", showAppKeystroke)
hs.hotkey.bind(hyper, "s", function() hs.execute("open 'x-apple.systempreferences:'") end)
hotkey.bind(hyper, '/', function() hs.hints.windowHints() end)
hs.hotkey.bind(hyper, ".",
    function() hs.alert.show(string.format("App path:        %s\nApp name:      %s\nIM source id:  %s",
                                    window.focusedWindow():application():path(),
                                    window.focusedWindow():application():name(),
                                    hs.keycodes.currentSourceID())) end)
hs.hotkey.bind(hyper, ";", function()
        window.focusedWindow():close()
        hs.window.frontmostWindow():focus() end)
hs.hotkey.bind(hyper, "-", function() hs.application.frontmostApplication():kill() end)
local function killSip() hs.execute("killall Sip") end
hs.hotkey.bind(hyper, "v", killSip)

-- Start or focus application.
for key, app in pairs(key2App) do
    hotkey.bind(
        hyper, key,
        function()
            toggleApplication(app)
    end)
end
