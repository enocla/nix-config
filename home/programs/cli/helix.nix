{...}: {
  programs.helix = {
    enable = true;
    package = null;
    settings = {
      theme = "autumn_night_transparent";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "block";
        };
      };
    };
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = {};
      };
    };
  };
}
