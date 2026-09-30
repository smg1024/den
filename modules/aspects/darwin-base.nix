{den, ...}: {
  den.aspects.darwin-base = {
    includes = [
      den.batteries.hostname
      den.aspects.nix-core
      den.aspects.macos-defaults
    ];

    darwin = {config, ...}: {
      # Preserve the compatibility baseline of these existing Macs.
      system.stateVersion = 6;

      networking = {
        computerName = config.networking.hostName;
        localHostName = config.networking.hostName;
      };
    };
  };
}
