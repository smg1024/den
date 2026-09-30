{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    flags = [
      "--disable-up-arrow"
    ];

    settings = {
      auto_sync = false;
      enter_accept = false;
      filter_mode = "global";
      keymap_mode = "auto";
      search_mode = "fuzzy";
      secrets_filter = true;
      update_check = false;
      workspaces = true;
    };
  };
}
