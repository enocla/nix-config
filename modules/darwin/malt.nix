{
  lib,
  pkgs,
  username,
  ...
}: let
  taps = [
    "empellio/tap"
    "kcl-lang/tap"
    "keith/formulae"
    "crmne/tap"
  ];

  brews = [
    "elio"
    "oxmgr"
  ];

  casks = [
    "codex"
    "craft"
    "helium-browser"
    "linearmouse"
    "microsoft-teams"
    "microsoft-word"
    "motrix"
    "nordvpn"
    "parsec"
    "bettercmdtab"
    "crmne/tap/fastpotify"
  ];

  format = type: packages:
    lib.concatMapStringsSep "\n" (package: ''${type} "${package}"'') packages;

  brewfile = pkgs.writeText "Brewfile" ''
    ${format "tap" taps}
    ${format "brew" brews}
    ${format "cask" casks}
  '';
in {
  system.activationScripts.extraActivation.text = ''
    maltStateDir="/Users/${username}/.local/state/nix-darwin"
    maltBrewfile="$maltStateDir/Brewfile"

    if ! /usr/bin/sudo -H -u ${username} /usr/bin/cmp -s ${brewfile} "$maltBrewfile"; then
      echo "Malt Brewfile changed; installing packages..."
      /usr/bin/sudo -H -u ${username} /bin/mkdir -p "$maltStateDir"
      /usr/bin/sudo -H -u ${username} /usr/local/bin/malt bundle install ${brewfile}

      maltBrewfileTmp="$(/usr/bin/sudo -H -u ${username} /usr/bin/mktemp "$maltStateDir/.Brewfile.XXXXXX")"
      /usr/bin/sudo -H -u ${username} /bin/cp ${brewfile} "$maltBrewfileTmp"
      /usr/bin/sudo -H -u ${username} /bin/chmod u+w "$maltBrewfileTmp"
      /usr/bin/sudo -H -u ${username} /bin/mv -f "$maltBrewfileTmp" "$maltBrewfile"
    fi

    echo "Removing undeclared Malt packages..."
    if ! /usr/bin/sudo -H -u ${username} /usr/local/bin/malt bundle cleanup ${brewfile} --yes; then
      echo "Malt cleanup kept packages required by installed packages; continuing with orphan cleanup."
    fi

    echo "Cleaning up unused Malt dependencies..."
    /usr/bin/sudo -H -u ${username} /usr/local/bin/malt purge --unused-deps --yes
  '';
}
