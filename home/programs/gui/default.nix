{
  lib,
  system,
  ...
}: {
  imports =
    [
      ./kitty
      ./nixcord.nix
    ]
    ++ lib.optionals (lib.hasSuffix "-linux" system) [
      ./kde
      ./vicinae
    ];
}
