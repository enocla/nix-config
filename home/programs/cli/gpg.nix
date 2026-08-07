{...}: {
  programs.gpg = {
    enable = true;
    settings = {
      personal-digest-preferences = "SHA512";
      cert-digest-algo = "SHA512";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      no-emit-version = true;
    };
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program /opt/homebrew/bin/pinentry-mac
    default-cache-ttl 3600
    max-cache-ttl 7200
  '';
}
