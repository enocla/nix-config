{theme, ...}: let
  c = theme.colors;
in {
  programs.lazygit = {
    enable = true;
    package = null;
    settings = {
      os = {
        edit = "nvim {{filename}}";
        editAtLine = "nvim +{{line}} {{filename}}";
        editAtLineAndWait = "nvim +{{line}} {{filename}}";
        openDirInEditor = "nvim {{dir}}";
      };
      git.diffRenderers = [
        {
          colorArg = "always";
          command = "delta --dark --paging=never";
        }
      ];
      git.overrideGpg = true;
      gui = {
        border = "single";
        nerdFontsVersion = "3";
        theme = {
          activeBorderColor = [
            "cyan"
            "bold"
          ];
          inactiveBorderColor = [c.overlay1];
          optionsTextColor = ["yellow"];
          selectedLineBgColor = [c.surface1];
          cherryPickedCommitBgColor = [c.surface1];
          cherryPickedCommitFgColor = [c.pink];
          unstagedChangesColor = [c.red];
          defaultFgColor = [c.text];
          searchingActiveBorderColor = [c.rosewater];
        };
        authorColors = {
          "Tnixc" = c.teal;
        };
        unspecifiedAuthorColors = [
          c.red
          c.maroon
          c.pink
          c.flamingo
          c.rosewater
          c.peach
          c.yellow
          c.green
          c.sky
          c.sapphire
          c.blue
          c.lavender
          c.mauve
        ];
      };
    };
  };
}
