{...}: {
  # App icons (darwin-custom-icons)
  environment.customIcons = {
    enable = true;
    icons = [
      {
        path = "/Applications/Ableton Live 12 Suite.app";
        icon = ./Ableton.icns;
      }
    ];
  };
}
