{
  den.aspects.ssh.homeManager = {config, ...}: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # Both modes expose their selected key at the same runtime path.
      settings."github.com" = {
        User = "git";
        IdentityFile = config.sops.secrets.git_ssh.path;
        IdentitiesOnly = true;
        ForwardAgent = false;

        # Do not reuse a connection authenticated under the previous mode.
        ControlMaster = "no";
        ControlPath = "none";
      };
    };
  };
}
