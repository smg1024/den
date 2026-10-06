{
  den.aspects.work.homeManager = {
    config,
    lib,
    ...
  }: let
    # Add work connections here with their own destination, account and port.
    sshConnections = {
      "kmeat-ai-workstation" = {
        Hostname = "ai.kmeat.com";
        User = "kmeatai";
        Port = 10322;
      };
    };
  in {
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

    programs.ssh.settings = lib.genAttrs (builtins.attrNames sshConnections) (name:
      {
        IdentityFile = config.sops.secrets.git_ssh.path;
        IdentitiesOnly = true;
        ForwardAgent = false;

        # Open fresh connections rather than reusing a previous mode's session.
        ControlMaster = "no";
        ControlPath = "none";
      }
      // sshConnections.${name});

    sops.defaultSopsFile = ../../secrets/work.yaml;
  };
}
