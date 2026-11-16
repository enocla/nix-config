{
  lib,
  theme,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        monospace = [
          "BerkeleyMono Nerd Font"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [theme.ui.fontFamily];
        serif = [theme.ui.fontFamily];
      };
      aliases = lib.genAttrs ["Helvetica" "Arial"] (_: {
        prefer = [theme.ui.fontFamily];
      });
      # ss01/ss02 are baked into our Inter fonts. Keep contextual alternates
      # enabled in applications that also read Fontconfig's feature defaults.
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="font">
            <test name="family" compare="eq">
              <string>${theme.ui.fontFamily}</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>ss02=1</string>
              <string>calt=1</string>
              <string>ss01=1</string>
              <string>zero=0</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
