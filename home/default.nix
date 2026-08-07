{
  username,
  configRepoName,
  theme,
  config,
  lib,
  ...
}
: let
  config-dir = "${config.home.homeDirectory}/${configRepoName}/home/config";
  mkLink = config.lib.file.mkOutOfStoreSymlink;
in {
  # Home Manager generates configuration, but package installation is delegated
  # to Homebrew or another external package manager.
  home.packages = lib.mkForce [];

  # Do not build Home Manager's Nix-provided man package or man-page cache.
  programs.man = {
    enable = false;
    generateCaches = false;
  };

  imports = [
    ./programs
    ./shell.nix
  ];

  home.file = {
    # Silence the "Last login: ..." banner printed by /usr/bin/login.
    ".hushlogin".text = "";

    ".config/nvim" = {source = mkLink "${config-dir}/nvim";};
    ".config/karabiner" = {source = mkLink "${config-dir}/karabiner";};
    ".config/Code/User/settings.json" = {source = mkLink "${config-dir}/Code/User/settings.json";};
    ".config/zed" = {source = mkLink "${config-dir}/zed";};
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
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";
  };

  home.enableNixpkgsReleaseCheck = false;
}
