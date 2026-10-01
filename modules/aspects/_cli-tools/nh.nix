{config, ...}: {
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/den";

    # Keep scheduled garbage collection in the system's nix-core aspect.
    clean.enable = false;
  };
}
