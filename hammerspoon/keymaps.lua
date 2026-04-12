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

-- ── Per-app remaps ────────────────────────────────────────────────────
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
      { from = {{"cmd"},              "p"}, to = {{"cmd"},          "t"}, desc = "Open search / command bar"  },
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd"},          "s"}, desc = "Toggle sidebar"             },
      { from = {{"cmd"},              "h"}, to = {{"cmd"},          "["}, desc = "History back"               },
      { from = {{"cmd"},              "t"}, to = {{"cmd"},          "]"}, desc = "History forward"            },
      { from = {{"cmd","shift"},      "u"}, to = {{"cmd","shift"},  "t"}, desc = "Reopen closed tab"          },
      { from = {{"cmd","shift"},      "s"}, to = {{"ctrl","shift"}, "="}, desc = "Open split / pane forward"  },
      { from = {{"cmd","shift"},      "d"}, to = {{"ctrl","shift"}, "/"}, desc = "Split pane back"            },
      { from = {{"cmd","shift"},      "n"}, to = {{"ctrl","shift"}, "/"}, desc = "Split pane forward"         },
      { from = {{"cmd","shift"},      "w"}, to = {{"cmd"},          ","}, desc = "Close split pane"           },
      { from = {{"cmd","shift"},      "h"}, to = {{"cmd","shift"},  "["}, desc = "Previous tab"               },
      { from = {{"cmd","shift"},      "t"}, to = {{"cmd","shift"},  "]"}, desc = "Next tab"                   },
    },
  },

  -- ── Google Chrome ────────────────────────────────────────────────────────
  {
    app = "Google Chrome",
    bindings = {
      { from = {{"cmd"},         "p"}, to = {{"cmd"},         "t"}, desc = "Open address bar / search"  },
      { from = {{"cmd"},         "h"}, to = {{"cmd"},     "left"}, desc = "History back"                },
      { from = {{"cmd"},         "t"}, to = {{"cmd"},    "right"}, desc = "History forward"             },
      { from = {{"cmd","shift"}, "u"}, to = {{"cmd","shift"}, "t"}, desc = "Reopen closed tab"          },
      { from = {{"cmd","shift"}, "h"}, to = {{"cmd","shift"}, "["}, desc = "Previous tab"               },
      { from = {{"cmd","shift"}, "t"}, to = {{"cmd","shift"}, "]"}, desc = "Next tab"                   },
    },
  },

  -- ── Island ───────────────────────────────────────────────────────────────
  {
    app = "Island",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd"},          "s"}, desc = "Toggle sidebar"            },
      { from = {{"cmd"},              "p"}, to = {{"cmd"},          "t"}, desc = "Open search / command bar" },
      { from = {{"cmd"},              "h"}, to = {{"cmd"},      "left"}, desc = "History back"              },
      { from = {{"cmd"},              "t"}, to = {{"cmd"},     "right"}, desc = "History forward"           },
      { from = {{"cmd","shift"},      "u"}, to = {{"cmd","shift"},  "t"}, desc = "Reopen closed tab"         },
      { from = {{"cmd","shift"},      "s"}, to = {{"cmd"},          "f9"}, desc = "Tile / split tab"         },
      { from = {{"cmd","shift"},      "d"}, to = {{"ctrl","shift"}, "/"}, desc = "Split pane back"           },
      { from = {{"cmd","shift"},      "n"}, to = {{"ctrl","shift"}, "/"}, desc = "Split pane forward"        },
      { from = {{"cmd","shift"},      "w"}, to = {{"cmd"},          ","}, desc = "Close split pane"          },
      { from = {{"cmd","shift"},      "h"}, to = {{"cmd","shift"},  "["}, desc = "Previous tab"              },
      { from = {{"cmd","shift"},      "t"}, to = {{"cmd","shift"},  "]"}, desc = "Next tab"                  },
    },
  },

  -- ── Messages ─────────────────────────────────────────────────────────────
  {
    app = "Messages",
    bindings = {
      { from = {{"cmd","shift"}, "h"}, to = {{"cmd","shift"}, "["}, desc = "Previous conversation" },
      { from = {{"cmd","shift"}, "t"}, to = {{"cmd","shift"}, "]"}, desc = "Next conversation"     },
    },
  },

  -- ── Notion ───────────────────────────────────────────────────────────────
  {
    app = "Notion",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd"},         "\\"}, desc = "Toggle sidebar"   },
      { from = {{"cmd"},              "h"}, to = {{"cmd"},         "["}, desc = "History back"      },
      { from = {{"cmd"},              "t"}, to = {{"cmd"},         "]"}, desc = "History forward"   },
      { from = {{"cmd","shift"},      "h"}, to = {{"cmd","shift"}, "["}, desc = "Previous tab"      },
      { from = {{"cmd","shift"},      "t"}, to = {{"cmd","shift"}, "]"}, desc = "Next tab"          },
    },
  },

  -- ── Slack ────────────────────────────────────────────────────────────────
  {
    app = "Slack",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd","shift"}, "d"}, desc = "Toggle sidebar"        },
      { from = {{"cmd"},              "p"}, to = {{"cmd"},         "t"}, desc = "Jump to conversation"   },
      { from = {{"cmd"},              "h"}, to = {{"cmd"},         "["}, desc = "History back"           },
      { from = {{"cmd"},              "t"}, to = {{"cmd"},         "]"}, desc = "History forward"        },
      { from = {{"cmd","shift"},      "h"}, to = {{"cmd","shift"}, "["}, desc = "Previous unread"        },
      { from = {{"cmd","shift"},      "t"}, to = {{"cmd","shift"}, "]"}, desc = "Next unread"            },
    },
  },

  -- ── Telegram ─────────────────────────────────────────────────────────────
  {
    app = "Telegram",
    bindings = {
      { from = {{"cmd"}, "p"}, to = {{"cmd"}, "k"}, desc = "Search / jump to chat" },
    },
  },

  -- ── Vivaldi ──────────────────────────────────────────────────────────────
  {
    app = "Vivaldi",
    bindings = {
      { from = {{"cmd"},              "p"}, to = {{"cmd"},          "e"},    desc = "Open address bar"          },
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd"},          "s"},    desc = "Toggle panel"              },
      { from = {{"cmd"},              "h"}, to = {{"cmd"},      "left"},    desc = "History back"              },
      { from = {{"cmd"},              "t"}, to = {{"cmd"},     "right"},    desc = "History forward"           },
      { from = {{"cmd","shift"},      "u"}, to = {{"cmd","shift"},  "t"},    desc = "Reopen closed tab"         },
      { from = {{"cmd","shift"},      "s"}, to = {{"cmd"},          "f9"},   desc = "Tile tab"                  },
      { from = {{"cmd","shift"},      "d"}, to = {{"ctrl","shift"}, "/"},    desc = "Tile back"                 },
      { from = {{"cmd","shift"},      "n"}, to = {{"ctrl","shift"}, "/"},    desc = "Tile forward"              },
      { from = {{"cmd","shift"},      "w"}, to = {{"cmd"},          ","},    desc = "Close tile"                },
      { from = {{"cmd","shift"},      "h"}, to = {{"cmd","shift"},  "["},    desc = "Previous tab"              },
      { from = {{"cmd","shift"},      "t"}, to = {{"cmd","shift"},  "]"},    desc = "Next tab"                  },
      { from = {{"cmd","alt"},        "r"}, to = {{"cmd","shift"},  "a"},    desc = "Open password manager"     },
    },
  },

  -- ── Zoom ─────────────────────────────────────────────────────────────────
  {
    app = "zoom.us",
    bindings = {
      { from = {{"cmd","ctrl","alt"}, "d"}, to = {{"cmd","shift"}, "h"}, desc = "Toggle participants panel" },
    },
  },

}

return M
