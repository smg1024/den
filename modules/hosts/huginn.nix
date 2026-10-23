{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.huginn.users.poby.classes = ["user"];

  den.aspects.huginn = {
    includes = [den.aspects.darwin-base];

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
