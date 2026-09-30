{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.nerd-fonts.d2coding];

  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;

    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      window-theme = "system";
      theme = "Catppuccin Macchiato";
      font-family = "D2KodingLigature Nerd Font";
      font-size = 18;
      background-opacity = 0.5;
      background-opacity-cells = true;
      background-blur = "macos-glass-clear"; # Native glass requires macOS 26+; implies true otherwise
      window-padding-x = 2;
      window-padding-y = 2;
      mouse-hide-while-typing = true;
      confirm-close-surface = true;

      notify-on-command-finish = "unfocused";
      notify-on-command-finish-after = "10s";
      notify-on-command-finish-action = "notify,no-bell";

      macos-titlebar-style = "tabs";
      macos-option-as-alt = true;
      window-save-state = "default";
      macos-titlebar-proxy-icon = "hidden";
      macos-window-buttons = "hidden";
      macos-dock-drop-behavior = "new-tab";
      macos-shortcuts = "deny";
      macos-icon = "xray";

      # Use the same Nix-managed shell as Home Manager, regardless of login shell.
      command = "${config.programs.zsh.package}/bin/zsh -l";

      # Nix owns this app's version; do not update the store-managed app in place.
      auto-update = "off";
    };
  };
}
