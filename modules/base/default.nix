{pkgs, ...}: let
  berkeleyMonoNerdFont = pkgs.stdenvNoCC.mkDerivation {
    pname = "berkeley-mono-nerd-font";
    version = "1";
    src = ../../extra/fonts/BerkeleyMonoNerdFont.tar.gz.enc;
    nativeBuildInputs = [
      pkgs.gnutar
      pkgs.gzip
      pkgs.openssl
    ];
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/fonts/truetype" "$TMPDIR/berkeley-mono"
      openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
        -pass pass:4506c9b014f1da6bbe00170dfcf226097211cfdeb6799ea41bfc968e6e5609e9 \
        -in "$src" | tar -xzf - -C "$TMPDIR/berkeley-mono"
      install -Dm644 "$TMPDIR/berkeley-mono/BerkeleyMonoNerdFont/"*.ttf \
        -t "$out/share/fonts/truetype"
      runHook postInstall
    '';
  };
  sfProText = pkgs.stdenvNoCC.mkDerivation {
    pname = "sf-pro-text";
    version = "1";
    src = ../../extra/fonts/SFProText.tar.gz.enc;
    nativeBuildInputs = [
      pkgs.gnutar
      pkgs.gzip
      pkgs.openssl
    ];
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/fonts/opentype" "$TMPDIR/sf-pro-text"
      openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
        -pass pass:4506c9b014f1da6bbe00170dfcf226097211cfdeb6799ea41bfc968e6e5609e9 \
        -in "$src" | tar -xzf - -C "$TMPDIR/sf-pro-text"
      install -Dm644 "$TMPDIR/sf-pro-text/SFProText/"*.otf \
        -t "$out/share/fonts/opentype"
      runHook postInstall
    '';
  };
in {
  fonts.packages = [
    berkeleyMonoNerdFont
    sfProText
    pkgs.nerd-fonts.symbols-only
  ];
}
