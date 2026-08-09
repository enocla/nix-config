{
  lib,
  theme,
  colorMix,
  externalPackage,
  ...
}: let
  c = theme.colors;
  mixedColor = (colorMix {inherit lib;}).mixColors c.base c.green 0.8;
in {
  programs.starship = {
    enable = true;
    package = externalPackage "starship" {};

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      format = "$shell$directory$git_branch$git_status$character";

      directory = {
        style = "blue";
        format = "[$path ]($style)";
        truncation_length = 99;
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      git_branch = {
        symbol = "󰘬";
        format = "[ [$symbol](bold green bg:${mixedColor}) $branch ](bg:${mixedColor} green)";
      };

      git_status = {
        disabled = false;
        ignore_submodules = false;
        ahead = "[􀄨 ($count) ](blue)";
        behind = "[􀄩 ($count) ](yellow)";
        deleted = "[􀆄 ($count) ](red)";
        diverged = "[􀢁 ($count) ](red)";
        format = "[ $all_status$ahead_behind]()";
        modified = "[􁚛 ($count) ](yellow)";
        renamed = "[􀈏  ($count) ](purple)";
        staged = "[􀥄 ($count) ](cyan)";
        stashed = "[􀐚 ($count) ](blue)";
      };

      character = {
        disabled = false;
        success_symbol = "[􀄫](green)";
        error_symbol = "[􀄫](red)";
      };

      shell = {
        zsh_indicator = " zsh";
        nu_indicator = " nu";
        fish_indicator = "";
        unknown_indicator = "";
        style = "yellow";
        disabled = false;
      };

      line_break = {
        disabled = false;
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold cyan";
      };
    };
  };
}
