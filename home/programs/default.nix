{
  lib,
  host,
  ...
}: {
  imports =
    [
      ./cli
      ./gui
    ]
    ++ lib.optionals (lib.hasSuffix "-linux" host.system) [./niri];
}
