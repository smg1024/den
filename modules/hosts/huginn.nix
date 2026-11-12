{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.huginn.users.poby.classes = ["user"];

  den.aspects.huginn = {
    includes = [den.aspects.darwin-base];

    # Accept either home mode's key for incoming SSH.
    darwin.users.users.poby.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuQ4STNnixjNDo38AyI0yABKAVfF3hupo66613IgfC7 smg981024@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMn8vnzQYKYcFxg/fhIVaIrYZri6lG/ytn8nZakMtmt1 smg981024@kmeat.com"
    ];

    darwin.homebrew = {
      brews = [];

      casks = [
        "datagrip"
        "notion"
        "slack"
        "telegram"
      ];
    };
  };
}
