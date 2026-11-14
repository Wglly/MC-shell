#!/usr/bin/env python3
"""Generate the three built-in pixel-art wallpapers for the wallpaper picker.

Pure procedural art (no game assets), MIT licensed like the rest of the repo.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import random

OUT = Path(__file__).resolve().parent.parent / "assets" / "wallpapers"
OUT.mkdir(parents=True, exist_ok=True)
W, H = 480, 270


def gradient(top, bottom):
    img = Image.new("RGB", (W, H))
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / (H - 1)
        c = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        d.line([(0, y), (W, y)], fill=c)
    return img, d


def sunset():
    img, d = gradient((255, 154, 64), (54, 30, 74))
    rng = random.Random(11)
    # pixel sun
    cx, cy, r = 330, 150, 34
    for y in range(cy - r, cy + r):
        for x in range(cx - r, cx + r):
            if (x - cx) ** 2 + (y - cy) ** 2 <= r * r:
                shade = 255 - int(abs(y - cy) * 2)
                d.point((x, y), fill=(255, max(120, shade), 60))
    # hills
    for i in range(3):
        base = 190 + i * 24
        pts = [(0, H)]
        for x in range(0, W + 10, 10):
            h = base + int(18 * ((x // 40 + i) % 2)) + rng.randint(-4, 4)
            pts.append((x, h))
        pts.append((W, H))
        d.polygon(pts, fill=(30 + i * 12, 24 + i * 10, 40 + i * 8))
    # stars
    for _ in range(40):
        d.point((rng.randrange(W), rng.randrange(0, 90)), fill=(255, 255, 230))
    img.save(OUT / "sunset.png")


def cave():
    img, d = gradient((26, 26, 30), (8, 8, 10))
    rng = random.Random(12)
    # stone blocks
    for y in range(0, H, 24):
        for x in range(0, W, 32):
            c = 28 + rng.randint(-6, 8)
            d.rectangle([x, y, x + 31, y + 23], outline=(c, c, c + 2), width=2)
    # torches
    for (tx, ty) in [(80, 140), (240, 90), (400, 170)]:
        d.rectangle([tx, ty, tx + 4, ty + 22], fill=(120, 82, 44))
        d.ellipse([tx - 8, ty - 16, tx + 12, ty + 2], fill=(255, 170, 50))
        d.ellipse([tx - 4, ty - 12, tx + 8, ty - 2], fill=(255, 230, 130))
    img.save(OUT / "cave.png")


def snow():
    img, d = gradient((196, 224, 245), (240, 248, 255))
    rng = random.Random(13)
    # mountains
    for i, (base, col) in enumerate([(190, (170, 196, 220)), (215, (150, 178, 205))]):
        pts = [(0, H)]
        for x in range(0, W + 12, 12):
            h = base - int(40 * abs(((x // 60 + i) % 2) - 0.5)) + rng.randint(-3, 3)
            pts.append((x, h))
        pts.append((W, H))
        d.polygon(pts, fill=col)
    # snow caps + flakes
    for _ in range(120):
        x, y = rng.randrange(W), rng.randrange(H)
        d.point((x, y), fill=(255, 255, 255))
    img.save(OUT / "snow.png")


if __name__ == "__main__":
    sunset(); cave(); snow()
    for f in sorted(OUT.glob("*.png")):
        print("wrote", f.relative_to(OUT.parent.parent), f.stat().st_size // 1024, "KB")
