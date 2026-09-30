{config, ...}: {
  programs.uv.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
