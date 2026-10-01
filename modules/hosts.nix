{den, ...}: {
  den.hosts.aarch64-darwin = {
    # OS-level user configuration only; personal/work homes stay standalone.
    fenrir.users.poby.classes = ["user"];
    huginn.users.poby.classes = ["user"];
  };

  den.aspects.fenrir.includes = [
    den.aspects.darwin-base
    den.aspects.fenrir-brew
  ];
  den.aspects.huginn.includes = [
    den.aspects.darwin-base
    den.aspects.huginn-brew
  ];
}
