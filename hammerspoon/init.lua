-- Automatically Reload Config
function reloadConfig(files) hs.reload() end
hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

local function bindHotkeys(mod, bindings, fn)
  for hotkey, arg in pairs(bindings) do
    hs.hotkey.bind(mod, hotkey, function() fn(arg) end)
  end
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
    [ "h" ] = "bottom",
    [ "t" ] = "top",
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
