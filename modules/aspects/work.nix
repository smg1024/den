{
  den.aspects.work.homeManager = {
    # A visible, non-secret marker of the active mode.
    xdg.configFile."den/mode".text = "work\n";

    programs.git = {
      settings.user = {
        name = "Sangmin Kim @kmeat";
        email = "smg981024@kmeat.com";
      };

      # Trust only this mode's public key when verifying signatures locally.
      signing.allowedSigners = ''
        smg981024@kmeat.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMn8vnzQYKYcFxg/fhIVaIrYZri6lG/ytn8nZakMtmt1
      '';
    };

    sops.defaultSopsFile = ../../secrets/work.yaml;
  };
}
