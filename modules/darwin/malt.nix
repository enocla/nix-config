{
  lib,
  pkgs,
  username,
  ...
}: let
  taps = [
    "Sanyam-G/switch"
    "empellio/tap"
    "kcl-lang/tap"
    "keith/formulae"
  ];

  brews = [
    "aria2"
    "bat"
    "btop"
    "chafa"
    "clang-format"
    "coreutils"
    "direnv"
    "docker"
    "dua-cli"
    "elio"
    "eza"
    "ffmpeg"
    "fish"
    "fzf"
    "gcc"
    "git"
    "git-crypt"
    "git-delta"
    "git-lfs"
    "gnupg"
    "gzip"
    "lame"
    "lazygit"
    "lazyjj"
    "libogg"
    "libsoundio"
    "libvmaf"
    "libvorbis"
    "libvpx"
    "llvm"
    "lsusb"
    "lua"
    "lzo"
    "micropython"
    "mosh"
    "nickel"
    "nmap"
    "nowplaying-cli"
    "opus"
    "oxmgr"
    "paneru"
    "pinentry-mac"
    "sdl2-compat"
    "sdl3"
    "starship"
    "svt-av1"
    "switchaudio-osx"
    "tldr"
    "tmux"
    "tomlplusplus"
    "watch"
    "webp"
    "wget"
    "x264"
    "x265"
    "yaml-cpp"
    "yarn"
    "zlib"
    "zoxide"
    "zsh-autosuggestions"
    "zsh-history-substring-search"
    "zsh-syntax-highlighting"
  ];

  casks = [
    "anki"
    "blender"
    "codex"
    "craft"
    "font-maple-mono-nf"
    "font-maple-mono-normal-nf-cn"
    "google-chrome"
    "helium-browser"
    "iina"
    "kitty"
    "linearmouse"
    "microsoft-teams"
    "microsoft-word"
    "motrix"
    "nordvpn"
    "orbstack"
    "parsec"
    "prismlauncher"
    "shottr"
    "switch"
    "visual-studio-code"
    "zed"
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
