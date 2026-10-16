# herdr keybindings (tmux-matched, Dvorak d/h/t/n)

Prefix: **ctrl+space**  (tmux prefix stays Escape; press Esc Esc to send a real Esc through tmux)
`prefix+?` shows every live binding. `/` filters that list.

Chain in use: iTerm -> tmux (laptop) -> ssh fzf-mini -> herdr -> agents

## Panes

| Action              | herdr                 | tmux               | Note                                 |
|---------------------|-----------------------|--------------------|--------------------------------------|
| Split side by side  | prefix s              | prefix s           |                                      |
| Split stacked       | prefix w              | prefix w           |                                      |
| Focus left          | prefix d / ctrl+alt+d | prefix d / C-d     | bare C-d is eaten by the outer tmux  |
| Focus down          | prefix h / ctrl+alt+h | prefix h / C-h     |                                      |
| Focus up            | prefix t / ctrl+alt+t | prefix t / C-t     |                                      |
| Focus right         | prefix n / ctrl+alt+n | prefix n / C-n     |                                      |
| Last pane           | prefix C-\ / ctrl+alt+\ | C-\              |                                      |
| Cycle panes         | prefix tab / shift+tab| -                  |                                      |
| Resize left         | prefix D              | prefix D           | shift+d                              |
| Resize down         | prefix H              | prefix H           |                                      |
| Resize up           | prefix T              | prefix T           |                                      |
| Resize right        | prefix N              | prefix N           |                                      |
| Resize mode (repeat)| prefix r              | tmux -r repeat     | then d/h/t/n or arrows, Esc to leave |
| Swap pane           | prefix alt+d/h/t/n    | -                  |                                      |
| Zoom pane           | prefix z              | prefix z           |                                      |
| Close pane          | prefix x              | prefix x           |                                      |
| Copy mode           | prefix v  (or [)      | prefix v           | inside: h/j/k/l move, v select, y copy |
| Clear screen+history| prefix C-k            | prefix C-k         |                                      |
| Rename pane         | prefix P              | -                  |                                      |
| Scrollback in $EDITOR | prefix e            | -                  |                                      |

## Tabs (tmux windows)

| Action        | herdr            | tmux           |
|---------------|------------------|----------------|
| New tab       | prefix c         | prefix c       |
| Previous tab  | prefix p         | prefix p       |
| Next tab      | prefix C-a       | prefix C-a (last-window) |
| Tab 1..9      | prefix 1..9      | prefix 1..9    |
| Rename tab    | prefix ,         | prefix ,       |
| Close tab     | prefix X / &     | prefix &       |

## Workspaces (tmux sessions)

| Action           | herdr        | tmux                 |
|------------------|--------------|----------------------|
| Workspace picker | prefix C-s   | prefix C-s choose-session |
| Goto picker      | prefix g     | -                    |
| New workspace    | prefix C     | -                    |
| Rename workspace | prefix W     | prefix $             |
| Close workspace  | prefix Q     | -                    |
| Toggle sidebar   | prefix b     | -                    |

## Session

| Action        | herdr      | tmux        |
|---------------|------------|-------------|
| Detach        | prefix q   | prefix d (overridden in your conf) |
| Help          | prefix ?   | prefix ?    |
| Settings      | prefix S   | -           |
| Reload config | prefix R   | -           |

## Navigate mode (prefix g)

d / h / t / n move left / down / up / right. Up/Down change workspace. Enter jumps, Esc leaves.

## Not mappable

- Copy-mode cursor keys are fixed to h/j/k/l (tmux conf uses d/h/t/n there).
- herdr has no "last window"; prefix C-a is bound to next tab instead.
- Pane focus with bare ctrl+d/h/t/n never reaches herdr: the outer tmux handles those itself.

Files: ~/.config/herdr/config.toml   validate: `herdr config check`   apply: `herdr server reload-config`
