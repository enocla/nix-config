{
  lib,
  pkgs,
  ...
}: {
  # Keep the vault boundary in Home Manager while leaving config.yaml,
  # credentials, cookies, and service state mutable for icloudctl.
  xdg.configFile."icloud-linux/sync-paths.yaml" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    text = ''
      sync_paths:
        - /Obsidian
    '';
  };

  # Existing config.yaml, credentials, cookies, and service state stay mutable.
  # The package consumes this fragment only when it creates or configures a
  # config file, so changing generations cannot rewrite an authenticated setup.
}
