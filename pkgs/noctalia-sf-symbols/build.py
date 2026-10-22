"""Build a Noctalia icon font and glyph registry backed by SF Symbols.

Noctalia renders every icon from a single font (assets/fonts/noctalia-tabler.ttf)
and resolves icon names through assets/fonts/tabler.json. This script produces
drop-in replacements for both files:

* The font contains the SF Symbols glyphs (supplementary PUA-B) from SF Pro,
  uniformly scaled so they sit at the same optical size as Tabler glyphs, plus
  any original Tabler glyphs icon-map.json asks to keep ("tabler:<name>").
* The registry maps every Tabler name Noctalia uses (via icon-map.json, plus
  exact name matches) and every SF Symbol name to a codepoint in that font.

Usage: build.py SF_PRO_FONT TABLER_FONT TABLER_JSON ICON_MAP SCALE OUT_DIR SOURCE_DIR...
where each SOURCE_DIR holds the names.txt/symbols.txt pair copied from the
SF Symbols app (later directories take precedence).
"""

import json
import sys
from pathlib import Path

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.t2CharStringPen import T2CharStringPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

SF_PUA_START = 0x100000
# GlyphRegistry falls back to this Tabler codepoint ("skull") for unknown names.
NOCTALIA_MISSING_GLYPH = 0xF292
MISSING_SYMBOL = "questionmark.square.dashed"
SF_CATEGORY = "SF Symbols"
TABLER_PREFIX = "tabler:"


def load_symbol_names(source_dirs):
    names = {}
    for source in source_dirs:
        source = Path(source)
        symbol_names = [n for n in (source / "names.txt").read_text("utf-8").split("\n") if n]
        codepoints = [
            ord(ch) for ch in (source / "symbols.txt").read_text("utf-8") if ord(ch) >= SF_PUA_START
        ]
        if len(symbol_names) != len(codepoints):
            sys.exit(f"{source}: {len(symbol_names)} names but {len(codepoints)} symbols")
        names.update(zip(symbol_names, codepoints))
    return names


class GlyphSource:
    """A font whose glyphs are copied into the output, scaled into its em."""

    def __init__(self, path, prefix, scale):
        self.font = TTFont(path)
        self.glyph_set = self.font.getGlyphSet()
        self.cmap = self.font.getBestCmap()
        self.hmtx = self.font["hmtx"]
        self.prefix = prefix
        self.scale = scale


def build_font(sf_source, glyphs, out_path):
    """glyphs maps output codepoint -> (GlyphSource, source glyph name)."""
    upm = sf_source.font["head"].unitsPerEm
    glyph_order = [".notdef"]
    charstrings = {".notdef": T2CharStringPen(0, None).getCharString()}
    advances = {".notdef": 0}
    out_cmap = {}

    for codepoint, (source, glyph_name) in sorted(glyphs.items()):
        out_name = source.prefix + glyph_name
        if out_name not in charstrings:
            advance = round(source.hmtx[glyph_name][0] * source.scale)
            pen = T2CharStringPen(advance, source.glyph_set)
            source.glyph_set[glyph_name].draw(
                TransformPen(pen, (source.scale, 0, 0, source.scale, 0, 0))
            )
            charstrings[out_name] = pen.getCharString()
            advances[out_name] = advance
            glyph_order.append(out_name)
        out_cmap[codepoint] = out_name

    builder = FontBuilder(upm, isTTF=False)
    builder.setupGlyphOrder(glyph_order)
    builder.setupCharacterMap(out_cmap)
    builder.setupCFF("NoctaliaSFSymbols-Regular", {"FullName": "Noctalia SF Symbols"}, charstrings, {})

    metrics = {}
    for name in glyph_order:
        bounds = charstrings[name].calcBounds(None)
        metrics[name] = (advances[name], round(bounds[0]) if bounds else 0)
    builder.setupHorizontalMetrics(metrics)
    ascent = round(sf_source.font["hhea"].ascent * sf_source.scale)
    descent = round(sf_source.font["hhea"].descent * sf_source.scale)
    builder.setupHorizontalHeader(ascent=ascent, descent=descent)
    builder.setupNameTable({"familyName": "Noctalia SF Symbols", "styleName": "Regular"})
    builder.setupOS2(sTypoAscender=ascent, sTypoDescender=descent, usWinAscent=ascent, usWinDescent=-descent)
    builder.setupPost()
    builder.save(out_path)


def main():
    sf_font, tabler_font, tabler_json, icon_map_path, scale, out_dir, *source_dirs = sys.argv[1:]
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    sf = GlyphSource(sf_font, "", float(scale))
    # Keep Tabler glyphs at their original em-relative size.
    tabler_glyphs = GlyphSource(tabler_font, "tabler.", 1.0)
    tabler_glyphs.scale = sf.font["head"].unitsPerEm / tabler_glyphs.font["head"].unitsPerEm

    symbol_names = {
        name: cp for name, cp in load_symbol_names(source_dirs).items() if cp in sf.cmap
    }
    tabler = json.loads(Path(tabler_json).read_text("utf-8"))
    icon_map = json.loads(Path(icon_map_path).read_text("utf-8"))

    def tabler_codepoint(name):
        return int(tabler[name]["codepoint"].removeprefix("U+"), 16)

    unknown = []
    for key, value in icon_map.items():
        if value.startswith(TABLER_PREFIX):
            name = value.removeprefix(TABLER_PREFIX)
            if name not in tabler or tabler_codepoint(name) not in tabler_glyphs.cmap:
                unknown.append(f"{key} -> {value} (not in the Tabler font)")
        elif value not in symbol_names:
            unknown.append(f"{key} -> {value} (not in SF Pro)")
    if unknown:
        sys.exit("icon-map.json references missing glyphs:\n  " + "\n  ".join(sorted(unknown)))
    if MISSING_SYMBOL not in symbol_names:
        sys.exit(f"SF Pro is missing {MISSING_SYMBOL}")

    glyphs = {cp: (sf, sf.cmap[cp]) for cp in sf.cmap if cp >= SF_PUA_START}
    glyphs[NOCTALIA_MISSING_GLYPH] = (sf, sf.cmap[symbol_names[MISSING_SYMBOL]])

    registry = {}
    explicit = automatic = kept = 0
    for name, meta in tabler.items():
        target = icon_map.get(name)
        codepoint = None
        if target is not None and target.startswith(TABLER_PREFIX):
            # Tabler codepoints (BMP PUA) never overlap the SF Symbols range.
            codepoint = tabler_codepoint(target.removeprefix(TABLER_PREFIX))
            glyphs[codepoint] = (tabler_glyphs, tabler_glyphs.cmap[codepoint])
            kept += 1
        elif target is not None:
            codepoint = symbol_names[target]
            explicit += 1
        else:
            # Tabler and SF Symbols share many simple names (cloud-rain/cloud.rain).
            candidate = name.removesuffix("-filled").replace("-", ".")
            if name.endswith("-filled"):
                candidate += ".fill"
            if candidate in symbol_names:
                codepoint = symbol_names[candidate]
                automatic += 1
        if codepoint is not None:
            registry[name] = {
                "category": meta.get("category", SF_CATEGORY),
                "codepoint": f"U+{codepoint:X}",
            }

    not_tabler = sorted(set(icon_map) - set(tabler))
    if not_tabler:
        print(f"note: icon-map.json entries that are not Tabler names: {not_tabler}")

    for name, cp in sorted(symbol_names.items()):
        registry.setdefault(name, {"category": SF_CATEGORY, "codepoint": f"U+{cp:X}"})

    (out_dir / "tabler.json").write_text(json.dumps(registry, indent=2, sort_keys=True) + "\n", "utf-8")
    build_font(sf, glyphs, str(out_dir / "noctalia-tabler.ttf"))

    print(
        f"{len(glyphs)} glyphs, {len(symbol_names)} SF Symbol names, "
        f"{explicit} curated + {automatic} automatic SF mappings, {kept} kept Tabler glyphs "
        f"({len(tabler) - explicit - automatic - kept} Tabler names left unmapped)"
    )


if __name__ == "__main__":
    main()
