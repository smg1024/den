{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.huginn.users.poby.classes = ["user"];

  den.aspects.huginn = {
    includes = [den.aspects.darwin-base];

    darwin.homebrew = {
      brews = [
        "docker"
      ];

      casks = [
        "cursor"
        "datagrip"
        "docker-desktop"
        "notion"
        "obsidian"
        "slack"
      ];
    };
  };
}
