{
  lib,
  system,
  ...
}: {
  imports =
    [
      ./cli
      ./gui
    ]
    ++ lib.optionals (lib.hasSuffix "-linux" system) [./niri];
}
