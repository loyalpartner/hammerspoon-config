hs.loadSpoon("SpoonInstall")
hs.loadSpoon("ReloadConfiguration")
Install=spoon.SpoonInstall

spoon.ReloadConfiguration:start()

hyper = { 'cmd','ctrl'}
win = {'cmd', 'option' }

require 'reload.reload'
require 'app.app'
require 'window.window'
require 'caffeinate.caffeinate'
require 'sheet.sheet'

hs.notify.new({title=".", informativeText="Kaikai, I am online!"}):send()

