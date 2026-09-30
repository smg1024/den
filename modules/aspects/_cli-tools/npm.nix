{
  config,
  pkgs,
  ...
}: {
  programs.npm = {
    enable = true;
    package = pkgs.nodejs_24;
    settings.prefix = "${config.home.homeDirectory}/.npm";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm/bin"
  ];
}
