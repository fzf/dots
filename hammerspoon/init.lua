-- Automatically Reload Config
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

local logger = hs.logger.new("Global", "debug")

local function bindHotkeys(mod, bindings, fn)
  for hotkey, arg in pairs(bindings) do
    hs.hotkey.bind(mod, hotkey, function() fn(arg) end, nil, function() fn(arg) end)
  end
end

-- Applications
-- To disable the MacOSX's dictionary hotkey (cmd-ctrl-d),
-- make sure to run in terminal:
-- defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
do
  local mod      = { "option", "ctrl" }
  local bindings = {
    [ "t" ] = "iTerm",
    [ "h" ] = "Arc",
    [ "v" ] = "Visual Studio Code",
    [ "u" ] = "Obsidian",
    [ "s" ] = "Slack",
  }

  bindHotkeys(mod, bindings, function(app)
    hs.application.launchOrFocus(app)
  end)
end

-- Window Animation Duration
hs.window.animationDuration = 0.000


-- Set Grid
hs.grid.setGrid('2x1')
hs.grid.setMargins({0, 0})

-- Window Movement and Sizing (Fixed)
do
  local Size     = require 'size'
  local mod      = { "option", "ctrl" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "c" ] = "full"
  }

  bindHotkeys(mod, bindings, function(direction)
    Size.moveLocation(direction)
  end)
end

do
  local mod      = { "ctrl" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke(mods, key, 1000)
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
spoon.AppBindings:bind('Vivaldi', {
  { { 'ctrl' }, 'h', { }, 'down' },
  { { 'ctrl' }, 't', { }, 'up' },
  -- Quick Commands
  { { 'cmd' }, 't', { 'cmd' }, 'e' },
  -- History
  { { 'cmd', 'ctrl' }, 'h', { 'cmd' }, 'left' },

  { { 'cmd', 'ctrl' }, 't', { 'cmd' }, 'right' },
  -- Tabs
  { { 'cmd', 'ctrl' }, 'd', { 'cmd', 'shift' }, '[' },
  { { 'cmd', 'ctrl' }, 'n', { 'cmd', 'shift' }, ']' },
})

hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

-- local vimouse = require('vimouse')

-- vimouse('cmd', 'm')

hs.loadSpoon("RecursiveBinder")

spoon.RecursiveBinder.escapeKey = {{}, 'escape'}  -- Press escape to abort

local singleKey = spoon.RecursiveBinder.singleKey

local keyMap = {
  [singleKey('w', 'window')] = {
    [singleKey('s', 'split')] = function()
      if hs.application.frontmostApplication():name() == "Arc" then
        hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '=', 200)
      end
    end,
    [singleKey('x', 'close')] = function()
      if hs.application.frontmostApplication():name() == "Arc" then
        hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '-', 200)
      end
    end,
    [singleKey('d', 'last')] = function()
      if hs.application.frontmostApplication():name() == "Arc" then
        hs.eventtap.keyStroke({ 'ctrl', 'shift' }, '[', 200)
      end
    end,
    [singleKey('n', 'next')] = function()
      if hs.application.frontmostApplication():name() == "Arc" then
        hs.eventtap.keyStroke({ 'ctrl', 'shift' }, ']', 200)
      end
    end
  }
}

hs.hotkey.bind({'option'}, 'space', spoon.RecursiveBinder.recursiveBind(keyMap))
