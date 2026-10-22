# Noctalia with every icon rendered from SF Symbols (via the SF Pro font).
#
# Noctalia loads all icons from assets/fonts/noctalia-tabler.ttf and resolves
# names through assets/fonts/tabler.json. This builds replacements for both
# from SF Pro and points the wrapped binary at them with NOCTALIA_ASSETS_DIR.
# Curated Tabler -> SF Symbol mappings live in icon-map.json ("tabler:<name>"
# keeps the original Noctalia glyph); SF Symbol names (e.g. "wifi.slash") are
# also accepted anywhere Noctalia takes an icon name.
{
  lib,
  fetchurl,
  linkFarm,
  makeWrapper,
  python3,
  runCommand,
  symlinkJoin,
  noctalia,
  sf-pro-text,
  # Uniform glyph scale; 0.8 matches SF Symbols to Tabler's optical size.
  scale ? 0.8,
}: let
  # Name/glyph lists exported from the SF Symbols app. Codepoints are stable
  # across releases; 7.2 matches the installed SF Pro, older lists add names
  # that were renamed or dropped since.
  symbolSourcesRev = "6204766fe6ae44c2a71cea9923ff9da3ba8be96b";
  fetchSymbolList = version: file: hash:
    fetchurl {
      url = "https://raw.githubusercontent.com/MoOx/sf-symbols-svg/${symbolSourcesRev}/sources/${version}/${file}.txt";
      inherit hash;
    };
  mkSymbolSource = version: hashes:
    linkFarm "sf-symbols-${version}-names" {
      "names.txt" = fetchSymbolList version "names" hashes.names;
      "symbols.txt" = fetchSymbolList version "symbols" hashes.symbols;
    };
  symbolSources = [
    (mkSymbolSource "6.0" {
      names = "sha256-yEppz8XBqEUk0X3Xhpcg6NwpaYw0mdSSbRsA2hQAQuc=";
      symbols = "sha256-59zXGgKVplBMd76LhDJAeShneO/JelqJjePoP7Kn9Uk=";
    })
    (mkSymbolSource "7.0" {
      names = "sha256-B2Bd373aR5BbSanMdYaaysN3xlHzsAN3fEhbf4xsTZg=";
      symbols = "sha256-aJSfumzch4lVnARvTARRuplBXx+Pcs2ajBlUsSs7Cqw=";
    })
    (mkSymbolSource "7.2" {
      names = "sha256-0R4/Xjx/I74aq7qRwFCQ7TriWGXFC04KUfGVS3fIxvo=";
      symbols = "sha256-HrFqKQQtNcbnq4DmtrLcIpg8pRvE9ygHFBdx+NcJdxo=";
    })
  ];

  upstreamAssets = "${noctalia}/share/noctalia/assets";

  iconFont =
    runCommand "noctalia-sf-symbols-font" {
      nativeBuildInputs = [(python3.withPackages (p: [p.fonttools]))];
    } ''
      python3 ${./build.py} \
        ${sf-pro-text}/share/fonts/opentype/SF-Pro-Text-Regular.otf \
        ${upstreamAssets}/fonts/noctalia-tabler.ttf \
        ${upstreamAssets}/fonts/tabler.json \
        ${./icon-map.json} \
        ${toString scale} \
        "$out" \
        ${lib.concatStringsSep " " symbolSources}
    '';

  # Upstream asset bundle with the icon font and registry swapped out.
  assets = runCommand "noctalia-sf-symbols-assets" {} ''
    mkdir -p "$out/fonts"
    for entry in ${upstreamAssets}/*; do
      [ "$(basename "$entry")" = fonts ] || ln -s "$entry" "$out/"
    done
    ln -s ${iconFont}/noctalia-tabler.ttf ${iconFont}/tabler.json "$out/fonts/"
  '';
in
  symlinkJoin {
    name = "noctalia-sf-symbols-${noctalia.version}";
    paths = [noctalia];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      rm "$out/bin/noctalia"
      makeWrapper ${lib.getExe noctalia} "$out/bin/noctalia" \
        --set NOCTALIA_ASSETS_DIR ${assets}
    '';
    passthru = {inherit assets iconFont;};
    inherit (noctalia) version meta;
  }
