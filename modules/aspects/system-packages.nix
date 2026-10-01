{
  den.aspects.system-packages.darwin = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      fetch
      git
      just
      tree
    ];

    fonts.packages = with pkgs; [
      material-design-icons
      font-awesome
      pretendard
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      nerd-fonts.d2coding
      nerd-fonts.iosevka
      nerd-fonts.meslo-lg
    ];
  };
}
