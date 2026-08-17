{
  lib,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) fontFamily;

  rgb = color: let
    hex = theme.rawHexValue color;
    channel = offset:
      toString ((builtins.fromTOML "value = 0x${builtins.substring offset 2 hex}").value);
  in
    lib.concatStringsSep "," (map channel [0 2 4]);

  font = "${fontFamily},10,-1,5,50,0,0,0,0,0";
  common = {
    decoration = rgb c.mauve;
    active = rgb c.mauve;
    inactive = rgb c.subtext0;
    link = rgb c.blue;
    negative = rgb c.red;
    neutral = rgb c.yellow;
    normal = rgb c.text;
    positive = rgb c.green;
    visited = rgb c.pink;
  };

  colorSection = {
    backgroundAlternate,
    backgroundNormal,
    foregroundInactive ? common.inactive,
    foregroundNormal ? common.normal,
    foregroundActive ? common.active,
    foregroundLink ? common.link,
    foregroundNegative ? common.negative,
    foregroundNeutral ? common.neutral,
    foregroundPositive ? common.positive,
    foregroundVisited ? common.visited,
  }: ''
    BackgroundAlternate=${backgroundAlternate}
    BackgroundNormal=${backgroundNormal}
    DecorationFocus=${common.decoration}
    DecorationHover=${common.decoration}
    ForegroundActive=${foregroundActive}
    ForegroundInactive=${foregroundInactive}
    ForegroundLink=${foregroundLink}
    ForegroundNegative=${foregroundNegative}
    ForegroundNeutral=${foregroundNeutral}
    ForegroundNormal=${foregroundNormal}
    ForegroundPositive=${foregroundPositive}
    ForegroundVisited=${foregroundVisited}
  '';

  section = name: values: ''
    [${name}]
    ${colorSection values}
  '';
in {
  xdg.configFile."kdeglobals" = {
    force = true;
    text = ''
      [General]
      ColorScheme=NixConfig
      fixed=${font}
      font=${font}
      menuFont=${font}
      smallestReadableFont=${font}
      taskbarFont=${font}
      toolBarFont=${font}

      [KDE]
      contrast=4
    '';
  };

  xdg.dataFile."color-schemes/NixConfig.colors".text = ''
    [KDE]
    contrast=4

    [General]
    ColorScheme=NixConfig
    Name=Nix Config

    [ColorEffects:Disabled]
    Color=${rgb c.overlay0}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${rgb c.overlay1}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    ${section "Colors:Button" {
      backgroundAlternate = rgb c.surface0;
      backgroundNormal = rgb c.surface1;
    }}

    ${section "Colors:Complementary" {
      backgroundAlternate = rgb c.mantle;
      backgroundNormal = rgb c.base;
    }}

    ${section "Colors:Header" {
      backgroundAlternate = rgb c.mantle;
      backgroundNormal = rgb c.base;
    }}

    ${section "Colors:Header][Inactive" {
      backgroundAlternate = rgb c.surface0;
      backgroundNormal = rgb c.mantle;
    }}

    ${section "Colors:Selection" {
      backgroundAlternate = rgb c.surface1;
      backgroundNormal = rgb c.mauve;
      foregroundActive = rgb c.crust;
      foregroundInactive = rgb c.overlay1;
      foregroundLink = rgb c.crust;
      foregroundNegative = rgb c.red;
      foregroundNeutral = rgb c.yellow;
      foregroundNormal = rgb c.crust;
      foregroundPositive = rgb c.green;
      foregroundVisited = rgb c.crust;
    }}

    ${section "Colors:Tooltip" {
      backgroundAlternate = rgb c.mantle;
      backgroundNormal = rgb c.base;
    }}

    ${section "Colors:View" {
      backgroundAlternate = rgb c.surface0;
      backgroundNormal = rgb c.base;
    }}

    ${section "Colors:Window" {
      backgroundAlternate = rgb c.mantle;
      backgroundNormal = rgb c.base;
    }}

    [WM]
    activeBackground=${rgb c.base}
    activeBlend=${rgb c.text}
    activeForeground=${rgb c.text}
    inactiveBackground=${rgb c.mantle}
    inactiveBlend=${rgb c.subtext1}
    inactiveForeground=${rgb c.subtext0}
  '';
}
