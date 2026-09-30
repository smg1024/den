{
  den.aspects.personal.homeManager = {
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

    sops.defaultSopsFile = ../../secrets/personal.yaml;
  };
}
