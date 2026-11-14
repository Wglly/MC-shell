#!/usr/bin/env python3
"""Generate the Minecraft-inspired 16x16 pixel textures used by MC-shell.

Everything here is drawn procedurally (no ripped Minecraft assets), so the
result is safe to redistribute under the repository's MIT license.  Run from
the repository root:  python3 scripts/gen_textures.py
"""
from __future__ import annotations

import random
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "textures"
ICONS = ROOT / "assets" / "icons"
OUT.mkdir(parents=True, exist_ok=True)
ICONS.mkdir(parents=True, exist_ok=True)

TILE = 16


def shade(hex_color: str, amount: int) -> tuple[int, int, int]:
    """Lighten (amount > 0) or darken a hex colour by a flat amount."""
    r = int(hex_color[1:3], 16)
    g = int(hex_color[3:5], 16)
    b = int(hex_color[5:7], 16)
    clamp = lambda v: max(0, min(255, v + amount))
    return clamp(r), clamp(g), clamp(b)


def noisy_tile(base: str, spread: int, seed: int, speckle: int = 0) -> Image.Image:
    """Flat colour tile with per-pixel value noise (the classic MC look)."""
    rng = random.Random(seed)
    img = Image.new("RGB", (TILE, TILE))
    px = img.load()
    for y in range(TILE):
        for x in range(TILE):
            delta = rng.randint(-spread, spread)
            px[x, y] = shade(base, delta)
    if speckle:
        for _ in range(speckle):
            x, y = rng.randrange(TILE), rng.randrange(TILE)
            px[x, y] = shade(base, -spread * 3)
    return img


def cobblestone(seed: int = 7) -> Image.Image:
    """Cell-shaped cobbles with dark mortar, 16x16."""
    rng = random.Random(seed)
    img = Image.new("RGB", (TILE, TILE))
    px = img.load()
    mortar = (58, 58, 58)
    for y in range(TILE):
        for x in range(TILE):
            px[x, y] = mortar
    # A handful of irregular blocky stones.
    stones = [
        (0, 0, 7, 5), (8, 0, 8, 4), (0, 6, 4, 5), (5, 5, 6, 6),
        (12, 5, 4, 6), (0, 12, 6, 4), (7, 12, 5, 4), (13, 12, 3, 4),
        (11, 9, 3, 3),
    ]
    for (x, y, w, h) in stones:
        tone = rng.randint(-12, 16)
        for yy in range(h):
            for xx in range(w):
                if 0 <= x + xx < TILE and 0 <= y + yy < TILE:
                    px[x + xx, y + yy] = shade("#8a8a8a", tone + rng.randint(-6, 6))
        # light top edge / dark bottom edge gives the chunky 3D read
        for xx in range(w):
            if 0 <= x + xx < TILE and 0 <= y < TILE:
                px[x + xx, y] = shade("#a2a2a2", tone)
            if 0 <= x + xx < TILE and 0 <= y + h - 1 < TILE:
                px[x + xx, y + h - 1] = shade("#5f5f5f", tone)
    return img


def planks(seed: int = 11) -> Image.Image:
    """Oak planks: four horizontal boards with staggered joints."""
    rng = random.Random(seed)
    img = Image.new("RGB", (TILE, TILE))
    px = img.load()
    for board in range(4):
        tone = rng.randint(-8, 8)
        y0 = board * 4
        for y in range(y0, y0 + 4):
            for x in range(TILE):
                grain = rng.randint(-5, 5)
                px[x, y] = shade("#b8945f", tone + grain)
        # seam under each board
        for x in range(TILE):
            px[x, y0 + 3] = shade("#8a6b3f", tone - 8)
        # vertical joint, offset every other board
        joint = 4 if board % 2 == 0 else 11
        for y in range(y0, y0 + 4):
            px[joint, y] = shade("#7d5f36", tone - 4)
    return img


def grass_top(seed: int = 3) -> Image.Image:
    rng = random.Random(seed)
    img = Image.new("RGB", (TILE, TILE))
    px = img.load()
    for y in range(TILE):
        for x in range(TILE):
            px[x, y] = shade("#6aa84f", rng.randint(-18, 14))
    return img


def heart(filled: bool = True) -> Image.Image:
    """9x9 HUD heart, drawn as pixel rows (classic shape)."""
    rows = [
        " XX  XX  ",
        "XXXX XXXX",
        "XXXXXXXXX",
        "XXXXXXXXX",
        " XXXXXXX ",
        "  XXXXX  ",
        "   XXX   ",
        "    X    ",
        "         ",
    ]
    img = Image.new("RGBA", (9, 9), (0, 0, 0, 0))
    px = img.load()
    body = (214, 45, 42, 255) if filled else (78, 26, 26, 255)
    hi = (255, 120, 110, 255) if filled else (110, 40, 40, 255)
    dark = (120, 18, 18, 255) if filled else (52, 16, 16, 255)
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != "X":
                continue
            px[x, y] = dark
    # inner fill
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != "X":
                continue
            if y < 8 and x + 1 < 9 and rows[y][x + 1] == "X" and y > 0 and rows[y - 1][x] == "X":
                px[x, y] = body
    # highlight corner
    for (x, y) in [(2, 1), (3, 1), (1, 2), (2, 2)]:
        if rows[y][x] == "X":
            px[x, y] = hi
    return img


def drumstick() -> Image.Image:
    """9x9 hunger icon (drumstick)."""
    rows = [
        "  XXX    ",
        " XXXXXX  ",
        " XXXXXXX ",
        " XXXXXXX ",
        "  XXXXX  ",
        "   XX    ",
        "   XX    ",
        "   XX    ",
        "         ",
    ]
    img = Image.new("RGBA", (9, 9), (0, 0, 0, 0))
    px = img.load()
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch == "X":
                px[x, y] = (196, 138, 74, 255)
    for (x, y) in [(2, 1), (3, 1), (2, 2)]:
        if rows[y][x] == "X":
            px[x, y] = (238, 190, 120, 255)
    for y in range(5, 8):
        px[3, y] = (236, 232, 218, 255)
    return img


def slot() -> Image.Image:
    """18x18 inventory slot with bevel, meant to be 9-sliced or used as-is."""
    s = 18
    img = Image.new("RGB", (s, s))
    px = img.load()
    for y in range(s):
        for x in range(s):
            px[x, y] = (139, 139, 139)
    for i in range(s):
        px[i, 0] = (55, 55, 55)
        px[0, i] = (55, 55, 55)
        px[i, s - 1] = (255, 255, 255)
        px[s - 1, i] = (255, 255, 255)
    for y in range(1, s - 1):
        for x in range(1, s - 1):
            px[x, y] = (60, 60, 60) if (x < 3 or y < 3) else (44, 44, 44)
    for i in range(2, s - 2):
        px[i, 1] = (32, 32, 32)
        px[1, i] = (32, 32, 32)
    return img


def block_icon() -> Image.Image:
    """A simple isometric-ish grass block for the app/repo icon."""
    size = 32
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    # dirt body
    for y in range(12, 30):
        for x in range(2, 30):
            px[x, y] = shade("#866043", random.Random(x * 131 + y).randint(-10, 10))
    # grass cap
    for y in range(2, 13):
        for x in range(2, 30):
            px[x, y] = shade("#6aa84f", random.Random(x * 71 + y).randint(-14, 10))
    # outline
    for i in range(2, 30):
        px[i, 2] = (40, 70, 30, 255)
        px[i, 29] = (40, 26, 18, 255)
        px[2, i] = (40, 70, 30, 255)
        px[29, i] = (40, 26, 18, 255)
    return img


def save(img: Image.Image, name: str, scale: int = 1) -> None:
    if scale > 1:
        img = img.resize((img.width * scale, img.height * scale), Image.NEAREST)
    img.save(OUT / name)
    print(f"wrote assets/textures/{name} ({img.width}x{img.height})")


def pixel_icon(rows, palette, name):
    """Draw a tiny icon from ASCII rows with a colour palette."""
    h = len(rows)
    w = max(len(r) for r in rows)
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px = img.load()
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch in palette:
                px[x, y] = palette[ch]
    save(img, name, scale=3)


def gear_icon() -> None:
    rows = [
        "  XX XX  ",
        " XXXXXXX ",
        " XX   XX ",
        "XXX   XXX",
        "XX     XX",
        "XXX   XXX",
        " XX   XX ",
        " XXXXXXX ",
        "  XX XX  ",
    ]
    pixel_icon(rows, {"X": (184, 184, 184, 255)}, "icon_gear.png")


def power_icon() -> None:
    rows = [
        "   XXX   ",
        "   XXX   ",
        "X  XXX  X",
        "X  XXX  X",
        "X       X",
        " X     X ",
        "  X   X  ",
        "   XXX   ",
        "         ",
    ]
    pixel_icon(rows, {"X": (224, 74, 63, 255)}, "icon_power.png")


def book_icon() -> None:
    rows = [
        " XXXXXX  ",
        " X    X  ",
        " X XX X  ",
        " X XX X  ",
        " X XX X  ",
        " X XX X  ",
        " X    X  ",
        " XXXXXX  ",
        "         ",
    ]
    pixel_icon(rows, {"X": (196, 138, 74, 255)}, "icon_book.png")


def weather_icons() -> None:
    sun = [
        "X   X   X",
        " X  X  X ",
        "  XXXXX  ",
        " XXYYYXX ",
        "X XYYYX X",
        " XXYYYXX ",
        "  XXXXX  ",
        " X  X  X ",
        "X   X   X",
    ]
    cloud = [
        "         ",
        "   XXX   ",
        "  XXXXX  ",
        " XXXXXXX ",
        "XXXXXXXXX",
        "XXXXXXXXX",
        " XXXXXXX ",
        "         ",
        "         ",
    ]
    rain = [
        "   XXX   ",
        "  XXXXX  ",
        " XXXXXXX ",
        "XXXXXXXXX",
        " XXXXXXX ",
        "  B B B  ",
        "   B B   ",
        "  B B B  ",
        "         ",
    ]
    snow = [
        "   X X   ",
        " X X X X ",
        "  XXXXX  ",
        "XXXXXXXXX",
        "  XXXXX  ",
        " X X X X ",
        "   X X   ",
        "         ",
        "         ",
    ]
    storm = [
        "   XXX   ",
        "  XXXXX  ",
        " XXXXXXX ",
        "XXXXXXXXX",
        "   YYY   ",
        "  YYY    ",
        " YYY     ",
        " YY      ",
        "         ",
    ]
    pixel_icon(sun, {"X": (255, 204, 77, 255), "Y": (255, 236, 140, 255)}, "icon_sun.png")
    pixel_icon(cloud, {"X": (214, 214, 214, 255)}, "icon_cloud.png")
    pixel_icon(rain, {"X": (214, 214, 214, 255), "B": (79, 168, 224, 255)}, "icon_rain.png")
    pixel_icon(snow, {"X": (226, 240, 255, 255)}, "icon_snow.png")
    pixel_icon(storm, {"X": (170, 170, 170, 255), "Y": (255, 220, 90, 255)}, "icon_storm.png")


def overview_icon() -> None:
    rows = [
        "XX XX XX ",
        "XX XX XX ",
        "         ",
        "XX XX XX ",
        "XX XX XX ",
        "         ",
        "XX XX XX ",
        "XX XX XX ",
        "         ",
    ]
    pixel_icon(rows, {"X": (255, 204, 77, 255)}, "icon_overview.png")


def themed_tiles() -> None:
    """Snow / ice / sandstone / mossy stone for the extra themes."""
    save(noisy_tile("#e6edf5", 7, 21, speckle=3), "snow.png")
    ice = Image.new("RGB", (TILE, TILE))
    px = ice.load()
    rng = random.Random(22)
    for y in range(TILE):
        for x in range(TILE):
            px[x, y] = shade("#a9d7ea", rng.randint(-8, 8))
    for y in (3, 4, 10, 11):
        for x in range(TILE):
            px[x, y] = shade("#cfeaf5", 6)
    save(ice, "ice.png")

    sand = Image.new("RGB", (TILE, TILE))
    px = sand.load()
    rng = random.Random(23)
    for y in range(TILE):
        band = 6 if (y // 4) % 2 == 0 else 0
        for x in range(TILE):
            px[x, y] = shade("#d8c08a", band + rng.randint(-6, 6))
    for y in (3, 7, 11, 15):
        for x in range(TILE):
            px[x, y] = shade("#b89a63", 0)
    save(sand, "sandstone.png")

    mossy = noisy_tile("#6f7a6a", 9, 24, speckle=8)
    px = mossy.load()
    rng = random.Random(25)
    for _ in range(26):
        x, y = rng.randrange(TILE), rng.randrange(TILE)
        for dy in range(rng.randint(1, 3)):
            for dx in range(rng.randint(1, 3)):
                if x + dx < TILE and y + dy < TILE:
                    px[x + dx, y + dy] = shade("#5d8a3f", rng.randint(-10, 14))
    save(mossy, "mossy_stone.png")


def dashboard_icon() -> None:
    rows = [
        "XXXXXXXXX",
        "X X X X X",
        "XXXXXXXXX",
        "X X X X X",
        "XXXXXXXXX",
        "         ",
        "X X X X X",
        "         ",
        "         ",
    ]
    pixel_icon(rows, {"X": (120, 200, 255, 255)}, "icon_dashboard.png")


def user_icon() -> None:
    rows = [
        "  XXXXX  ",
        " X     X ",
        "X  XXX  X",
        "X  XXX  X",
        "X       X",
        " X     X ",
        "  XXXXX  ",
        " X     X ",
        "XXX   XXX",
    ]
    pixel_icon(rows, {"X": (250, 214, 160, 255)}, "icon_user.png")


def main() -> None:
    save(noisy_tile("#866043", 14, 1, speckle=6), "dirt.png")
    save(noisy_tile("#7e7e7e", 10, 2, speckle=4), "stone.png")
    save(noisy_tile("#2b2b2b", 8, 3), "bedrock.png")
    save(noisy_tile("#565656", 8, 4), "deepslate.png")
    save(cobblestone(), "cobblestone.png")
    save(planks(), "oak_planks.png")
    save(grass_top(), "grass_block_top.png")
    save(heart(True), "heart.png", scale=2)
    save(heart(False), "heart_empty.png", scale=2)
    save(drumstick(), "hunger.png", scale=2)
    save(slot(), "slot.png", scale=2)
    gear_icon()
    power_icon()
    book_icon()
    weather_icons()
    overview_icon()
    themed_tiles()
    dashboard_icon()
    user_icon()
    icon = block_icon().resize((512, 512), Image.NEAREST)
    icon.save(ROOT / "assets" / "icon.png")
    print("wrote assets/icon.png (512x512)")


if __name__ == "__main__":
    main()
