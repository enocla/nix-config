default: deploy

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


# SOPS-managed files under secrets/ are plaintext after this command.
sops := "nix shell nixpkgs#sops nixpkgs#gnupg --command sops"

decrypt:
    @find secrets -type f -print | while IFS= read -r file; do {{ sops }} --decrypt --in-place "$file"; done

encrypt:
    @find secrets -type f -print | while IFS= read -r file; do {{ sops }} --encrypt --in-place "$file"; done
