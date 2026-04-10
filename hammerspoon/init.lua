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

-- ── Caps Lock → Ctrl/Esc + Ctrl+HJKL movement ────────────────────────────
-- NOTE: CapsLock must also be remapped to Control at the OS level:
-- System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock: ^ Control
--
-- This combined handler replaces both Karabiner rules:
--   "caps to ctrl/esc" — tap Ctrl (CapsLock) alone → sends Escape
--   "movement *"       — Ctrl+H/J/K/L → Left/Down/Up/Right arrows
--
-- Using a single eventtap avoids ordering conflicts between ControlEscape.spoon
-- and hs.hotkey (which consumes key events before eventtaps see them).
local ctrlEscAndMove = (function()
  local sendEscape = false
  local lastCtrl = false
  local CANCEL_DELAY = 0.150

  local timer = hs.timer.delayed.new(CANCEL_DELAY, function()
    sendEscape = false
  end)

  local arrowMap = {
    [hs.keycodes.map["h"]] = "left",
    [hs.keycodes.map["j"]] = "down",
    [hs.keycodes.map["k"]] = "up",
    [hs.keycodes.map["l"]] = "right",
  }

  -- Watch for Ctrl press/release to decide whether to send Escape on release
  local modTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local mods = event:getFlags()
    local ctrlNow = mods.ctrl or false

    if ctrlNow == lastCtrl then return false end

    if ctrlNow then
      lastCtrl = true
      sendEscape = true
      timer:start()
    else
      lastCtrl = false
      timer:stop()
      if sendEscape then
        hs.eventtap.keyStroke({}, "escape", 0)
      end
      sendEscape = false
    end
    return false
  end)

  -- Any key press cancels escape; Ctrl+HJKL gets remapped to arrows
  local keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    sendEscape = false  -- any key press cancels the pending escape

    if flags.ctrl then
      local arrow = arrowMap[event:getKeyCode()]
      if arrow then
        -- Pass through shift/alt/cmd but drop ctrl, send the arrow key instead
        local passMods = {}
        if flags.shift then table.insert(passMods, "shift") end
        if flags.alt   then table.insert(passMods, "alt")   end
        if flags.cmd   then table.insert(passMods, "cmd")   end
        hs.eventtap.keyStroke(passMods, arrow, 0)
        return true  -- consume the original ctrl+hjkl event
      end
    end
    return false
  end)

  modTap:start()
  keyTap:start()
end)()

-- ── Global remaps ─────────────────────────────────────────────────────────

-- Cmd+Tab → Ctrl+Tab (replaces Karabiner "switch" rule)
hs.hotkey.bind({"cmd"}, "tab", function()
  hs.eventtap.keyStroke({"ctrl"}, "tab", 1000)
end)

-- Cmd+Escape → Cmd+` (cycle windows of same app)
hs.hotkey.bind({"cmd"}, "escape", function()
  hs.eventtap.keyStroke({"cmd"}, "`", 1000)
end)

-- Ctrl+Delete → Forward Delete (with repeat)
hs.hotkey.bind({"ctrl"}, "delete",
  function() hs.eventtap.keyStroke({}, "forwarddelete", 1000) end,
  nil,
  function() hs.eventtap.keyStroke({}, "forwarddelete", 1000) end)

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

-- ── Per-app remaps (replaces all Karabiner complex_modifications app rules) ──
-- Format: { fromMods, fromKey, toMods, toKey }
-- AppBindings.spoon enables/disables hotkeys based on frontmost app window.
local AppBindings = hs.loadSpoon("AppBindings")
AppBindings:init()

-- Arc
AppBindings:bind("Arc", {
  {{"cmd"},              "r",  {"cmd"},          "k"},   -- open/search bar (Cmd+R → Cmd+K)
  {{"cmd","ctrl","alt"}, "h",  {"cmd"},          ";"},   -- sidebar / drawer left
  {{"cmd"},              "j",  {"cmd"},          "-"},   -- history back
  {{"cmd"},              "k",  {"cmd"},          "="},   -- history forward
  {{"cmd","shift"},      "f",  {"cmd","shift"},  "k"},   -- reopen closed tab
  {{"cmd","shift"},      ";",  {"ctrl","shift"}, "]"},   -- split forward
  {{"cmd","shift"},      "h",  {"ctrl","shift"}, "["},   -- split back
  {{"cmd","shift"},      "l",  {"ctrl","shift"}, "["},   -- split forward (mirror of split back)
  {{"cmd","shift"},      ",",  {"cmd"},          "w"},   -- close split
  {{"cmd","shift"},      "j",  {"cmd","shift"},  "-"},   -- previous tab
  {{"cmd","shift"},      "k",  {"cmd","shift"},  "="},   -- next tab
})

-- Google Chrome
AppBindings:bind("Google Chrome", {
  {{"cmd"},         "r",  {"cmd"},         "k"},      -- open/search bar
  {{"cmd"},         "j",  {"cmd"},         "left"},   -- history back
  {{"cmd"},         "k",  {"cmd"},         "right"},  -- history forward
  {{"cmd","shift"}, "f",  {"cmd","shift"}, "k"},      -- reopen closed tab
  {{"cmd","shift"}, "j",  {"cmd","shift"}, "-"},      -- previous tab
  {{"cmd","shift"}, "k",  {"cmd","shift"}, "="},      -- next tab
})

-- Island
AppBindings:bind("Island", {
  {{"cmd","ctrl","alt"}, "h",  {"cmd"},          ";"},    -- sidebar / drawer left
  {{"cmd"},              "r",  {"cmd"},          "k"},    -- open/search bar
  {{"cmd"},              "j",  {"cmd"},          "left"}, -- history back
  {{"cmd"},              "k",  {"cmd"},          "right"},-- history forward
  {{"cmd","shift"},      "f",  {"cmd","shift"},  "k"},    -- reopen closed tab
  {{"cmd","shift"},      ";",  {"cmd"},          "f9"},   -- split tab
  {{"cmd","shift"},      "h",  {"ctrl","shift"}, "["},    -- split back
  {{"cmd","shift"},      "l",  {"ctrl","shift"}, "["},    -- split forward
  {{"cmd","shift"},      ",",  {"cmd"},          "w"},    -- close split
  {{"cmd","shift"},      "j",  {"cmd","shift"},  "-"},    -- previous tab
  {{"cmd","shift"},      "k",  {"cmd","shift"},  "="},    -- next tab
})

-- Messages
AppBindings:bind("Messages", {
  {{"cmd","shift"}, "j", {"cmd","shift"}, "-"},  -- previous conversation
  {{"cmd","shift"}, "k", {"cmd","shift"}, "="},  -- next conversation
})

-- Notion
AppBindings:bind("Notion", {
  {{"cmd","ctrl","alt"}, "h",  {"cmd"},          ";"},   -- sidebar
  {{"cmd"},              "j",  {"cmd"},          "-"},   -- history back
  {{"cmd"},              "k",  {"cmd"},          "="},   -- history forward
  {{"cmd","shift"},      "j",  {"cmd","shift"},  "-"},   -- previous tab
  {{"cmd","shift"},      "k",  {"cmd","shift"},  "="},   -- next tab
})

-- Slack
AppBindings:bind("Slack", {
  {{"cmd","ctrl","alt"}, "h",  {"cmd","shift"}, "h"},   -- sidebar toggle
  {{"cmd"},              "r",  {"cmd"},         "k"},   -- jump to conversation
  {{"cmd"},              "j",  {"cmd"},         "-"},   -- history back
  {{"cmd"},              "k",  {"cmd"},         "="},   -- history forward
  {{"cmd","shift"},      "j",  {"cmd","shift"}, "-"},   -- previous unread
  {{"cmd","shift"},      "k",  {"cmd","shift"}, "="},   -- next unread
})

-- Telegram
AppBindings:bind("Telegram", {
  {{"cmd"}, "r", {"cmd"}, "v"},  -- search/jump
})

-- Vivaldi
AppBindings:bind("Vivaldi", {
  {{"cmd"},              "r",  {"cmd"},          "d"},    -- open/search bar (address bar)
  {{"cmd","ctrl","alt"}, "h",  {"cmd"},          ";"},    -- panel toggle
  {{"cmd"},              "j",  {"cmd"},          "left"}, -- history back
  {{"cmd"},              "k",  {"cmd"},          "right"},-- history forward
  {{"cmd","shift"},      "f",  {"cmd","shift"},  "k"},    -- reopen closed tab
  {{"cmd","shift"},      ";",  {"cmd"},          "f9"},   -- tile tab
  {{"cmd","shift"},      "h",  {"ctrl","shift"}, "["},    -- tile back
  {{"cmd","shift"},      "l",  {"ctrl","shift"}, "["},    -- tile forward
  {{"cmd","shift"},      ",",  {"cmd"},          "w"},    -- close tile
  {{"cmd","shift"},      "j",  {"cmd","shift"},  "-"},    -- previous tab
  {{"cmd","shift"},      "k",  {"cmd","shift"},  "="},    -- next tab
  {{"cmd","alt"},        "p",  {"cmd","shift"},  "a"},    -- password manager
})

-- Zoom
AppBindings:bind("zoom.us", {
  {{"cmd","ctrl","alt"}, "h", {"cmd","shift"}, "j"},  -- participants panel
})
