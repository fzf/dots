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
  hs.open(hs.configdir .. "/keymaps.lua")  -- open the config, not the engine
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

-- ── Load keymap config ────────────────────────────────────────────────────
local km = require("keymaps")

-- ── Engine: Caps Lock → Ctrl/Esc + movement keys ──────────────────────────
-- NOTE: CapsLock must be remapped to Control via System Settings:
--   Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock: ^ Control
--
-- A single pair of eventtaps handles both behaviours from km.capslock / km.movement,
-- sharing state to ensure any keypress cancels the pending escape.
local sendingProgrammatically = false  -- Global flag to prevent canceling escape

local function startCtrlEscAndMove()
  local cfg     = km.capslock or {}
  local timeout = (cfg.tap_timeout_ms or 150) / 1000

  local sendEscape = false
  local lastCtrl   = false

  local timer = hs.timer.delayed.new(timeout, function()
    sendEscape = false
  end)

  -- Build keycode → arrow direction lookup from km.movement
  local arrowMap = {}
  for _, entry in ipairs(km.movement or {}) do
    local code = hs.keycodes.map[entry.from]
    if code then arrowMap[code] = entry.to end
  end

  local modTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local mods    = event:getFlags()
    local ctrlNow = mods.ctrl or false

    if ctrlNow == lastCtrl then return false end

    if ctrlNow then
      lastCtrl   = true
      sendEscape = true
      timer:start()
    else
      lastCtrl = false
      timer:stop()
      if sendEscape then
        sendingProgrammatically = true
        hs.eventtap.keyStroke({}, "escape", 0)
        sendingProgrammatically = false
      end
      sendEscape = false
    end
    return false
  end)

  local keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- Ignore programmatically-sent keystrokes entirely
    if sendingProgrammatically then
      return false
    end

    local flags = event:getFlags()
    sendEscape = false   -- any real keypress cancels pending escape

    if flags.ctrl then
      local arrow = arrowMap[event:getKeyCode()]
      if arrow then
        -- Build modifier list, excluding ctrl
        local pass = {}
        if flags.shift then table.insert(pass, "shift") end
        if flags.alt   then table.insert(pass, "alt")   end
        if flags.cmd   then table.insert(pass, "cmd")   end
        sendingProgrammatically = true
        hs.eventtap.keyStroke(pass, arrow, 0)
        sendingProgrammatically = false
        return true   -- consume ctrl+hjkl; emit arrow instead
      end
    end
    return false
  end)

  modTap:start()
  keyTap:start()
end

startCtrlEscAndMove()

-- ── Engine: per-app remaps ────────────────────────────────────────────────
-- Enables/disables app-specific hotkeys based on frontmost application
local function startAppRemaps()
  local appHotkeys = {}  -- { appName = { [hotkey objects] } }
  local currentAppHotkeys = {}  -- Currently active hotkeys

  -- Build hotkeys for each app
  for _, appEntry in ipairs(km.apps or {}) do
    local hotkeys = {}
    for _, binding in ipairs(appEntry.bindings) do
      local fromMods, fromKey = binding.from[1], binding.from[2]
      local toMods, toKey = binding.to[1], binding.to[2]

      local hotkey = hs.hotkey.new(fromMods, fromKey, function()
        -- Temporarily disable all hotkeys to prevent catching our own output
        for _, hk in ipairs(currentAppHotkeys) do
          hk:disable()
        end

        -- Send the keystroke
        sendingProgrammatically = true
        hs.eventtap.keyStroke(toMods, toKey, 0)
        sendingProgrammatically = false

        -- Re-enable hotkeys after a brief delay
        hs.timer.doAfter(0.01, function()
          for _, hk in ipairs(currentAppHotkeys) do
            hk:enable()
          end
        end)
      end)
      table.insert(hotkeys, hotkey)
    end
    appHotkeys[appEntry.app] = hotkeys
  end

  -- Enable hotkeys for current app, disable others
  local function updateHotkeys(appName)
    currentAppHotkeys = {}
    for app, hotkeys in pairs(appHotkeys) do
      for _, hotkey in ipairs(hotkeys) do
        if app == appName then
          hotkey:enable()
          table.insert(currentAppHotkeys, hotkey)
        else
          hotkey:disable()
        end
      end
    end
  end

  -- Watch for app changes
  local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
      updateHotkeys(appName)
    end
  end)
  appWatcher:start()

  -- Set up initial state
  local frontApp = hs.application.frontmostApplication()
  if frontApp then
    updateHotkeys(frontApp:name())
  end
end

startAppRemaps()

-- do
--   local mod      = { "ctrl" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke(nil, key, 1000)
--   end)
-- end

-- do
--   local mod      = { "ctrl", "shift" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke({ "shift" }, key, 1000)
--   end)
-- end

-- do
--   local mod      = { "ctrl", "option" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke({ "option" }, key, 1000)
--   end)
-- end

-- do
--   local mod      = { "ctrl", "cmd" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke({ "cmd" }, key, 1000)
--   end)
-- end

-- do
--   local mod      = { "ctrl", "shift", "option" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke({ "shift", "option" }, key, 1000)
--   end)
-- end

-- do
--   local mod      = { "ctrl", "shift", "cmd" }
--   local bindings = {
--     [ "d" ] = "left",
--     [ "n" ] = "right",
--     [ "h" ] = "down",
--     [ "t" ] = "up"
--   }

--   bindHotkeys(mod, bindings, function(key)
--     hs.eventtap.keyStroke({ "shift", "cmd" }, key, 1000)
--   end)
-- end

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

-- knu.keymap.register(
--   "com.microsoft.VSCode",
--   knu.keymap.new(
--     -- Forward
--     -- hs.hotkey.new({ "cmd", "shift" }, "t", function ()
--     --   hs.eventtap.keyStroke({ "ctrl" }, "-", 1000)
--     -- end),
--     -- -- Back
--     -- hs.hotkey.new({ "cmd", "shift" }, "h", function ()
--     --   hs.eventtap.keyStroke({ "ctrl", "shift" }, "-", 1000)
--     -- end),
--     -- -- Next Tab
--     -- hs.hotkey.new({ "cmd", "shift" }, "d", function ()
--     --   hs.eventtap.keyStroke({ "cmd", "shift" }, "[", 1000)
--     -- end),
--     -- -- Previous Tab
--     -- hs.hotkey.new({ "cmd", "shift" }, "n", function ()
--     --   hs.eventtap.keyStroke({ "cmd", "shift" }, "]", 1000)
--     -- end),
--     -- -- Split
--     -- hs.hotkey.new({ "alt", "cmd" }, "s", function ()
--     --   hs.eventtap.keyStroke({ "cmd" }, "\\", 1000)
--     -- end),
--     -- Left Split
--     hs.hotkey.new({ "alt", "cmd" }, "d", function ()
--       hs.eventtap.keyStroke({ "cmd" }, "k", 1000)
--       hs.eventtap.keyStroke({ "cmd" }, "left", 1000)
--     end),
--     -- Right Split
--     hs.hotkey.new({ "alt", "cmd" }, "n", function ()
--       hs.eventtap.keyStroke({ "cmd" }, "k", 1000)
--       hs.eventtap.keyStroke({ "cmd" }, "right", 1000)
--     end),
--     hs.hotkey.new({ "alt", "cmd" }, "h", function ()
--       hs.eventtap.keyStroke({ "cmd", "ctrl" }, "left", 1000)
--     end),
--     hs.hotkey.new({ "alt", "cmd" }, "t", function ()
--       hs.eventtap.keyStroke({ "cmd", "ctrl" }, "right", 1000)
--     end),
--     -- hs.hotkey.new({ "ctrl", "alt", "cmd" }, "d", function ()
--     --   hs.eventtap.keyStroke({ "cmd" }, "b", 1000)
--     -- end),
--     hs.hotkey.new({ "cmd", "shift" }, "c", function ()
--       hs.eventtap.keyStroke({ "ctrl" }, "l", 1000)
--       hs.eventtap.keyStroke(nil, "c", 1000)
--     end)
--   )
-- )

-- hs.loadSpoon("ControlEscape"):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

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

function launchBrowser()
  local host = hs.host.localizedName()
  if host == "C-HG7W9LQ32F" then
    hs.application.launchOrFocus("Google Chrome")
  else
    hs.application.launchOrFocus("Arc")
  end
end

local modal = hs.hotkey.modal.new()
binder(nil, "t", function() hs.application.launchOrFocus("iTerm") end, modal)
binder(nil, "h", function() launchBrowser() end, modal)
binder(nil, "v", function() hs.application.launchOrFocus("Cursor") end, modal)
binder(nil, "d", function() Size.moveLocation("left") end, modal)
binder(nil, "n", function() Size.moveLocation("right") end, modal)
binder(nil, "c", function() Size.moveLocation("full") end, modal)

