{
  # The home name selects a mode, not a separate macOS account.
  den.homes.aarch64-darwin.personal = import ./_poby.nix;

  den.aspects.personal.homeManager = {
    config,
    lib,
    ...
  }: {
    # A visible, non-secret marker of the active mode.
    xdg.configFile."den/mode".text = "personal\n";

    programs.git = {
      settings.user = {
        name = "Sangmin Kim";
        email = "smg981024@gmail.com";
      };

      # Trust only this mode's public key when verifying signatures locally.
      signing.allowedSigners = ''
        smg981024@gmail.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuQ4STNnixjNDo38AyI0yABKAVfF3hupo66613IgfC7
      '';
    };

    programs.ssh.settings = lib.genAttrs ["yggdrasil" "midgard" "alfheim"] (name: {
      Hostname = "${name}.tail6fc192.ts.net";
      User = "poby";
      Port = 22;

      IdentityFile = config.sops.secrets.git_ssh.path;
      IdentitiesOnly = true;
      PreferredAuthentications = "publickey";
      ForwardAgent = false;

      ServerAliveInterval = 30;
      ServerAliveCountMax = 3;

      # Open fresh connections rather than reusing a previous mode's session.
      ControlMaster = "no";
      ControlPath = "none";
    });

    sops.defaultSopsFile = ../../secrets/personal.yaml;
  };
}
