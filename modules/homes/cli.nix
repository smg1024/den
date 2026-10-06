{inputs, ...}: {
  # Bootstrap the standalone homes' CLI from the locked Home Manager input.
  perSystem = {system, ...}: {
    packages.home-manager = inputs.home-manager.packages.${system}.home-manager;
  };
}
