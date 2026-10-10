"""Erzeugt App-Icon (Android, iOS, Web) und In-App-Logo aus einer Vorlage.

    pip install cairosvg pillow && python3 tool/generate_icons.py
"""

import io
import json
from pathlib import Path

import cairosvg

ROOT = Path(__file__).resolve().parent.parent
RES = ROOT / "android/app/src/main/res"

SEED = "#1F6B5C"
ACCENT = "#2A9D8F"

# 108×108 = Android-Adaptive-Icon-Raster; Motiv bleibt in der 66er-Schutzzone.
FOLDER = """
  <path d="M36 30H47q2 0 3.5 1.5L54 35h18a6 6 0 0 1 6 6v29a6 6 0 0 1-6 6H36
           a6 6 0 0 1-6-6V36a6 6 0 0 1 6-6z" fill="#fff" fill-opacity=".55"/>
  <rect x="30" y="41" width="48" height="35" rx="6" fill="#fff"/>
"""
CROSS = """
  <rect x="50.5" y="48.5" width="7" height="20" rx="2" fill="{c}"/>
  <rect x="44" y="55" width="20" height="7" rx="2" fill="{c}"/>
"""
BACKGROUND = f"""
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="{ACCENT}"/>
      <stop offset="1" stop-color="{SEED}"/>
    </linearGradient>
  </defs>
"""


def svg(body, view="0 0 108 108"):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{view}">{body}</svg>'
    )


FOREGROUND = svg(FOLDER + CROSS.format(c=SEED))
# Themed Icons (Android 13+) nutzen nur Alpha: das Kreuz wird ausgespart.
MONOCHROME = svg(
    FOLDER.split("<rect")[0]
    + """
  <path fill="#fff" fill-rule="evenodd" d="M36 41h36a6 6 0 0 1 6 6v23a6 6 0 0 1
           -6 6H36a6 6 0 0 1-6-6V47a6 6 0 0 1 6-6z
           M50.5 48.5v6.5H44v7h6.5v6.5h7V62H64v-7h-6.5v-6.5z"/>
"""
)
# Volles Bild (Legacy-Icon, Web, Logo): abgerundetes Quadrat + Motiv.
ROUNDED = svg(
    BACKGROUND
    + '<rect x="14" y="14" width="80" height="80" rx="20" fill="url(#bg)"/>'
    + FOLDER
    + CROSS.format(c=SEED),
    view="14 14 80 80",
)
# Vollflächig (Web „maskable“): Hintergrund bis zum Rand.
FULL_BLEED = svg(
    BACKGROUND
    + '<rect width="108" height="108" fill="url(#bg)"/>'
    + FOLDER
    + CROSS.format(c=SEED)
)

# iOS: vollflächig, Ausschnitt enger als das Android-Raster (keine
# 66er-Schutzzone nötig) — das Motiv wirkt sonst zu klein.
IOS = svg(
    BACKGROUND
    + '<rect width="108" height="108" fill="url(#bg)"/>'
    + FOLDER
    + CROSS.format(c=SEED),
    view="20 20 68 68",
)


def png(source, path, size):
    path.parent.mkdir(parents=True, exist_ok=True)
    cairosvg.svg2png(
        bytestring=source.encode(),
        write_to=str(path),
        output_width=size,
        output_height=size,
    )


def ios_icons():
    """iOS-AppIcon: vollflächig (iOS rundet selbst ab), ohne Alphakanal —
    App Store Connect lehnt ein 1024er-Icon mit Transparenz ab."""
    from PIL import Image

    folder = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((folder / "Contents.json").read_text())
    for image in contents["images"]:
        name = image.get("filename")
        if not name:
            continue
        points = float(image["size"].split("x")[0])
        size = round(points * int(image["scale"].rstrip("x")))
        data = cairosvg.svg2png(
            bytestring=IOS.encode(), output_width=size, output_height=size
        )
        rgba = Image.open(io.BytesIO(data)).convert("RGBA")
        flat = Image.new("RGB", rgba.size, SEED)
        flat.paste(rgba, mask=rgba.split()[3])
        flat.save(folder / name, optimize=True)


def main():
    (ROOT / "assets/branding/logo.svg").write_text(ROUNDED + "\n")

    densities = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
    for name, factor in densities.items():
        folder = RES / f"mipmap-{name}"
        png(ROUNDED, folder / "ic_launcher.png", round(48 * factor))
        png(FOREGROUND, folder / "ic_launcher_foreground.png", round(108 * factor))
        png(MONOCHROME, folder / "ic_launcher_monochrome.png", round(108 * factor))

    for scale, suffix in [(1, ""), (2, "2.0x/"), (3, "3.0x/")]:
        png(ROUNDED, ROOT / f"assets/branding/{suffix}logo.png", 96 * scale)

    web = ROOT / "web"
    png(ROUNDED, web / "favicon.png", 32)
    png(ROUNDED, web / "icons/Icon-192.png", 192)
    png(ROUNDED, web / "icons/Icon-512.png", 512)
    png(FULL_BLEED, web / "icons/Icon-maskable-192.png", 192)
    png(FULL_BLEED, web / "icons/Icon-maskable-512.png", 512)

    ios_icons()


if __name__ == "__main__":
    main()
