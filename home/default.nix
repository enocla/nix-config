{
  host,
  inputs,
  theme,
  config,
  lib,
  pkgs,
  ...
}: let
  config-dir = "${host.checkoutPath}/home/config";
  mkLink = config.lib.file.mkOutOfStoreSymlink;
  inherit (host) homeDirectory username;
  inherit (inputs) sops-nix;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs.man = lib.mkIf isDarwin {
    enable = false;
    generateCaches = false;
  };

  imports = [
    sops-nix.homeManagerModules.sops
    ./icloud.nix
    ./programs
    ./shell.nix
    ./theme-css-server.nix
  ];

  home.file =
    {
      ".hushlogin".text = "";

      ".config/nvim" = {
        source = mkLink "${config-dir}/nvim";
        recursive = true;
      };
      ".config/zed" = {
        source = mkLink "${config-dir}/zed";
        recursive = true;
      };
    }
    // lib.optionalAttrs isDarwin {
      ".config/karabiner" = {source = mkLink "${config-dir}/karabiner";};
      ".config/Code/User/settings.json" = {source = mkLink "${config-dir}/Code/User/settings.json";};
      ".config/mise/config.toml" = {source = mkLink "${host.checkoutPath}/extra/mise/config.toml";};
    };

  # This generated file lives outside the editable checkout. init.lua
  # preloads theme.colors from it while preserving existing consumers.
  xdg.dataFile."nix-config/theme-colors.json".text = builtins.toJSON theme.colors;

  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = host.homeStateVersion;
  };
}
