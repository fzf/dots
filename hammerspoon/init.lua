-- Automatically Reload Config
function reloadConfig(files) hs.reload() end
hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

local function bindHotkeys(mod, bindings, fn)
  for hotkey, arg in pairs(bindings) do
    hs.hotkey.bind(mod, hotkey, function() fn(arg) end)
  end
end

-- Applications
-- To disable the MacOSX's dictionary hotkey (cmd-ctrl-d),
-- make sure to run in terminal:
-- defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
do
  local mod      = { "cmd", "ctrl" }
  local bindings = {
    [ "t" ] = "iTerm",
    [ "h" ] = "qutebrowser",
    [ "v" ] = "Visual Studio Code",
  }

  bindHotkeys(mod, bindings, function(app)
    hs.application.launchOrFocus(app)
  end)
end

-- Window Animation Duration
hs.window.animationDuration = 0.000

-- Window Movement and Sizing (Fixed)
do
  local Size     = require 'size'
  local mod      = { "cmd", "ctrl" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "c" ] = "full"
  }

  bindHotkeys(mod, bindings, function(location)
    Size[location]()
  end)
end

-- Window Movement (Relative)
do
  local Size     = require 'size'
  local mod      = { "cmd", "ctrl", "shift" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(direction)
    Size.moveLocation(direction)
  end)
end

slackSearch = hs.hotkey.new({'ctrl'}, 'p', function() hs.eventtap.keyStroke({"cmd"}, "t") end)

hs.window.filter.new('Slack')
  :subscribe(hs.window.filter.windowFocused,function() slackSearch:enable() end)
  :subscribe(hs.window.filter.windowUnfocused,function() slackSearch:disable() end)

hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

local vimouse = require('vimouse')
vimouse('cmd', 'm')
