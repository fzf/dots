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
-- A single eventtap handles both behaviours from km.capslock / km.movement,
-- avoiding the hs.hotkey-vs-eventtap ordering conflict that affects
-- ControlEscape.spoon when hotkeys consume events before the spoon sees them.
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
      if sendEscape then hs.eventtap.keyStroke({}, "escape", 0) end
      sendEscape = false
    end
    return false
  end)

  local keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    sendEscape = false   -- any keypress cancels pending escape

    if flags.ctrl then
      local arrow = arrowMap[event:getKeyCode()]
      if arrow then
        local pass = {}
        if flags.shift then table.insert(pass, "shift") end
        if flags.alt   then table.insert(pass, "alt")   end
        if flags.cmd   then table.insert(pass, "cmd")   end
        hs.eventtap.keyStroke(pass, arrow, 0)
        return true   -- consume ctrl+hjkl; emit arrow instead
      end
    end
    return false
  end)

  modTap:start()
  keyTap:start()
end

startCtrlEscAndMove()

-- ── Engine: global remaps ──────────────────────────────────────────────────
for _, binding in ipairs(km.global or {}) do
  local fromMods, fromKey = binding.from[1], binding.from[2]
  local toMods,   toKey   = binding.to[1],   binding.to[2]

  local function press()
    hs.eventtap.keyStroke(toMods, toKey, 1000)
  end

  if binding.repeat_ then
    hs.hotkey.bind(fromMods, fromKey, press, nil, press)
  else
    hs.hotkey.bind(fromMods, fromKey, press)
  end
end

-- ── Engine: per-app remaps via AppBindings.spoon ──────────────────────────
local AppBindings = hs.loadSpoon("AppBindings")
AppBindings:init()

for _, appEntry in ipairs(km.apps or {}) do
  local rows = {}
  for _, b in ipairs(appEntry.bindings) do
    table.insert(rows, { b.from[1], b.from[2], b.to[1], b.to[2] })
  end
  AppBindings:bind(appEntry.app, rows)
end

-- ── Tab-held modal (app launcher + window management) ─────────────────────

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
