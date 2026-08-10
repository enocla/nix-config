{
  config,
  configRepoName,
  ...
}: {
  home.file.".local/bin/m" = {
    executable = true;
    text = ''
      #!/bin/sh
      set -eu

      manifest="${config.home.homeDirectory}/${configRepoName}/modules/darwin/malt.nix"
      package="''${2:-}"
      temporary_manifest=""

      cleanup() {
        if [ -n "$temporary_manifest" ]; then
          /bin/rm -f "$temporary_manifest"
        fi
      }
      trap cleanup 0 1 2 15

      usage() {
        echo "Usage: m {i|install|uninstall|remove} <package>" >&2
        exit 2
      }

      find_manifest_list() {
        /usr/bin/awk -v package="$package" '
          /^[[:space:]]*(brews|casks)[[:space:]]*=[[:space:]]*\[$/ {
            list = $1
            in_list = 1
            next
          }
          in_list && /^[[:space:]]*];/ {
            in_list = 0
            next
          }
          in_list {
            value = $0
            sub(/^[[:space:]]*"/, "", value)
            sub(/",?[[:space:]]*$/, "", value)
            if (value == package) {
              print list
            }
          }
        ' "$manifest"
      }

      update_manifest() {
        action="$1"
        list="$2"
        temporary_manifest="$(/usr/bin/mktemp "''${manifest}.XXXXXX")"

        case "$action" in
          add)
            /usr/bin/awk -v list="$list" -v package="$package" '
              /^[[:space:]]*(taps|brews|casks)[[:space:]]*=[[:space:]]*\[$/ {
                in_list = ($1 == list)
                print
                next
              }
              in_list && /^[[:space:]]*];/ {
                print "    \"" package "\","
                in_list = 0
                changed = 1
              }
              { print }
              END {
                if (!changed) {
                  exit 1
                }
              }
            ' "$manifest" > "$temporary_manifest"
            ;;
          remove)
            /usr/bin/awk -v list="$list" -v package="$package" '
              /^[[:space:]]*(taps|brews|casks)[[:space:]]*=[[:space:]]*\[$/ {
                in_list = ($1 == list)
                print
                next
              }
              in_list {
                value = $0
                sub(/^[[:space:]]*"/, "", value)
                sub(/",?[[:space:]]*$/, "", value)
                if (value == package) {
                  changed = 1
                  next
                }
              }
              { print }
              END {
                if (!changed) {
                  exit 1
                }
              }
            ' "$manifest" > "$temporary_manifest"
            ;;
        esac

        /bin/mv "$temporary_manifest" "$manifest"
        temporary_manifest=""
      }

      if [ "$#" -ne 2 ]; then
        usage
      fi

      case "$1" in
        i | install)
          mt install "$package"

          if find_manifest_list | /usr/bin/grep -q .; then
            echo "$package is already declared in $manifest." >&2
            exit 0
          fi

          if mt list --cask --quiet | /usr/bin/grep -Fqx "$package"; then
            update_manifest add casks
          else
            update_manifest add brews
          fi
          ;;
        uninstall | remove)
          list="$(find_manifest_list)"
          mt uninstall "$package"

          if [ -n "$list" ]; then
            update_manifest remove "$list"
          else
            echo "$package was not declared in $manifest." >&2
          fi
          ;;
        *)
          usage
          ;;
      esac
    '';
  };
}
