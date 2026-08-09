{
  externalPackage,
  theme,
  ...
}: let
  c = theme.colors;
  ui = theme.ui;
in {
  programs.bat = {
    enable = true;
    package = externalPackage "bat" {};
    config = {
      theme = "custom";
    };
  };

  # Generate the custom theme dynamically from theme.nix
  xdg.configFile."bat/themes/custom.tmTheme".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>name</key>
        <string>custom</string>
        <key>semanticClass</key>
        <string>theme.dark.custom</string>
        <key>uuid</key>
        <string>627ce890-fabb-4d39-9819-7be71f4bdca7</string>
        <key>author</key>
        <string>Tnixc</string>
        <key>colorSpaceName</key>
        <string>sRGB</string>
        <key>settings</key>
        <array>
          <dict>
            <key>settings</key>
            <dict>
              <key>background</key>
              <string>${c.base}</string>
              <key>foreground</key>
              <string>${c.text}</string>
              <key>caret</key>
              <string>${c.rosewater}</string>
              <key>lineHighlight</key>
              <string>${c.surface0}</string>
              <key>misspelling</key>
              <string>${c.red}</string>
              <key>accent</key>
              <string>${c.mauve}</string>
              <key>selection</key>
              <string>${c.overlay2}40</string>
              <key>activeGuide</key>
              <string>${c.surface1}</string>
              <key>findHighlight</key>
              <string>${ui.findHighlight}</string>
              <key>gutterForeground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Basic text &amp; variable names (incl. leading punctuation)</string>
            <key>scope</key>
            <string>text, source, variable.other.readwrite, punctuation.definition.variable</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Parentheses, Brackets, Braces</string>
            <key>scope</key>
            <string>punctuation</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.overlay2}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Comments</string>
            <key>scope</key>
            <string>comment, punctuation.definition.comment</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.overlay0}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>string, punctuation.definition.string</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.green}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>constant.character.escape</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.pink}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Booleans, constants, numbers</string>
            <key>scope</key>
            <string>constant.numeric, variable.other.constant, entity.name.constant, constant.language.boolean, constant.language.false, constant.language.true, keyword.other.unit.user-defined, keyword.other.unit.suffix.floating-point</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.peach}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>keyword, keyword.operator.word, keyword.operator.new, variable.language.super, support.type.primitive, storage.type, storage.modifier, punctuation.definition.keyword</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.mauve}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>entity.name.tag.documentation</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.mauve}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Punctuation</string>
            <key>scope</key>
            <string>keyword.operator, punctuation.accessor, punctuation.definition.generic, meta.function.closure punctuation.section.parameters, punctuation.definition.tag, punctuation.separator.key-value</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>entity.name.function, meta.function-call.method, support.function, support.function.misc, variable.function</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Classes</string>
            <key>scope</key>
            <string>entity.name.class, entity.other.inherited-class, support.class, meta.function-call.constructor, entity.name.struct</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Enum</string>
            <key>scope</key>
            <string>entity.name.enum</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Enum member</string>
            <key>scope</key>
            <string>meta.enum variable.other.readwrite, variable.other.enummember</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Object properties</string>
            <key>scope</key>
            <string>meta.property.object</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Types</string>
            <key>scope</key>
            <string>meta.type, meta.type-alias, support.type, entity.name.type</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Decorators</string>
            <key>scope</key>
            <string>meta.annotation variable.function, meta.annotation variable.annotation.function, meta.annotation punctuation.definition.annotation, meta.decorator, punctuation.decorator</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.peach}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>variable.parameter, meta.function.parameters</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.maroon}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Built-ins</string>
            <key>scope</key>
            <string>constant.language, support.function.builtin</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>entity.other.attribute-name.documentation</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Preprocessor directives</string>
            <key>scope</key>
            <string>keyword.control.directive, punctuation.definition.directive</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Type parameters</string>
            <key>scope</key>
            <string>punctuation.definition.typeparameters</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.sky}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Namespaces</string>
            <key>scope</key>
            <string>entity.name.namespace</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Property names (left hand assignments in json/yaml/css)</string>
            <key>scope</key>
            <string>support.type.property-name.css</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>This/Self keyword</string>
            <key>scope</key>
            <string>variable.language.this, variable.language.this punctuation.definition.variable</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Object properties</string>
            <key>scope</key>
            <string>variable.object.property</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>String template interpolation</string>
            <key>scope</key>
            <string>string.template variable, string variable</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.heading.1.markdown</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.heading.2.markdown</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.peach}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.heading.markdown</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.bold</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
              <key>fontStyle</key>
              <string>bold</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.italic</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
              <key>fontStyle</key>
              <string>italic</string>
            </dict>
          </dict>
          <dict>
            <key>scope</key>
            <string>markup.strikethrough</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.subtext0}</string>
              <key>fontStyle</key>
              <string>strikethrough</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown auto links</string>
            <key>scope</key>
            <string>punctuation.definition.link, markup.underline.link</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown links</string>
            <key>scope</key>
            <string>text.html.markdown punctuation.definition.link.title, string.other.link.title.markdown, markup.link, punctuation.definition.constant.markdown, constant.other.reference.link.markdown, markup.substitution.attribute-reference</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.lavender}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown code spans</string>
            <key>scope</key>
            <string>punctuation.definition.raw.markdown, markup.inline.raw.string.markdown, markup.raw.block.markdown</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.green}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown triple backtick language identifier</string>
            <key>scope</key>
            <string>fenced_code.block.language</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.sky}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown triple backticks</string>
            <key>scope</key>
            <string>markup.fenced_code.block punctuation.definition, markup.raw support.asciidoc</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.overlay2}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown quotes</string>
            <key>scope</key>
            <string>markup.quote, punctuation.definition.quote.begin</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.pink}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown separators</string>
            <key>scope</key>
            <string>meta.separator.markdown</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markdown list bullets</string>
            <key>scope</key>
            <string>punctuation.definition.list.begin.markdown, markup.list.bullet</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.teal}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Nix attribute names</string>
            <key>scope</key>
            <string>entity.other.attribute-name.multipart.nix, entity.other.attribute-name.single.nix</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Nix parameter names</string>
            <key>scope</key>
            <string>variable.parameter.name.nix</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Nix interpolated parameter names</string>
            <key>scope</key>
            <string>meta.embedded variable.parameter.name.nix</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.lavender}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Nix paths</string>
            <key>scope</key>
            <string>string.unquoted.path.nix</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.pink}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>JSON/YAML keys, other left-hand assignments</string>
            <key>scope</key>
            <string>keyword.other.definition.ini, punctuation.support.type.property-name.json, support.type.property-name.json, punctuation.support.type.property-name.toml, support.type.property-name.toml, entity.name.tag.yaml, punctuation.support.type.property-name.yaml, support.type.property-name.yaml</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
              <key>fontStyle</key>
              <string/>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Markup Diff</string>
            <key>scope</key>
            <string>markup.changed.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.peach}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff</string>
            <key>scope</key>
            <string>meta.diff.header.from-file, meta.diff.header.to-file, punctuation.definition.from-file.diff, punctuation.definition.to-file.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff Inserted</string>
            <key>scope</key>
            <string>markup.inserted.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.green}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff Deleted</string>
            <key>scope</key>
            <string>markup.deleted.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
        </array>
      </dict>
    </plist>
  '';
}
