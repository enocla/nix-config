{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
  stdenvNoCC,
}: let
  pythonEnv = python3.withPackages (pythonPackages:
    with pythonPackages; [
      fuse
      jsonpickle
      pyicloud
      pyyaml
      rich
    ]);
in
  stdenvNoCC.mkDerivation {
    pname = "icloud-linux";
    version = "unstable-d2fa0ba";

    src = fetchFromGitHub {
      owner = "IsmaeelAkram";
      repo = "icloud-linux";
      rev = "d2fa0bab7409c793861cf4c3ecb0a4e592464959";
      hash = "sha256-8RnUPYW74Vyl1ixoVIIio44flQbhpxTayQVo8vl1oW4=";
    };

    nativeBuildInputs = [makeWrapper];
    doInstallCheck = true;

    installPhase = ''
            runHook preInstall
            install -d "$out/share/icloud-linux" "$out/bin"
            cp -R . "$out/share/icloud-linux/"

            # The upstream launcher bootstraps a mutable virtualenv. Nix supplies the
            # complete runtime while keeping the upstream CLI's setup/auth state in
            # the user's home directory.
            substituteInPlace "$out/share/icloud-linux/icloudctl" \
              --replace-fail 'CONFIG_FILE="$CONFIG_DIR/config.yaml"' 'CONFIG_FILE="$CONFIG_DIR/config.yaml"
      SYNC_PATHS_FILE="$CONFIG_DIR/sync-paths.yaml"' \
              --replace-fail 'ensure_venv() {' 'ensure_venv() { :; return 0; } # disabled by Nix
            ensure_venv_legacy() {' \
              --replace-fail '$REPO_DIR/.venv/bin/python' '${pythonEnv}/bin/python' \
              --replace-fail '/usr/bin/fusermount' '/run/wrappers/bin/fusermount'

            # The preference fragment is optional and user-managed by Home Manager.
            # It is read only while creating or configuring a config file, so the
            # mutable credentials and authentication cookies remain user-owned.
            substituteInPlace "$out/share/icloud-linux/icloudctl" \
              --replace-fail '    cp "$REPO_DIR/config.example.yaml" "$CONFIG_FILE"
          chmod 600 "$CONFIG_FILE"' '    cp "$REPO_DIR/config.example.yaml" "$CONFIG_FILE"
          if [[ -f "$SYNC_PATHS_FILE" ]]; then
            printf "\n" >> "$CONFIG_FILE"
            cat "$SYNC_PATHS_FILE" >> "$CONFIG_FILE"
          fi
          chmod 600 "$CONFIG_FILE"' \
              --replace-fail '  chmod 600 "$CONFIG_FILE"
        echo "Wrote $CONFIG_FILE"' '  if [[ -f "$SYNC_PATHS_FILE" ]]; then
          printf "\n" >> "$CONFIG_FILE"
          cat "$SYNC_PATHS_FILE" >> "$CONFIG_FILE"
        fi
        chmod 600 "$CONFIG_FILE"
        echo "Wrote $CONFIG_FILE"'

            makeWrapper "$out/share/icloud-linux/icloudctl" "$out/bin/icloudctl"
            runHook postInstall
    '';

    # Exercise configuration creation without authentication, network access,
    # service management, or changes to the invoking user's home directory.
    installCheckPhase = ''
      runHook preInstallCheck
      source "$out/share/icloud-linux/icloudctl" --help >/dev/null
      CONFIG_DIR="$TMPDIR/icloud-config-test/config"
      STATE_DIR="$TMPDIR/icloud-config-test/state"
      CACHE_DIR="$TMPDIR/icloud-config-test/cache"
      SERVICE_DIR="$TMPDIR/icloud-config-test/services"
      CONFIG_FILE="$CONFIG_DIR/config.yaml"
      SYNC_PATHS_FILE="$CONFIG_DIR/sync-paths.yaml"
      ensure_dirs
      printf 'sync_paths:\n  - /Test\n' > "$SYNC_PATHS_FILE"
      create_config_if_missing
      ${pythonEnv}/bin/python -c 'import sys, yaml; assert yaml.safe_load(open(sys.argv[1]))["sync_paths"] == ["/Test"]' "$CONFIG_FILE"
      cp "$CONFIG_FILE" "$TMPDIR/original-config.yaml"
      create_config_if_missing
      cmp "$CONFIG_FILE" "$TMPDIR/original-config.yaml"
      printf 'test-password\n' | cmd_configure test@example.invalid
      ${pythonEnv}/bin/python -c 'import sys, yaml; c = yaml.safe_load(open(sys.argv[1])); assert c["sync_paths"] == ["/Test"] and c["username"] == "test@example.invalid" and c["password"] == "test-password"' "$CONFIG_FILE"
      test "$(stat -c %a "$CONFIG_FILE")" = 600
      # The reusable package must also work without a personal defaults file.
      CONFIG_FILE="$CONFIG_DIR/unrestricted.yaml"
      SYNC_PATHS_FILE="$CONFIG_DIR/no-defaults.yaml"
      create_config_if_missing
      ${pythonEnv}/bin/python -c 'import sys, yaml; assert "sync_paths" not in yaml.safe_load(open(sys.argv[1]))' "$CONFIG_FILE"
      runHook postInstallCheck
    '';

    meta = {
      description = "Mount iCloud Drive as a local FUSE filesystem";
      homepage = "https://github.com/IsmaeelAkram/icloud-linux";
      platforms = lib.platforms.linux;
      mainProgram = "icloudctl";
    };
  }
