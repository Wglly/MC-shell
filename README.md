# MC-shell

[![License: MIT](https://img.shields.io/badge/license-MIT-97ca00?style=flat-square)](LICENSE)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793d1?style=flat-square&logo=archlinux&logoColor=white)](https://archlinux.org)
[![Wayland](https://img.shields.io/badge/Wayland-compatible-4ade80?style=flat-square)](https://wayland.freedesktop.org)
[![Compositors](https://img.shields.io/badge/desktop-Niri_%7C_Hyprland-8957e5?style=flat-square)](#how-compositor-support-works)
[![Quickshell](https://img.shields.io/badge/Quickshell-0.3.2-4f7cff?style=flat-square)](https://quickshell.org)

A **Minecraft-styled desktop shell** for [Quickshell](https://quickshell.org), made for
**Hyprland** and **niri**. Status bar, player-inventory dock, launcher, control centre,
settings screen, desktop widgets, side baskets, power menu and toasts — all rendered like
blocks, hotbar slots and stone GUI panels.

**English · 简体中文 · 繁體中文** — the whole UI is translated and switches live.

**Seven built-in themes** — classic, cave, snow mountain, desert, village, Windows XP and
Windows 95 — each one a full palette + block-texture set, switchable from Settings → Theme:

![Themes](docs/screenshots/16-themes.png)

![Bar](docs/screenshots/1-bar.png)

## Screenshots

| Player-inventory dock | Launcher |
|---|---|
| ![Dock](docs/screenshots/11-dock.png) | ![Launcher](docs/screenshots/2-launcher.png) |

| Settings · general | Settings · bar |
|---|---|
| ![Settings general](docs/screenshots/4-settings-general.png) | ![Settings bar](docs/screenshots/5-settings-bar.png) |

| Settings · theme | Settings · dock |
|---|---|
| ![Settings theme](docs/screenshots/6-settings-theme.png) | ![Settings dock](docs/screenshots/7-settings-dock.png) |

| Settings · widgets | Settings · side baskets |
|---|---|
| ![Settings widgets](docs/screenshots/8-settings-widgets.png) | ![Settings sidebars](docs/screenshots/9-settings-sidebars.png) |

| Desktop overview (drag windows between desktops) | Settings · overview |
|---|---|
| ![Overview](docs/screenshots/13-overview.png) | ![Overview settings](docs/screenshots/15-settings-overview.png) |

| Power menu | Options / OSD |
|---|---|
| ![Power menu](docs/screenshots/10-power.png) | ![Control centre](docs/screenshots/3-control-center.png) ![OSD](docs/screenshots/12-osd.png) |

## What's inside

### Bar (4 edges)
Hotbar workspaces, window title, `DAY n · HH:MM` clock, CPU hearts, RAM drumsticks,
NET / VOL / BAT chips, tray icons, settings and power buttons. The bar can sit on the
**top, bottom, left or right** edge and swaps between a horizontal row and a vertical
column automatically.

### Dock — the player inventory
A wooden inventory basket of app slots whose **rows and columns are free** (1–12 columns ×
1–6 rows, e.g. the classic 9×3 or a compact 5×2). Pin your apps, change the icon size,
move the dock to **any of the four edges**, or let it auto-hide behind a 4px strip. Empty
slots are drawn too, because an inventory without empty slots isn't an inventory.

Besides pinned apps the dock lists **everything running on the current workspace** (green
dot = running window). Left click focuses the window or launches the app, **right click
pins / unpins** it. With **auto-avoid** (default) the dock tucks itself into its 4px strip
while the workspace has windows, comes back by itself on an empty desktop, and expands when
the pointer touches the strip — so it never covers a window.

![Dock](docs/screenshots/23-dock-running.png)

The dock also carries a **mini media player** (title/artist + prev/play/next) and a
**dashboard button**; both can be switched off in Settings → Dock.

![Dock grid settings](docs/screenshots/14-settings-dock-grid.png)

### Dashboard
A macOS-dashboard style wall of widgets opened from the dock button or
`mc-shell ipc call shell dashboard`: clock, weather, media, visualiser, calendar and the
player card, all on one screen.

![Dashboard](docs/screenshots/17-dashboard.png)

### Desktop overview
A full-screen grid of desktops with every window as a draggable card. Drop a card on
another desktop to move the window there; click a card to jump to that window. The number
of cards per row, how many desktops are shown, titles and backdrop darkness are all in
Settings → Overview.

- Hyprland: exact window move via `hl.dsp.window.move` (Lua configs) or
  `movetoworkspacesilent` (legacy configs).
- niri: focuses the window, then `niri msg action move-window-to-workspace`.

### Launcher
Searchable app grid (type / arrows / Enter / Esc), mouse wheel scrolling.

### Settings screen
One tab per feature group, all changes apply live and are written to
`~/.config/mc-shell/config.json`:

- **General** — language (auto / English / 简体中文 / 繁體中文), shortcut cheat sheet, reset
- **Shell** — live bar height/edge, dock edge/icon size/grid, left/right basket widths
- **Wallpaper** — enable MC-shell's own background layer, image path, fallback colour, fill mode
- **Bar** — visibility, edge, thickness, which HUD parts to show
- **Theme** — five presets, plus accent + highlight colours, block textures, UI scale
- **Dock** — visibility, edge, auto-hide, **auto-avoid windows**, icon size, **grid rows/columns**, pinned apps
- **Widgets** — enable each desktop card, reset its position, weather city, visualiser bar count
- **Side baskets** — left/right basket on-off, width, and which widgets they carry
- **Overview** — enable, cards per row, desktops shown, window titles, backdrop darkness

### Preset wallpapers

One "loading screen" wallpaper ships with the shell (drawn by
`scripts/gen_wallpapers.py` from our own textures and Monocraft font):

![Wallpaper](docs/screenshots/22-wallpapers.png)

**Bring your own art.** Official Minecraft promo art and community screenshots belong to
Mojang/Microsoft, so this repository does not redistribute them. The wallpaper card can
import them into your local cache instead: paste an image URL, or use the folder picker to
point at a directory of wallpapers. Nothing leaves your machine except the download you
request.

```sh
mc-shell ipc call shell wallpaper loading      # the bundled preset
```

### Desktop widgets
Draggable cards on the wallpaper layer: **clock**, **weather** (wttr.in, no API key),
**music visualiser** (real spectrum from `cava`), **calendar**, **system stats**,
**media player** and the **player card** (avatar from `~/.face`, name, host, uptime).
Enable/disable each one in Settings → Widgets; drag them straight on the desktop.
Positions are stored as screen ratios and can be reset from Settings.

### Side baskets
Left and right edge panels ("baskets") hosting any combination of widget cards. They are
**closed by default** and toggled from the two new buttons in the bar (or with
`mc-shell ipc call shell basket left|right`); per-component toggles live in
Settings → Side baskets:

| Left (default) | Right (default) |
|---|---|
| **Performance monitor** (CPU/RAM bars, load, uptime) · **Wallpaper picker** (three built-in pixel scenes + native folder picker to import any local directory + reload) · **Widget manager** (add/remove desktop widgets) | **Player card** · **Toggle grid** (Wi-Fi / BT / mic / DND) · **Volume + brightness sliders** · **Messages** (history, DND, clear) |

| Left basket | Right basket |
|---|---|
| ![Left basket](docs/screenshots/20-left-basket.png) | ![Right basket](docs/screenshots/21-right-basket.png) |

All cards are also selectable per side in Settings → Side baskets, and the baskets can be
resized/disabled in Settings → Shell.

### Power menu
A Minecraft title screen: grass-block logo, `MC-SHELL`, and world-action buttons —
return to game (lock), save & quit (sleep), leave session, respawn (reboot),
quit to desktop (power off), back to game.

### Everything else
- **Options / control centre** — volume + brightness sliders, Wi-Fi/Bluetooth, MPRIS media,
  session stats, lock/sleep/reboot/off.
- **XP-bar OSD** for volume and brightness, driven by compositor keybindings over IPC.
- **Notification daemon + advancement-style toasts**.
- **Pixel-perfect theming** — bundled Monocraft font, procedurally generated 16×16
  textures (dirt, stone, cobblestone, oak planks, bedrock, deepslate, hearts, hunger,
  weather and UI icons), hard 3D bevels, no rounded corners.

## Requirements

| Dependency | Notes |
|---|---|
| `quickshell` ≥ 0.3 | `qs --version`; developed against 0.3.2 |
| Hyprland **or** niri | auto-detected from `HYPRLAND_INSTANCE_SIGNATURE` / `NIRI_SOCKET` |
| PipeWire | volume read/write via `Quickshell.Services.Pipewire` |
| `curl` | weather widget (wttr.in) |
| `cava` | optional — real audio spectrum; the visualiser stays flat without it |
| `brightnessctl` | optional — the brightness slider hides itself if missing |
| `loginctl`, `systemctl` | lock / sleep / reboot / power off |

## Install

```sh
git clone https://github.com/Wglly/MC-shell.git
cd MC-shell
./install.sh          # -> ~/.config/quickshell/mc-shell + ~/.local/bin/mc-shell
mc-shell              # start it
```

Autostart:

```ini
# Hyprland
exec-once = mc-shell
```

```kdl
// niri
spawn-at-startup "mc-shell"
```

> MC-shell reserves the edge its bar sits on, and draws its own wallpaper only if you
> enable it. Disable any other bar before using MC-shell.

## Keybindings

Everything is exposed over Quickshell IPC:

```ini
# Hyprland
bind = SUPER, D, exec, mc-shell ipc call shell launcher
bind = SUPER, X, exec, mc-shell ipc call shell control
bind = SUPER, C, exec, mc-shell ipc call shell settings
bind = SUPER, TAB, exec, mc-shell ipc call shell overview
bind = SUPER, P, exec, mc-shell ipc call shell power
bind = , XF86AudioRaiseVolume,  exec, mc-shell ipc call shell volumeUp
bind = , XF86AudioLowerVolume,  exec, mc-shell ipc call shell volumeDown
bind = , XF86AudioMute,         exec, mc-shell ipc call shell volumeMute
bind = , XF86MonBrightnessUp,   exec, mc-shell ipc call shell brightnessUp
bind = , XF86MonBrightnessDown, exec, mc-shell ipc call shell brightnessDown
```

```kdl
// niri
Mod+D { spawn "mc-shell" "ipc" "call" "shell" "launcher"; }
Mod+X { spawn "mc-shell" "ipc" "call" "shell" "control"; }
Mod+C { spawn "mc-shell" "ipc" "call" "shell" "settings"; }
Mod+Tab { spawn "mc-shell" "ipc" "call" "shell" "overview"; }
Mod+P { spawn "mc-shell" "ipc" "call" "shell" "power"; }
XF86AudioRaiseVolume { spawn "mc-shell" "ipc" "call" "shell" "volumeUp"; }
XF86AudioLowerVolume { spawn "mc-shell" "ipc" "call" "shell" "volumeDown"; }
XF86AudioMute        { spawn "mc-shell" "ipc" "call" "shell" "volumeMute"; }
XF86MonBrightnessUp   { spawn "mc-shell" "ipc" "call" "shell" "brightnessUp"; }
XF86MonBrightnessDown { spawn "mc-shell" "ipc" "call" "shell" "brightnessDown"; }
```

### IPC reference

| Call | Effect |
|---|---|
| `shell launcher` / `control` / `settings` / `power` | toggle an overlay |
| `shell close` | close whatever is open |
| `shell volumeUp` / `volumeDown` / `volumeMute` | audio + OSD |
| `shell brightnessUp` / `brightnessDown` | brightness + OSD |
| `shell overview` | toggle the desktop overview |
| `shell basket <left\|right>` | open/close a side basket |
| `shell dashboard` | toggle the widget dashboard |
| `shell focus <id>` / `stepWorkspace <±1>` | workspace control |
| `shell windows` | JSON window list (debug) |
| `shell moveWindow <windowId> <desktopId>` | move a window to a desktop |
| `shell workspaces` / `backend` | debug readouts |
| `shell language <auto\|en\|zh_CN\|zh_TW>` | switch language |
| `shell preset <classic\|cave\|snow\|desert\|village\|winxp\|win95>` | switch theme preset |
| `shell wallpaper <plains\|sunset\|night\|cave\|snow\|desert\|village>` | apply a built-in wallpaper |
| `shell set <dotted.key> <value>` | write any setting, e.g. `set bar.position left` |
| `shell settingsTab <0-6>` | open a settings tab |

## Configuration

Settings are edited in the GUI and stored as JSON:

```json
{
  "language": "auto",
  "bar":   { "position": "top", "visible": true, "thickness": 40, "showStats": true },
  "dock":  { "position": "bottom", "iconSize": 42, "columns": 9, "rows": 3,
             "autoHide": false, "pinned": ["firefox.desktop"] },
  "overview": { "enabled": true, "columns": 3, "desktops": 6, "showTitles": true },
  "theme": { "preset": "classic", "accent": "#5fbf4f", "gold": "#ffcc4d",
             "barTexture": "deepslate", "panelTexture": "dirt", "cardTexture": "oak_planks" },
  "wallpaper": { "enabled": false, "path": "", "color": "#101418", "fillMode": "fill" },
  "widgets": { "clock": { "enabled": true, "x": 0.06, "y": 0.10 } },
  "sidebars": { "left": { "enabled": true, "width": 260, "widgets": ["stats", "calendar"] } }
}
```

`bar.position` and `dock.position` accept `top` / `bottom` / `left` / `right`.

## How compositor support works

```
services/Compositor.qml   one API for both compositors
├── Hyprland: Quickshell.Hyprland (event driven, no polling)
└── niri:     `niri msg --json workspaces` + `focused-window`, refreshed from
              `niri msg event-stream` (debounced) with a 3 s safety poll;
              actions go through `niri msg action focus-workspace`
```

No extra QML plugin is required for niri.

## Themes

Five presets ship with the shell, each one a complete palette (bar/card/panel colours,
text + shadow colours, bevels) plus a block texture set:

| Preset | Look |
|---|---|
| `classic` | dark slate bar, dirt panels, green accent |
| `cave` | near-black bar, cobblestone panels, torch-orange accent |
| `snow` | light icy bar, snow/ice panels, blue accent, dark text |
| `desert` | sandstone bar, warm sand panels, dark amber accent |
| `village` | oak-plank bar, warm wood panels, mossy green accent |
| `winxp` | six-stop Luna taskbar gradient (stretched to the bar height), cream `#ECE9D8` panels, white cards, navy titles and borders |
| `win95` | flat grey bar with hard bevels, black text, navy highlights |

Pick one in **Settings → Theme → theme presets**, or:

```sh
mc-shell ipc call shell preset snow     # or cave/desert/village/winxp/win95
```

Manual accent / highlight / texture / scale controls stay available below the presets.

The XP palette follows the Luna taskbar ramp used by Reborn XP
(`#3168d5 → #4993e6 → #245dd7 → #2257d5 → #2663e0 → #1941a5`, slightly muted for
the pixel UI), with XP's dialog cream for panels and navy for headings. The one thing
that is intentionally *not* XP is the font: MC-shell always uses Monocraft, so the XP
and 95 themes keep the pixel look.

## Shell control panel

**Settings → Shell** is the one-stop geometry panel (iNiR-style): bar edge + height,
dock edge + icon size + grid, and left/right basket width — all live.

![Shell control](docs/screenshots/18-settings-shell-control.png)

## Theming internals

- `modules/common/Theme.qml` — colours, sizes, font, texture lookup.
- `assets/textures/` — generated by `python3 scripts/gen_textures.py` (Pillow).
  Edit the script and re-run to change any block, heart, hunger, weather or UI icon.
- `assets/fonts/Monocraft.ttf` — SIL OFL 1.1.

## Project layout

```
shell.qml                       entry point: font, theme bindings, all windows, IPC
modules/common/                 Theme, Settings-driven widgets (McPanel, Slot, Chip, ...)
modules/bar/                    Bar + workspaces, clock, stats, chips, tray, title
modules/dock/                   player-inventory dock
modules/launcher/               inventory launcher
modules/control/                options / control centre
modules/settings/               settings window + 7 pages
modules/widgets/                clock, weather, visualiser, calendar, stats cards + desktop hosts
modules/sidebars/               left/right baskets (per-side card lists)
modules/overview/               desktop overview + window drag
modules/dashboard/              widget dashboard wall
modules/wallpaper/              background layer
modules/power/                  title-screen power menu
modules/osd/                    XP-bar OSD
modules/notifications/          advancement toasts
services/                       Settings, I18n, Compositor, Audio, Stats, Apps, System, Weather, Visualiser, Notifs
assets/                         Monocraft font, generated textures, icon
scripts/gen_textures.py         texture generator
scripts/gen_wallpapers.py       built-in wallpaper generator
```

## Status

- Hyprland backend: verified live on Hyprland 0.57.2 (Wayland), 1920×1080.
- niri backend: exercised against a mocked `niri msg` CLI (workspace model, focus
  actions, focused-window title). Please open an issue if your niri version differs.
- Notification toasts only appear when no other daemon owns `org.freedesktop.Notifications`.

## Credits

- Layout and interaction ideas from [quickshell-niri](https://github.com/imiric/quickshell-niri)
  (MIT, © The Ink Serpent) and [anomshell](https://github.com/atif-1402/anomshell)
  (MIT, © atif-1402).
- [Monocraft](https://github.com/IdreesInc/Monocraft) font (SIL OFL 1.1).
- [Quickshell](https://quickshell.org) by outfoxxed.
- Not affiliated with Mojang or Microsoft. All textures are original pixel art generated
  by this repository; no Minecraft assets are included.

## 中文速览

- **是什麼**：Quickshell 寫的 Minecraft 風格桌面 shell，支援 Hyprland 與 niri。
- **安裝**：`./install.sh`，再執行 `mc-shell`；Hyprland 用 `exec-once = mc-shell`，
  niri 用 `spawn-at-startup "mc-shell"`。
- **設定**：`mc-shell ipc call shell settings` 開啟設定頁（壁紙 / 狀態列 / 主題 /
  應用籃 / 桌面元件 / 側邊籃），所有變更即時生效並存到
  `~/.config/mc-shell/config.json`。
- **語言**：設定 → 一般 → 語言，可選自動 / English / 简体中文 / 繁體中文。
- **狀態列與應用籃**：可在上、下、左、右四邊自由切換。
- **桌面元件**：時鐘、天氣、音樂可視化（cava）、日曆、系統，可直接拖動。

## License

MIT — see [LICENSE](LICENSE).
