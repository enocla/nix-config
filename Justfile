host := `hostname -s`
nix := if os() == "macos" { "/nix/var/nix/profiles/default/bin/nix" } else { "/run/current-system/sw/bin/nix" }
configuration := if os() == "macos" { "darwinConfigurations." + host + ".system" } else { "nixosConfigurations." + host + ".config.system.build.toplevel" }
activation := if os() == "macos" { "./result/activate" } else { "./result/bin/switch-to-configuration switch" }
elevation := if os() == "macos" { "sudo" } else { "run0" }

deploy: build
    {{ elevation }} {{ activation }}

build:
    {{ nix }} build ".#{{ configuration }}"

update:
    {{ nix }} flake update
    {{ nix }} build ".#{{ configuration }}"

clean:
    {{ nix }} store gc

fmt:
    {{ nix }} fmt .
    stylua . --sort-requires --indent-type spaces --indent-width 4
