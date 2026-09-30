{inputs, ...}: {
  den.aspects.secrets.homeManager = {
    config,
    pkgs,
    ...
  }: let
    # Runtime identity file: never import its contents into the Nix store.
    ageKeyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  in {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    home.packages = [pkgs.sops pkgs.age];
    home.sessionVariables.SOPS_AGE_KEY_FILE = ageKeyFile;

    sops = {
      age = {
        keyFile = ageKeyFile;
        generateKey = false;
      };

      # Each mode selects the encrypted file through sops.defaultSopsFile.
      secrets.git_ssh = {};
    };
  };
}
