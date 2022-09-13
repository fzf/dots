-- Automatically Reload Config
function reloadConfig(files) hs.reload() end
hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

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


-- Bind Command + Escape to Command + `
hs.hotkey.bind({'cmd'},'escape', function() hs.eventtap.keyStroke({'cmd'}, '`') end)
hs.hotkey.bind({'ctrl'},'delete', function() hs.eventtap.keyStroke({}, 'forwarddelete') end)

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
