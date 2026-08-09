{
  theme,
  gpgKey,
  ...
}: let
  c = theme.colors;
  d = theme.diff;
in {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #

  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  programs.git = {
    enable = true;
    package = null;
    lfs = {
      enable = true;
      package = null;
    };

    settings = {
      user.name = "Tnixc";
      user.email = "tnixxc@gmail.com";
      user.signingkey = gpgKey;

      commit.gpgsign = true;
      core.pager = "delta --dark";
      core.autocrlf = "input";
      diff.algorithm = "histogram";
      merge.conflictstyle = "diff3";

      delta = {
        line-numbers = true;
        syntax-theme = "custom";
        blame-palette = [
          c.base
          c.mantle
          c.crust
          c.surface0
          c.surface1
        ];
        dark = true;
        file-decoration-style = c.text;
        file-style = c.text;
        hunk-header-decoration-style = d.hunkHeader;
        hunk-header-file-style = d.hunkHeader;
        hunk-header-line-number-style = d.hunkHeader;
        hunk-header-style = d.hunkHeader;
        line-numbers-left-style = c.overlay0;
        line-numbers-minus-style = "bold ${c.red}";
        line-numbers-plus-style = "bold ${c.green}";
        line-numbers-right-style = c.overlay0;
        line-numbers-zero-style = c.overlay0;
        minus-emph-style = "bold syntax ${d.minusEmph}";
        minus-style = "syntax ${d.minus}";
        plus-emph-style = "bold syntax ${d.plusEmph}";
        plus-style = "syntax ${d.plus}";
        map-styles = [
          "bold purple => syntax ${d.purple}"
          "bold blue => syntax ${d.blue}"
          "bold cyan => syntax ${d.cyan}"
          "bold yellow => syntax ${d.yellow}"
        ];
      };

      diff.colorMoved = "default";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
