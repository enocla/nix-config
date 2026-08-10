{...}: {
  # Determinate Nix manages nix.conf and includes this file for local policy.
  nix.enable = false;

  environment.etc."nix/nix.custom.conf".text = ''
    http-connections = 128
    max-substitution-jobs = 128
    builders-use-substitutes = true
    extra-substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://nix-community.cachix.org
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';
}
