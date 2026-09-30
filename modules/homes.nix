{inputs, ...}: let
  # The home names below select modes, not macOS accounts.
  pobyHome = {
    userName = "poby";

    # Keep Den's user context aligned with the account, too.
    user = {
      name = "poby";
      userName = "poby";
      classes = ["homeManager"];
    };
  };
in {
  den.homes.aarch64-darwin = {
    personal = pobyHome;
    work = pobyHome;
  };

  # Bootstrap the CLI from this flake's locked Home Manager input.
  perSystem = {system, ...}: {
    packages.home-manager = inputs.home-manager.packages.${system}.home-manager;
  };
}
