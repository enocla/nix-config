{
  lib,
  system,
  ...
}: {
  imports =
    [./kitty]
    ++ lib.optionals (lib.hasSuffix "-linux" system) [
      ./kde
      ./vicinae
    ];
}
