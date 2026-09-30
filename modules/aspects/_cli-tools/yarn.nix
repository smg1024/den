{pkgs, ...}: {
  home.packages = with pkgs; [
    yarn
  ];

  programs.yarn.enable = true;
}
