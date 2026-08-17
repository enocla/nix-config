{
  darwin-custom-icons,
  username,
  ...
}: {
  imports = [
    ../../modules/base
    ../../modules/darwin
    darwin-custom-icons.darwinModules.default
    ../../modules/icons
  ];

  nixpkgs.overlays = [
    (_final: prev: let
      externalZshPlugin = name:
        prev.runCommand "external-${name}-999.0.0" {} ''
          mkdir -p "$out/share"
          ln -s /opt/malt/share/${name} "$out/share/${name}"
        '';
    in
      prev.lib.genAttrs [
        "zsh-autosuggestions"
        "zsh-history-substring-search"
        "zsh-syntax-highlighting"
      ]
      externalZshPlugin)
  ];

  environment.shells = ["/opt/homebrew/bin/fish"];

  users.users.${username} = {
    home = "/Users/${username}";
    description = username;
    shell = "/opt/homebrew/bin/fish";
  };
}
