{
  host,
  inputs,
  ...
}: let
  equicord = inputs.nixcord.packages.${host.system}.equicord.overrideAttrs (
    oldAttrs:
      if oldAttrs.version == "1.15.7.0-2026-09-26"
      then {
        # Nixcord's current Equicord dependency hash does not match its locked source.
        pnpmDeps = oldAttrs.pnpmDeps.overrideAttrs (_: {
          outputHash = "sha256-VQQtlUCCuOVoQxBcYG7BWQXY21R8X46+kI1RIcX8RY8=";
        });
      }
      else {}
  );
in {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    discord.equicord = {
      enable = true;
      package = equicord;
    };
  };
}
