{
  lib,
  pkgs,
  theme,
  config,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  port = 8765;
  cssUrl = "http://localhost:${toString port}/theme.css";

  # Home Manager file targets are relative to the user's home directory.
  obsidianSnippetPath =
    if isDarwin
    then "Library/Mobile Documents/iCloud~md~obsidian/Documents/Mnemosyne/.obsidian/snippets/colors.css"
    else "placeholder/obsidian/.obsidian/snippets/colors.css";

  hexToRgb = color: let
    hex = lib.removePrefix "#" (lib.toLower color);
    parseHex = value: (lib.fromTOML "value = 0x${value}").value;
  in {
    r = parseHex (lib.substring 0 2 hex);
    g = parseHex (lib.substring 2 2 hex);
    b = parseHex (lib.substring 4 2 hex);
  };

  colorVariables = lib.concatMapStringsSep "\n" (
    name: "  --${name}: ${theme.colors.${name}};"
  ) (lib.attrNames theme.colors);

  rgbVariables = lib.concatMapStringsSep "\n" (
    name: let
      rgb = hexToRgb theme.colors.${name};
    in "  --${name}-rgb: ${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b};"
  ) (lib.attrNames theme.colors);

  themeCss = pkgs.writeText "theme.css" ''
    :root {
    ${colorVariables}
    ${rgbVariables}
      --corner-radius: ${toString theme.ui.cornerRadius}px;
      --font-family: "${theme.ui.fontFamily}";
      --monospace-font-family: "${theme.ui.monospaceFontFamily}";
      --find-highlight: ${theme.ui.findHighlight};
    }
  '';

  site = pkgs.linkFarm "theme-css-site" [
    {
      name = "theme.css";
      path = themeCss;
    }
  ];

  server = pkgs.writeText "theme-css-server.py" ''
    import argparse
    from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


    class ThemeRequestHandler(SimpleHTTPRequestHandler):
        # Browsers and embedded webviews may send Origin: null for file:// pages.
        def end_headers(self):
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
            self.send_header("Access-Control-Allow-Headers", "*")
            super().end_headers()

        def do_OPTIONS(self):
            self.send_response(204)
            self.send_header("Content-Length", "0")
            self.end_headers()


    class ThemeServer(ThreadingHTTPServer):
        daemon_threads = True
        allow_reuse_address = True


    parser = argparse.ArgumentParser(description="Serve the generated nix-config theme CSS")
    parser.add_argument("--directory", required=True)
    parser.add_argument("--bind", default="127.0.0.1")
    parser.add_argument("--port", type=int, required=True)
    args = parser.parse_args()

    server = ThemeServer(
        (args.bind, args.port),
        lambda *handler_args: ThemeRequestHandler(
            *handler_args, directory=args.directory
        ),
    )
    server.serve_forever()
  '';

  programArguments = [
    "${pkgs.python3}/bin/python3"
    "${server}"
    "--directory"
    "${site}"
    "--bind"
    "127.0.0.1"
    "--port"
    (toString port)
  ];

  execStart = lib.escapeShellArgs programArguments;
in {
  # Consumers can import the literal URL above; it is also exposed as THEME_CSS_URL.
  home.sessionVariables.THEME_CSS_URL = cssUrl;

  home.file.${obsidianSnippetPath} = lib.mkIf isDarwin {
    source = themeCss;
  };

  launchd.agents.theme-css-server = lib.mkIf isDarwin {
    enable = true;
    config = {
      ProgramArguments = programArguments;
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      ThrottleInterval = 5;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/theme-css-server.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/theme-css-server.error.log";
    };
  };

  systemd.user.services.theme-css-server = lib.mkIf (!isDarwin) {
    Unit = {
      Description = "Serve the generated nix-config theme CSS";
      After = ["default.target"];
    };
    Service = {
      ExecStart = execStart;
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
