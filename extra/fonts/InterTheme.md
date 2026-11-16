# Inter theme fonts

`InterTheme.tar.gz` contains a customized copy of the [Inter 4.1 release](https://github.com/rsms/inter/releases/tag/v4.1), under the included SIL Open Font License.

The archive includes all 36 static Inter/Inter Display faces in `Inter.ttc`, plus the upright and italic variable fonts. The family names are unchanged, so the main theme family is `Inter`. SF Pro Text remains installed separately.

Prepared once with FontTools 4.63.0:

- Remove the zero, tabular-zero, circled-zero, and squared-zero substitutions from `ss02`. This preserves an unslashed zero even when applications explicitly enable `ss02`.
- Apply the `ss01` and modified `ss02` single substitutions to every Unicode `cmap` subtable, making those glyphs the defaults without per-application feature support.
- Preserve all other tables, including contextual `calt` lookups, weights, italics, optical sizes, and variable axes. `calt` is enabled by default by OpenType shaping engines; Fontconfig and Zed also explicitly enable it and disable `zero`.

The customized defaults were compared with the source fonts using HarfBuzz, with `ss02=1,calt=1,ss01=1,zero=0` and the same zero exception. Verification covered all static faces, both variable fonts at several weights and optical sizes, accented characters, contextual alternates, numbers, and punctuation.

Nix only installs the prebuilt archive; it does not rebuild or patch the fonts.
