{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.kmeat-mac-mini.users.poby.classes = ["user"];

  den.aspects.kmeat-mac-mini = {
    includes = [den.aspects.darwin-base];

    darwin = {
      users.users.poby.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMn8vnzQYKYcFxg/fhIVaIrYZri6lG/ytn8nZakMtmt1 smg981024@kmeat.com"
      ];

      homebrew = {
        brews = [
          "mise"
        ];
      };
    };
  };
}
