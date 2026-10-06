{den, ...}: {
  # OS-level user configuration only; personal/work homes stay standalone.
  den.hosts.aarch64-darwin.kmeat-mac-mini.users.poby.classes = ["user"];

  den.aspects.kmeat-mac-mini = {
    includes = [den.aspects.darwin-base];
  };
}
