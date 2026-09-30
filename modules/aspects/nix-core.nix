let
  # Share cache declarations between flake commands and the system Nix daemon.
  flakeNixConfig = (import ../../flake.nix).nixConfig;
in {
  den.aspects.nix-core.darwin = {pkgs, ...}: {
    nix = {
      enable = true;
      package = pkgs.nixVersions.latest;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = flakeNixConfig.extra-substituters;
        trusted-public-keys = flakeNixConfig.extra-trusted-public-keys;
        auto-optimise-store = false;
      };

      optimise.automatic = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };
  };
}
