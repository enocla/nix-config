{
  lib,
  host,
  ...
}: {
  # Kitty is the active terminal. Ghostty remains available as an optional
  # module for hosts that explicitly import ./ghostty.
  imports =
    [
      ./kitty
      ./nixcord.nix
      ./vicinae
    ]
    ++ lib.optionals (lib.hasSuffix "-linux" host.system) [
      ./keybindings.nix
      ./kde
    ];
}
