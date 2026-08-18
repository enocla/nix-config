{
  username,
  configRepoName,
  theme,
  config,
  lib,
  pkgs,
  ...
}: let
  config-dir = "${config.home.homeDirectory}/${configRepoName}/home/config";
  mkLink = config.lib.file.mkOutOfStoreSymlink;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  externalPackage = name: {
    binaries ? [name],
    binaryDir ? "/opt/malt/bin",
    links ? [],
  }:
    if isDarwin
    then
      pkgs.runCommand "external-${name}-999.0.0" {
        version = "999.0.0";
        meta.mainProgram = name;
      } ''
        mkdir -p "$out/bin"
        ${lib.concatMapStringsSep "\n" (binary: "ln -s ${binaryDir}/${binary} \"$out/bin/${binary}\"") binaries}
        ${lib.concatMapStringsSep "\n" (link: "mkdir -p \"$(dirname \"$out/${link.path}\")\"\nln -s ${link.target} \"$out/${link.path}\"") links}
      ''
    else if name == "jj"
    then pkgs.jujutsu
    else builtins.getAttr name pkgs;
in {
  _module.args.externalPackage = externalPackage;

  # Diamond delegates package installation to Malt; Bort uses nixpkgs packages.
  home.packages = lib.mkIf isDarwin (lib.mkForce []);

  programs.man = lib.mkIf isDarwin {
    enable = false;
    generateCaches = false;
  };

  imports = [
    ./programs
    ./shell.nix
  ];

  home.file =
    {
      ".hushlogin".text = "";

      ".config/nvim" = {source = mkLink "${config-dir}/nvim"; recursive = true;};
      ".config/zed" = {source = mkLink "${config-dir}/zed";recursive = true;};
      "${configRepoName}/home/config/nvim/lua/theme/colors.lua".text = ''
        return {
            rosewater = "${theme.colors.rosewater}",
            flamingo = "${theme.colors.flamingo}",
            pink = "${theme.colors.pink}",
            mauve = "${theme.colors.mauve}",
            red = "${theme.colors.red}",
            maroon = "${theme.colors.maroon}",
            peach = "${theme.colors.peach}",
            yellow = "${theme.colors.yellow}",
            green = "${theme.colors.green}",
            teal = "${theme.colors.teal}",
            sky = "${theme.colors.sky}",
            sapphire = "${theme.colors.sapphire}",
            blue = "${theme.colors.blue}",
            lavender = "${theme.colors.lavender}",
            text = "${theme.colors.text}",
            subtext1 = "${theme.colors.subtext1}",
            subtext0 = "${theme.colors.subtext0}",
            overlay2 = "${theme.colors.overlay2}",
            overlay1 = "${theme.colors.overlay1}",
            overlay0 = "${theme.colors.overlay0}",
            surface2 = "${theme.colors.surface2}",
            surface1 = "${theme.colors.surface1}",
            surface0 = "${theme.colors.surface0}",
            base = "${theme.colors.base}",
            mantle = "${theme.colors.mantle}",
            crust = "${theme.colors.crust}",
        }
      '';
    }
    // lib.optionalAttrs isDarwin {
      ".config/karabiner" = {source = mkLink "${config-dir}/karabiner";};
      ".config/paneru/paneru.toml" = {source = mkLink "${config-dir}/paneru/paneru.toml";};
      ".config/Code/User/settings.json" = {source = mkLink "${config-dir}/Code/User/settings.json";};
      ".config/mise/config.toml" = {source = mkLink "${config.home.homeDirectory}/${configRepoName}/extra/mise/config.toml";};
    };

  home = {
    inherit username;
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    stateVersion = "25.11";
  };

  home.enableNixpkgsReleaseCheck = false;
}
