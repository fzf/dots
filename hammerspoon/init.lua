-- Automatically Reload Config
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- custom Console toolbar (adds Clear button)
local toolbar = require("hs.webview.toolbar")
local console = require("hs.console")
local image = require("hs.image")
console.defaultToolbar = toolbar.new("CustomToolbar", {
    { id="prefs", label="Preferences", image=image.imageFromName("NSPreferencesGeneral"), tooltip="Open Preferences", fn=function() hs.openPreferences() end },
    { id="reload", label="Reload config", image=image.imageFromName("NSSynchronize"), tooltip="Reload configuration", fn=function() hs.reload() end },
    { id="openCfg", label="Open config", image=image.imageFromName("NSActionTemplate"), tooltip="Edit configuration", fn=function() openConfig() end },
    { id="clearLog", label="Clear", image = hs.image.imageFromName("NSTrashEmpty"), tooltip="Clear Console", fn=function() console.clearConsole() end },
    { id="help", label="Help", image=image.imageFromName("NSInfo"), tooltip="Open API docs browser", fn=function() hs.doc.hsdocs.help() end }
  }):canCustomize(true):autosaves(true)
console.toolbar(console.defaultToolbar)

function openConfig()
  hs.open(hs.configdir .. "/init.lua")
end

local logger = hs.logger.new("Global", "debug")

local function bindHotkeys(mod, bindings, fn)
  for hotkey, arg in pairs(bindings) do
    hs.hotkey.bind(mod, hotkey, function() fn(arg) end, nil, function() fn(arg) end)
  end
end

-- Window Animation Duration
hs.window.animationDuration = 0.000

-- Set Grid
hs.grid.setGrid('2x1')
hs.grid.setMargins({0, 0})

do
  local mod      = { "ctrl" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke(nil, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "shift" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({"shift"}, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "cmd" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({"cmd"}, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "option" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({"option"}, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "option", "shift" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({"option", "shift"}, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "cmd", "shift" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({"shift", "cmd", "shift"}, key, 1000)
  end)
end

-- tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
--   local keyCode = event:getKeyCode()
--   print(event:rawFlags())
-- end)
-- tap:start()

-- Bind Command + Escape to Command + `
hs.hotkey.bind({'cmd'},'escape', function() hs.eventtap.keyStroke({'cmd'}, '`', 1000) end)
hs.hotkey.bind({'ctrl'},'delete', function() hs.eventtap.keyStroke({}, 'forwarddelete', 1000) end)

hs.loadSpoon("AppBindings")
spoon.AppBindings:bind('Telegram', {
  { { 'cmd' }, 't', { 'cmd' }, 'k' }
})
-- spoon.AppBindings:bind('Arc', {
--   -- History
--   { { 'cmd', 'ctrl' }, 'h', { 'cmd' }, '[' },
--   { { 'cmd', 'ctrl' }, 't', { 'cmd' }, ']' },
--   -- Tabs
--   { { 'cmd', 'ctrl' }, 'd', { 'cmd', 'shift' }, '[' },
--   { { 'cmd', 'ctrl' }, 'n', { 'cmd', 'shift' }, ']' },
--   -- Split
--   { { 'option', 'cmd'}, 's', { 'ctrl', 'shift' }, '=' },
--   { { 'option', 'cmd'}, 'd', { 'ctrl', 'shift' }, '[' },
--   { { 'option', 'cmd'}, 'n', { 'ctrl', 'shift' }, ']' },
-- })

spoon.AppBindings:bind('Code', {
  -- History
  { { 'cmd', 'ctrl' }, 'h', { 'ctrl' }, '-' },
  { { 'cmd', 'ctrl' }, 't', { 'ctrl', 'shift' }, '-' },
  -- Tabs
  { { 'cmd', 'ctrl' }, 'd', { 'option', 'cmd' }, 'right' },
  { { 'cmd', 'ctrl' }, 'n', { 'option', 'cmd' }, 'left' },
  -- Split
  { { 'option', 'cmd'}, 's', { 'ctrl' }, 's' },
  { { 'option', 'cmd'}, 'd', { 'ctrl', 'shift' }, '[' },
  { { 'option', 'cmd'}, 'n', { 'ctrl', 'shift' }, ']' },
})
hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

-- local vimouse = require('vimouse')

-- vimouse('cmd', 'm')

-- hs.loadSpoon("RecursiveBinder")

-- spoon.RecursiveBinder.escapeKey = {{}, 'escape'}  -- Press escape to abort

-- local singleKey = spoon.RecursiveBinder.singleKey

-- local keyMap = {
--   [singleKey('w', 'window')] = {
--     [singleKey('s', 'split')] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '=', 200)
--       end
--     end,
--     [singleKey('q', 'close')] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '-', 200)
--       end
--     end,
--     [singleKey('d', 'last')] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '[', 200)
--       end
--     end,
--     [singleKey('n', 'next')] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ 'ctrl', 'shift' }, ']', 200)
--       end
--     end
--   }
-- }

-- hs.hotkey.bind({'cmd'}, 'e', spoon.RecursiveBinder.recursiveBind(keyMap))

-- Window Movement and Sizing (Fixed)
-- do
--   local Size     = require 'size'
--   local mod      = { "option", "ctrl" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "c" ] = "full"
--   }

--   bindHotkeys(mod, bindings, function(direction)
--     Size.moveLocation(direction)
--   end)
-- end

-- Applications
-- To disable the MacOSX's dictionary hotkey (cmd-ctrl-d),
-- make sure to run in terminal:
-- defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
-- do
--   local mod      = { "option", "ctrl" }
--   local bindings = {
--     [ "t" ] = "iTerm",
--     [ "h" ] = "Arc",
--     [ "v" ] = "Visual Studio Code",
--     [ "u" ] = "Obsidian",
--     [ "s" ] = "Slack",
--   }

--   bindHotkeys(mod, bindings, function(app)
--     hs.application.launchOrFocus(app)
--   end)
-- end

modal = hs.hotkey.modal.new()

function binder(mods, key, fn, mm)
	local function triggerAndCall()
	    modal.triggered = true
      fn()
  	end
	modal:bind({}, key, triggerAndCall, nil, triggerAndCall)
end

modifier = hs.hotkey.bind({}, "tab",
  function()
    modal:enter()
    modal.triggered = false
  end,
  function()
    modal:exit()
    if not modal.triggered then
      modifier:disable()
      hs.eventtap.keyStroke({}, "tab")
      hs.timer.doAfter(0.1, function() modifier:enable() end)
    end
  end
)

local Size = require 'size'

local modal = hs.hotkey.modal.new()
binder(nil, "t", function() hs.application.launchOrFocus("iTerm") end, modal)
binder(nil, "h", function() hs.application.launchOrFocus("Arc") end, modal)
binder(nil, "v", function() hs.application.launchOrFocus("Visual Studio Code") end, modal)
binder(nil, "d", function() Size.moveLocation('left') end, modal)
binder(nil, "n", function() Size.moveLocation('right') end, modal)
binder(nil, "c", function() Size.moveLocation('full') end, modal)

