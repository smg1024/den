# Host and home activation stay independent; input updates never activate either.
set default-list

mode-file := home_directory() / ".config/den/mode"

# Build or switch a host (defaults to the current hostname): just host build
[arg("action", pattern="^(build|switch)$")]
[arg("hostname", pattern="^.*$")]
host action hostname="":
    nh darwin {{ quote(action) }} . \
        --hostname={{ quote(if hostname == "" { trim(shell("hostname -s")) } else { hostname }) }} \
        --no-update-lock-file

# Build or switch a home mode (defaults to ~/.config/den/mode): just home switch
[arg("action", pattern="^(build|switch)$")]
[arg("home-name", pattern="^.*$")]
home action home-name="":
    nh home {{ quote(action) }} . \
        --configuration={{ quote(if home-name == "" { trim(read(mode-file)) } else { home-name }) }} \
        --no-update-lock-file

# Format the Justfile and all Nix files with the locked formatter.
fmt:
    just --fmt
    nix --extra-experimental-features 'nix-command flakes' fmt --no-update-lock-file .

# Check formatting without changing files.
fmt-check:
    just --fmt --check
    nix --extra-experimental-features 'nix-command flakes' fmt --no-update-lock-file -- --check .

# Check formatting and evaluate all host/home derivations, without activating them.
check: fmt-check
    nix --extra-experimental-features 'nix-command flakes' eval --no-update-lock-file --json \
        .#darwinConfigurations --apply 'hosts: builtins.mapAttrs (_: host: host.system.drvPath) hosts'
    nix --extra-experimental-features 'nix-command flakes' eval --no-update-lock-file --json \
        .#homeConfigurations --apply 'homes: builtins.mapAttrs (_: home: home.activationPackage.drvPath) homes'

# Update all inputs, or selected inputs: just update nixpkgs nvf
[arg("inputs", pattern="^[A-Za-z0-9][A-Za-z0-9._/-]*$")]
[positional-arguments]
update *inputs:
    nix --extra-experimental-features 'nix-command flakes' flake update "$@"
