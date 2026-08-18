host := `hostname -s`
nh := if os() == "macos" { "nh darwin" } else { "nh os" }
elevation := if os() == "macos" { "/usr/bin/sudo" } else { "/run/current-system/sw/bin/run0" }

build:
    {{ nh }} build -H {{ host }} .

deploy:
    {{ nh }} switch --elevation-strategy {{ elevation }} -H {{ host }} .

update:
    {{ nh }} build --update -H {{ host }} .

clean:
    nh clean all

fmt:
    nix fmt .
    stylua . --sort-requires --indent-type spaces --indent-width 4
