-- keymaps.lua
-- Hammerspoon keymap configuration
--
-- This file is the single source of truth for key remapping.
-- init.lua reads it and applies each section automatically.

local M = {}

-- ── Caps Lock ─────────────────────────────────────────────────────────────
-- Caps Lock is remapped to Control via System Settings:
--   Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock: ^ Control
--
-- Hammerspoon then adds the dual-role behaviour:
--   tap  → Escape
--   hold → Control  (normal modifier)
M.capslock = {
  tap_timeout_ms = 150,   -- tap window in milliseconds; increase if you miss taps
}

-- ── Movement ──────────────────────────────────────────────────────────
-- Ctrl+DHTN → arrow keys (Dvorak layout, Vim-style positions).
-- Additional modifiers (Shift, Alt, Cmd) are passed through, so:
--   Ctrl+Shift+H → Shift+Down  (extend selection downward)
--   Ctrl+Alt+N   → Alt+Right   (move word right)
M.movement = {
  { from = "d", to = "left",  desc = "Cursor left"  },
  { from = "h", to = "down",  desc = "Cursor down"  },
  { from = "t", to = "up",    desc = "Cursor up"    },
  { from = "n", to = "right", desc = "Cursor right" },
}

return M
