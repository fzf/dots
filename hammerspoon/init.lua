require "install"
knu = hs.loadSpoon("Knu")

-- Enable auto-restart when any of the *.lua files under ~/.hammerspoon/ is modified
knu.runtime.autorestart(true)

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
hs.grid.setGrid("2x1")
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
    hs.eventtap.keyStroke({ "shift" }, key, 1000)
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
    hs.eventtap.keyStroke({ "option" }, key, 1000)
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
    hs.eventtap.keyStroke({ "cmd" }, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "shift", "option" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({ "shift", "option" }, key, 1000)
  end)
end

do
  local mod      = { "ctrl", "shift", "cmd" }
  local bindings = {
    [ "d" ] = "left",
    [ "n" ] = "right",
    [ "h" ] = "down",
    [ "t" ] = "up"
  }

  bindHotkeys(mod, bindings, function(key)
    hs.eventtap.keyStroke({ "shift", "cmd" }, key, 1000)
  end)
end

-- Logging keycodes
-- tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
--   local keyCode = event:getKeyCode()
--   print(event:rawFlags())
--   print(keyCode)
-- end)
-- tap:start()

-- Bind Command + Escape to Command + `
hs.hotkey.bind({ "cmd" }, "escape", function() hs.eventtap.keyStroke({ "cmd" }, "`", 1000) end)
hs.hotkey.bind({ "ctrl" }, "delete", function() hs.eventtap.keyStroke(nil, "forwarddelete", 1000) end, nil, function() hs.eventtap.keyStroke({}, "forwarddelete", 1000) end)

-- osascript -e 'id of app "Finder"'
knu.keymap.register(
  "us.zoom.xos",
  knu.keymap.new(
    hs.hotkey.new({ "cmd", "alt" }, "d", function ()
      hs.eventtap.keyStroke({ "cmd", "shift" }, "h", 1000)
    end)
  )
)

knu.keymap.register(
  "ru.keepcoder.Telegram",
  -- Quick Open
  hs.hotkey.new({ "cmd" }, "p", function ()
    hs.eventtap.keyStroke({ "cmd" }, "k", 1000)
  end)
)

knu.keymap.register(
  "company.thebrowser.Browser",
  knu.keymap.new(
    -- Forward
    hs.hotkey.new({ "cmd" }, "t", function ()
      hs.eventtap.keyStroke({ "cmd" }, "]", 1000)
    end),
    -- Back
    hs.hotkey.new({ "cmd" }, "h", function ()
      hs.eventtap.keyStroke({ "cmd" }, "[", 1000)
    end),
    -- Next Tab
    hs.hotkey.new({ "cmd" }, "d", function ()
      hs.eventtap.keyStroke({ "shift", "cmd" }, "[", 1000)
    end),
    -- Previous Tab
    hs.hotkey.new({ "cmd" }, "n", function ()
      hs.eventtap.keyStroke({ "shift", "cmd" }, "]", 1000)
    end),
    -- Split
    hs.hotkey.new({ "alt", "cmd" }, "s", function ()
      hs.eventtap.keyStroke({ "ctrl", "shift" }, "=", 1000)
    end),
    -- Left Split
    hs.hotkey.new({ "alt", "cmd" }, "h", function ()
      hs.eventtap.keyStroke({ "ctrl", "shift" }, "[", 1000)
    end),
    -- Right Split
    hs.hotkey.new({ "alt", "cmd" }, "t", function ()
      hs.eventtap.keyStroke({ "ctrl", "shift" }, "]", 1000)
    end),
    -- Close Left Drawer
    hs.hotkey.new({ "ctrl", "alt", "cmd" }, "d", function ()
      hs.eventtap.keyStroke({ "cmd" }, "s", 1000)
    end)
  )
)

knu.keymap.register(
  "com.microsoft.VSCode",
  knu.keymap.new(
    -- Forward
    hs.hotkey.new({ "cmd", "shift" }, "t", function ()
      hs.eventtap.keyStroke({ "ctrl" }, "-", 1000)
    end),
    -- Back
    hs.hotkey.new({ "cmd", "shift" }, "h", function ()
      hs.eventtap.keyStroke({ "ctrl", "shift" }, "-", 1000)
    end),
    -- Next Tab
    hs.hotkey.new({ "cmd", "shift" }, "d", function ()
      hs.eventtap.keyStroke({ "cmd", "shift" }, "[", 1000)
    end),
    -- Previous Tab
    hs.hotkey.new({ "cmd", "shift" }, "n", function ()
      hs.eventtap.keyStroke({ "cmd", "shift" }, "]", 1000)
    end),
    -- Split
    hs.hotkey.new({ "alt", "cmd" }, "s", function ()
      hs.eventtap.keyStroke({ "cmd" }, "\\", 1000)
    end),
    hs.hotkey.new({ "alt", "cmd" }, "d", function ()
      hs.eventtap.keyStroke({ "cmd" }, "k", 1000)
      hs.eventtap.keyStroke({ "cmd" }, "left", 1000)
    end),
    hs.hotkey.new({ "alt", "cmd" }, "n", function ()
      hs.eventtap.keyStroke({ "cmd" }, "k", 1000)
      hs.eventtap.keyStroke({ "cmd" }, "right", 1000)
    end),
    hs.hotkey.new({ "alt", "cmd" }, "h", function ()
      hs.eventtap.keyStroke({ "cmd", "ctrl" }, "left", 1000)
    end),
    hs.hotkey.new({ "alt", "cmd" }, "t", function ()
      hs.eventtap.keyStroke({ "cmd", "ctrl" }, "right", 1000)
    end),
    hs.hotkey.new({ "ctrl", "alt", "cmd" }, "d", function ()
      hs.eventtap.keyStroke({ "cmd" }, "b", 1000)
    end)
  )
)

hs.loadSpoon("ControlEscape"):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

-- hs.loadSpoon("RecursiveBinder")

-- spoon.RecursiveBinder.escapeKey = {{}, "escape" }  -- Press escape to abort

-- local singleKey = spoon.RecursiveBinder.singleKey

-- local keyMap = {
--   [singleKey("w", "window")] = {
--     [singleKey("s", "split")] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ "ctrl", "shift" }, "=", 200)
--       end
--     end,
--     [singleKey("q", "close")] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ "ctrl", "shift" }, "-", 200)
--       end
--     end,
--     [singleKey("d", "last")] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ "ctrl", "shift" }, "[", 200)
--       end
--     end,
--     [singleKey("n", "next")] = function()
--       if hs.application.frontmostApplication():name() == "Arc" then
--         hs.eventtap.keyStroke({ "ctrl", "shift" }, "]", 200)
--       end
--     end
--   }
-- }

-- hs.hotkey.bind({ "cmd" }, "e", spoon.RecursiveBinder.recursiveBind(keyMap))

-- Window Movement and Sizing (Fixed)
-- do
--   local Size     = require "size"
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
-- To disable the MacOSX"s dictionary hotkey (cmd-ctrl-d),
-- make sure to run in terminal:
-- defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 "<dict><key>enabled</key><false/></dict>"
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

local Size = require "size"

local modal = hs.hotkey.modal.new()
binder(nil, "t", function()
  hs.alert.show("iTerm")
  hs.application.launchOrFocus("iTerm")
end, modal)
binder(nil, "h", function() hs.application.launchOrFocus("Arc") end, modal)
binder(nil, "v", function() hs.application.launchOrFocus("Visual Studio Code") end, modal)
binder(nil, "d", function() Size.moveLocation("left") end, modal)
binder(nil, "n", function() Size.moveLocation("right") end, modal)
binder(nil, "c", function() Size.moveLocation("full") end, modal)

