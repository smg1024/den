{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.fenrir.users.poby.classes = ["user"];

  den.aspects.fenrir = {
    includes = [den.aspects.darwin-base];

    darwin.homebrew = {
      masApps = {
        Xcode = 497799835;
      };

      brews = [
        "podman"
        "podman-compose"
      ];

      casks = [
        "android-studio"
      ];
    };
  };
}
