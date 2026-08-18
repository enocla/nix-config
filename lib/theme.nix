{lib}: let
  colorMix = (import ./color-mix.nix {inherit lib;}).mixColors;

  colors = {
    rosewater = "#ffdad6";
    flamingo = "#ffc4bb";
    pink = "#ffb4ab";
    mauve = "#d9c59a";
    red = "#ffb4ab";
    maroon = "#d89e85";
    peach = "#cbc8a4";
    yellow = "#ceca75";
    green = "#a5d0bb";
    teal = "#b2dcc9";
    sky = "#b9e1d2";
    sapphire = "#bedfd4";
    blue = "#c2ddd0";
    lavender = "#c6d9cc";
    text = "#e6e2d5";
    subtext1 = "#cac7b6";
    subtext0 = "#b6b4a0";
    overlay2 = "#939181";
    overlay1 = "#6e6d5e";
    overlay0 = "#48473a";
    surface2 = "#36352c";
    surface1 = "#2b2a22";
    surface0 = "#212018";
    base = "#14140c";
    mantle = "#1c1c14";
    crust = "#0f0e07";
    # rosewater = "#f3c0e5";
    # flamingo = "#fae6ef";
    # pink = "#fae6ef";
    # mauve = "#f4c6e7";
    # red = "#f57f82";
    # maroon = "#f79c82";
    # peach = "#f6c291";
    # yellow = "#f5d098";
    # green = "#dbe6af";
    # teal = "#cbe3b3";
    # sky = "#b3e6db";
    # sapphire = "#afd9e6";
    # blue = "#b2caed";
    # lavender = "#d2bdf3";
    # text = "#f8f9e8";
    # subtext1 = "#adc9bc";
    # subtext0 = "#96b4aa";
    # overlay2 = "#839e9a";
    # overlay1 = "#6f8788";
    # overlay0 = "#58686d";
    # surface2 = "#4a585c";
    # surface1 = "#374145";
    # surface0 = "#2b3337";
    # base = "#232a2e";
    # mantle = "#1c2225";
    # crust = "#171c1f";
  };
in {
  # Utility function to strip the # from hex colors
  rawHexValue = color: builtins.substring 1 6 color;

  inherit colors;

  # Git/delta diff colors (computed from base colors)
  diff = {
    hunkHeader = colorMix colors.base colors.mauve 0.8;
    minusEmph = colorMix colors.base colors.red 0.6;
    minus = colorMix colors.base colors.red 0.8;
    plusEmph = colorMix colors.base colors.green 0.6;
    plus = colorMix colors.base colors.green 0.8;
    purple = colorMix colors.base colors.mauve 0.6;
    blue = colorMix colors.base colors.blue 0.6;
    cyan = colorMix colors.base colors.teal 0.6;
    yellow = colorMix colors.base colors.yellow 0.6;
  };

  # Shared application and compositor UI settings
  ui = {
    cornerRadius = 12;
    fontFamily = "SF Pro Text";
    monospaceFontFamily = "BerkeleyMono Nerd Font";
    findHighlight = colorMix colors.base colors.sky 0.5;
  };
}
