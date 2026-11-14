#!/usr/bin/env python3
"""Generate the built-in "loading screen" wallpaper.

Only one preset ships with the shell: a Minecraft-style loading screen drawn
from our own textures and font (no game assets).  Anything else (official promo
art, community screenshots, your own photos) is imported at runtime through the
wallpaper card's URL field or folder picker, so this repository never
redistributes copyrighted artwork.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "wallpapers"
OUT.mkdir(parents=True, exist_ok=True)

W, H = 960, 540


def center(d, text, font, y, fill):
    w = d.textlength(text, font=font)
    d.text(((W - w) // 2, y), text, font=font, fill=fill)


def main():
    dirt = Image.open(ROOT / "assets" / "textures" / "dirt.png").convert("RGB").resize((48, 48), Image.NEAREST)
    bg = Image.new("RGB", (W, H))
    for y in range(0, H, 48):
        for x in range(0, W, 48):
            bg.paste(dirt, (x, y))
    bg = Image.blend(bg, Image.new("RGB", (W, H), (0, 0, 0)), 0.55)
    d = ImageDraw.Draw(bg)

    font_big = ImageFont.truetype(str(ROOT / "assets" / "fonts" / "Monocraft.ttf"), 78)
    font_mid = ImageFont.truetype(str(ROOT / "assets" / "fonts" / "Monocraft.ttf"), 22)
    font_small = ImageFont.truetype(str(ROOT / "assets" / "fonts" / "Monocraft.ttf"), 16)

    # little grass block "logo"
    d.rectangle([W // 2 - 34, 96, W // 2 + 34, 164], fill=(106, 168, 79))
    for i in range(7):
        d.rectangle([W // 2 - 34 + i * 10, 96, W // 2 - 30 + i * 10, 128], fill=(122, 188, 92))
    d.rectangle([W // 2 - 34, 128, W // 2 + 34, 164], fill=(134, 96, 67))

    center(d, "MC-shell", font_big, 200, (255, 255, 255))
    center(d, "Building terrain...", font_mid, 300, (220, 220, 220))

    center(d, "press any key to continue", font_small, 372, (200, 200, 200))

    bg.save(OUT / "loading.png")
    print("wrote assets/wallpapers/loading.png", bg.size)


if __name__ == "__main__":
    main()
