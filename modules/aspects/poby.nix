{den, ...}: {
  den.aspects.poby = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.shell
      den.aspects.editor
      den.aspects.terminal
      den.aspects.window-management
      den.aspects.hammerspoon
      den.aspects.cli-tools
      den.aspects.git
      den.aspects.ssh
      den.aspects.secrets
    ];

    homeManager = {
      # Preserve the compatibility baseline of the existing poby home.
      home.stateVersion = "25.11";

      programs.home-manager.enable = true;
    };
  };
}
