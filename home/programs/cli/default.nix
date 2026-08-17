{
  lib,
  system,
  ...
}: {
  imports =
    [
      ./ai.nix
      ./bat.nix
      ./btop.nix
      ./direnv.nix
      ./fish.nix
      ./git.nix
      ./gpg.nix
      ./jujutsu.nix
      ./helix.nix
      ./lazygit.nix
      ./starship.nix
      ./tmux.nix
      ./zsh.nix
    ]
    ++ lib.optionals (lib.hasSuffix "-darwin" system) [./malttool.nix];
}
