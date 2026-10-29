{
  inputs,
  lib,
  pkgs,
  ...
}: let
  screenshotDir = "Pictures/Screenshots";
  videoDir = "Videos";

  # Noctalia's own "Screenshot saved" / "Recording saved" toasts carry no
  # action (internal notifications cannot), and config.toml filters them out.
  # This watcher replaces them with toasts that reveal the file when clicked.
  captureNotify = pkgs.writeShellApplication {
    name = "capture-notify";
    runtimeInputs = [pkgs.inotify-tools pkgs.libnotify pkgs.glib pkgs.coreutils];
    text = ''
      screenshots="$HOME/${screenshotDir}"
      videos="$HOME/${videoDir}"
      mkdir -p "$screenshots" "$videos"

      file_uri() {
        local LC_ALL=C s="$1" out="" c i
        for ((i = 0; i < ''${#s}; i++)); do
          c="''${s:i:1}"
          case "$c" in
            [a-zA-Z0-9/._~-]) out+="$c" ;;
            *) printf -v c '%%%02X' "'$c"; out+="$c" ;;
          esac
        done
        printf 'file://%s' "$out"
      }

      # Ask the session's file manager (Nautilus, D-Bus activated) to open the
      # folder with the file selected. Nautilus then runs in its own D-Bus
      # service instead of as a child of this watcher.
      reveal() {
        gdbus call --session --dest org.freedesktop.FileManager1 \
          --object-path /org/freedesktop/FileManager1 \
          --method org.freedesktop.FileManager1.ShowItems \
          "['$(file_uri "$1")']" "" >/dev/null
      }

      notify() {
        local action
        # --wait blocks until the toast is clicked or closed; cap it so
        # unattended toasts do not leave processes behind.
        action="$(timeout 1h notify-send --app-name=Captures --icon="$3" \
          --action=default=Show --wait "$1" "$2" </dev/null || true)"
        if [ "$action" = default ]; then
          reveal "$2" || true
        fi
      }

      inotifywait -m -q -e close_write -e moved_to --format '%w%f' "$screenshots" "$videos" |
        while IFS= read -r file; do
          case "$file" in
            "$screenshots"/*.webp) notify "Screenshot saved" "$file" "$file" & ;;
            "$videos"/recording_*.webm) notify "Recording saved" "$file" video-x-generic & ;;
          esac
        done
    '';
  };

  screenRecorder = pkgs.callPackage ../../../pkgs/noctalia-screen-recorder {
    src = inputs.noctalia-plugins;
  };

  # Click a window to capture it at native resolution. Noctalia's
  # screenshot-window needs ext-foreign-toplevel-image-capture-source-manager-v1,
  # which niri lacks, so niri captures the picked window (also copying it to
  # the clipboard) and cwebp converts it to match Noctalia's WebP screenshots.
  captureWindow = pkgs.writeShellApplication {
    name = "capture-window";
    runtimeInputs = [pkgs.niri pkgs.jq pkgs.libwebp pkgs.coreutils];
    text = ''
      id="$(niri msg --json pick-window | jq -r '.id // empty')"
      # Escape or a click outside any window cancels.
      [ -n "$id" ] || exit 0

      tmp="$(mktemp -d)"
      trap 'rm -rf "$tmp"' EXIT
      png="$tmp/window.png"
      niri msg action screenshot-window --id "$id" --path "$png"

      # niri saves in the background; wait until the file stops growing.
      last=-1
      for _ in $(seq 50); do
        sleep 0.1
        size="$(stat -c %s "$png" 2>/dev/null || echo 0)"
        if [ "$size" -gt 0 ] && [ "$size" = "$last" ]; then
          break
        fi
        last="$size"
      done
      [ -s "$png" ] || exit 1

      dir="$HOME/${screenshotDir}"
      mkdir -p "$dir"
      cwebp -quiet -q 90 "$png" -o "$dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S')-window.webp"
    '';
  };
in {
  # Region picker for the screen_recorder plugin.
  home.packages = [pkgs.slurp captureWindow];

  xdg.dataFile."noctalia/plugins/screen_recorder".source = screenRecorder;

  systemd.user.services.capture-notify = {
    Unit = {
      Description = "Clickable notifications for saved screenshots and recordings";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = lib.getExe captureNotify;
      Restart = "always";
      RestartSec = 1;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
