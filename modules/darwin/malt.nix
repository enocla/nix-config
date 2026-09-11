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
    "fastpotify"
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

      if [ -f "$maltBrewfile" ]; then
        echo "Removing stale declared Malt packages..."
        /usr/bin/awk '
          NR == FNR {
            declared[$0] = 1
            next
          }
          !($0 in declared) && ($1 == "brew" || $1 == "cask") {
            package = $0
            sub(/^[^"]*"/, "", package)
            sub(/"$/, "", package)
            print $1, package
          }
        ' ${brewfile} "$maltBrewfile" |
          while IFS=" " read -r type package; do
            if ! /usr/bin/sudo -H -u ${username} /usr/local/bin/malt list --quiet | /usr/bin/grep -Fqx "$package"; then
              continue
            fi

            if [ "$type" = "brew" ] && /usr/bin/sudo -H -u ${username} /usr/local/bin/malt uses --quiet "$package" | /usr/bin/grep -q .; then
              echo "Keeping $package; another installed package requires it."
              continue
            fi

            /usr/bin/sudo -H -u ${username} /usr/local/bin/malt uninstall "$package"
          done
      fi

      maltBrewfileTmp="$(/usr/bin/sudo -H -u ${username} /usr/bin/mktemp "$maltStateDir/.Brewfile.XXXXXX")"
      /usr/bin/sudo -H -u ${username} /bin/cp ${brewfile} "$maltBrewfileTmp"
      /usr/bin/sudo -H -u ${username} /bin/chmod u+w "$maltBrewfileTmp"
      /usr/bin/sudo -H -u ${username} /bin/mv -f "$maltBrewfileTmp" "$maltBrewfile"
    fi

    echo "Cleaning up unused Malt dependencies..."
    /usr/bin/sudo -H -u ${username} /usr/local/bin/malt purge --unused-deps --yes
  '';
}
