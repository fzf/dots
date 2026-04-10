-- keymaps.lua
-- Hammerspoon keymap configuration
--
-- This file is the single source of truth for all key remapping.
-- init.lua reads it and applies each section automatically.
--
-- ── Key syntax ────────────────────────────────────────────────────────────
-- Modifiers: "cmd", "ctrl", "alt" / "option", "shift"
-- Keys:      plain characters "a"-"z", "0"-"9"
--            punctuation: "-", "=", "[", "]", ";", "'", ",", ".", "/"
--            special:     "tab", "escape", "delete", "forwarddelete",
--                         "return", "space", "left", "right", "up", "down"
--            function:    "f1"–"f19"
-- ─────────────────────────────────────────────────────────────────────────

local M = {}

-- ── Caps Lock ─────────────────────────────────────────────────────────────
-- Caps Lock is remapped to Control via System Settings:
--   Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock: ^ Control
--
-- Hammerspoon then adds the dual-role behaviour:
--   tap  → Escape
--   hold → Control  (normal modifier)
--   hold + H/J/K/L  → arrow keys  (see M.movement below)
M.capslock = {
  tap_timeout_ms = 150,   -- tap window in milliseconds; increase if you miss taps
}

-- ── Movement ──────────────────────────────────────────────────────────────
-- Ctrl+HJKL → arrow keys (Vim-style cursor movement, works anywhere).
-- Additional modifiers (Shift, Alt, Cmd) are passed through, so:
--   Ctrl+Shift+J → Shift+Down  (extend selection downward)
--   Ctrl+Alt+L   → Alt+Right   (move word right)
M.movement = {
  { from = "h", to = "left",  desc = "Cursor left"  },
  { from = "j", to = "down",  desc = "Cursor down"  },
  { from = "k", to = "up",    desc = "Cursor up"    },
  { from = "l", to = "right", desc = "Cursor right" },
}

-- ── Global remaps ─────────────────────────────────────────────────────────
-- Always active regardless of frontmost app.
M.global = {
  { from = {{"cmd"},   "tab"},    to = {{"ctrl"}, "tab"},     desc = "Tab forward (app tabs, not app switcher)" },
  { from = {{"cmd"},   "escape"}, to = {{"cmd"},  "`"},       desc = "Cycle windows of same app"               },
  { from = {{"ctrl"},  "delete"}, to = {{},       "forwarddelete"}, desc = "Forward delete", repeat_ = true   },
}

-- ── Per-app remaps ────────────────────────────────────────────────────────
-- Each entry needs:
--   app      — app name as it appears in the menu bar (not bundle ID)
--   bindings — list of { from, to, desc } mappings
--
-- from / to format: { modifiers_table, key_string }
--   e.g.  {{"cmd"}, "k"}   or   {{"cmd","shift"}, "="}

M.apps = {

  -- ── Arc ─────────────────────────────────────────────────────────────────
  {
    app = "Arc",
    bindings = {
      { from = {{"cmd"},              "r"}, to = {{"cmd"},          "k"}, desc = "Open search / command bar"  },
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd"},          ";"}, desc = "Toggle sidebar"             },
      { from = {{"cmd"},              "j"}, to = {{"cmd"},          "-"}, desc = "History back"               },
      { from = {{"cmd"},              "k"}, to = {{"cmd"},          "="}, desc = "History forward"            },
      { from = {{"cmd","shift"},      "f"}, to = {{"cmd","shift"},  "k"}, desc = "Reopen closed tab"          },
      { from = {{"cmd","shift"},      ";"}, to = {{"ctrl","shift"}, "]"}, desc = "Open split / pane forward"  },
      { from = {{"cmd","shift"},      "h"}, to = {{"ctrl","shift"}, "["}, desc = "Split pane back"            },
      { from = {{"cmd","shift"},      "l"}, to = {{"ctrl","shift"}, "["}, desc = "Split pane forward"         },
      { from = {{"cmd","shift"},      ","}, to = {{"cmd"},          "w"}, desc = "Close split pane"           },
      { from = {{"cmd","shift"},      "j"}, to = {{"cmd","shift"},  "-"}, desc = "Previous tab"               },
      { from = {{"cmd","shift"},      "k"}, to = {{"cmd","shift"},  "="}, desc = "Next tab"                   },
    },
  },

  -- ── Google Chrome ────────────────────────────────────────────────────────
  {
    app = "Google Chrome",
    bindings = {
      { from = {{"cmd"},         "r"}, to = {{"cmd"},         "k"}, desc = "Open address bar / search"  },
      { from = {{"cmd"},         "j"}, to = {{"cmd"},     "left"}, desc = "History back"                },
      { from = {{"cmd"},         "k"}, to = {{"cmd"},    "right"}, desc = "History forward"             },
      { from = {{"cmd","shift"}, "f"}, to = {{"cmd","shift"}, "k"}, desc = "Reopen closed tab"          },
      { from = {{"cmd","shift"}, "j"}, to = {{"cmd","shift"}, "-"}, desc = "Previous tab"               },
      { from = {{"cmd","shift"}, "k"}, to = {{"cmd","shift"}, "="}, desc = "Next tab"                   },
    },
  },

  -- ── Island ───────────────────────────────────────────────────────────────
  {
    app = "Island",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd"},          ";"}, desc = "Toggle sidebar"            },
      { from = {{"cmd"},              "r"}, to = {{"cmd"},          "k"}, desc = "Open search / command bar" },
      { from = {{"cmd"},              "j"}, to = {{"cmd"},      "left"}, desc = "History back"              },
      { from = {{"cmd"},              "k"}, to = {{"cmd"},     "right"}, desc = "History forward"           },
      { from = {{"cmd","shift"},      "f"}, to = {{"cmd","shift"},  "k"}, desc = "Reopen closed tab"         },
      { from = {{"cmd","shift"},      ";"}, to = {{"cmd"},          "f9"}, desc = "Tile / split tab"         },
      { from = {{"cmd","shift"},      "h"}, to = {{"ctrl","shift"}, "["}, desc = "Split pane back"           },
      { from = {{"cmd","shift"},      "l"}, to = {{"ctrl","shift"}, "["}, desc = "Split pane forward"        },
      { from = {{"cmd","shift"},      ","}, to = {{"cmd"},          "w"}, desc = "Close split pane"          },
      { from = {{"cmd","shift"},      "j"}, to = {{"cmd","shift"},  "-"}, desc = "Previous tab"              },
      { from = {{"cmd","shift"},      "k"}, to = {{"cmd","shift"},  "="}, desc = "Next tab"                  },
    },
  },

  -- ── Messages ─────────────────────────────────────────────────────────────
  {
    app = "Messages",
    bindings = {
      { from = {{"cmd","shift"}, "j"}, to = {{"cmd","shift"}, "-"}, desc = "Previous conversation" },
      { from = {{"cmd","shift"}, "k"}, to = {{"cmd","shift"}, "="}, desc = "Next conversation"     },
    },
  },

  -- ── Notion ───────────────────────────────────────────────────────────────
  {
    app = "Notion",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd"},         ";"}, desc = "Toggle sidebar"   },
      { from = {{"cmd"},              "j"}, to = {{"cmd"},         "-"}, desc = "History back"      },
      { from = {{"cmd"},              "k"}, to = {{"cmd"},         "="}, desc = "History forward"   },
      { from = {{"cmd","shift"},      "j"}, to = {{"cmd","shift"}, "-"}, desc = "Previous tab"      },
      { from = {{"cmd","shift"},      "k"}, to = {{"cmd","shift"}, "="}, desc = "Next tab"          },
    },
  },

  -- ── Slack ────────────────────────────────────────────────────────────────
  {
    app = "Slack",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd","shift"}, "h"}, desc = "Toggle sidebar"        },
      { from = {{"cmd"},              "r"}, to = {{"cmd"},         "k"}, desc = "Jump to conversation"   },
      { from = {{"cmd"},              "j"}, to = {{"cmd"},         "-"}, desc = "History back"           },
      { from = {{"cmd"},              "k"}, to = {{"cmd"},         "="}, desc = "History forward"        },
      { from = {{"cmd","shift"},      "j"}, to = {{"cmd","shift"}, "-"}, desc = "Previous unread"        },
      { from = {{"cmd","shift"},      "k"}, to = {{"cmd","shift"}, "="}, desc = "Next unread"            },
    },
  },

  -- ── Telegram ─────────────────────────────────────────────────────────────
  {
    app = "Telegram",
    bindings = {
      { from = {{"cmd"}, "r"}, to = {{"cmd"}, "v"}, desc = "Search / jump to chat" },
    },
  },

  -- ── Vivaldi ──────────────────────────────────────────────────────────────
  {
    app = "Vivaldi",
    bindings = {
      { from = {{"cmd"},              "r"}, to = {{"cmd"},          "d"},    desc = "Open address bar"          },
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd"},          ";"},    desc = "Toggle panel"              },
      { from = {{"cmd"},              "j"}, to = {{"cmd"},      "left"},    desc = "History back"              },
      { from = {{"cmd"},              "k"}, to = {{"cmd"},     "right"},    desc = "History forward"           },
      { from = {{"cmd","shift"},      "f"}, to = {{"cmd","shift"},  "k"},    desc = "Reopen closed tab"         },
      { from = {{"cmd","shift"},      ";"}, to = {{"cmd"},          "f9"},   desc = "Tile tab"                  },
      { from = {{"cmd","shift"},      "h"}, to = {{"ctrl","shift"}, "["},    desc = "Tile back"                 },
      { from = {{"cmd","shift"},      "l"}, to = {{"ctrl","shift"}, "["},    desc = "Tile forward"              },
      { from = {{"cmd","shift"},      ","}, to = {{"cmd"},          "w"},    desc = "Close tile"                },
      { from = {{"cmd","shift"},      "j"}, to = {{"cmd","shift"},  "-"},    desc = "Previous tab"              },
      { from = {{"cmd","shift"},      "k"}, to = {{"cmd","shift"},  "="},    desc = "Next tab"                  },
      { from = {{"cmd","alt"},        "p"}, to = {{"cmd","shift"},  "a"},    desc = "Open password manager"     },
    },
  },

  -- ── Zoom ─────────────────────────────────────────────────────────────────
  {
    app = "zoom.us",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "h"}, to = {{"cmd","shift"}, "j"}, desc = "Toggle participants panel" },
    },
  },

}

return M
