hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

hyper = { 'cmd','ctrl'}
win = {'cmd', 'option' }

require 'reload.reload'
require 'app.app'
require 'window.window'
require 'caffeinate.caffeinate'
require 'sheet.sheet'

hs.notify.new({title=".", informativeText="Kaikai, I am online!"}):send()

