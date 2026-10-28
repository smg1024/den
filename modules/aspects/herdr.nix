{inputs, ...}: {
  den.aspects.herdr.homeManager = {
    config,
    pkgs,
    ...
  }: {
    programs.herdr = {
      enable = true;
      package = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;

      settings = {
        # Home Manager owns this file; skip onboarding that writes to it.
        onboarding = false;

        terminal = {
          default_shell = "${config.programs.zsh.package}/bin/zsh";
        };

        # Follow Ghostty's palette and deliver background agent notifications.
        theme.name = "terminal";
        ui = {
          agent_panel_sort = "priority";
          hide_tab_bar_when_single_tab = true;
          toast.delivery = "terminal";
          sound.enabled = false;
        };

        experimental = {
          reveal_hidden_cursor_for_cjk_ime = true;
          cjk_ime_agents = ["claude" "codex" "hermes"];
          switch_ascii_input_source_in_prefix = true;
        };

        remote.manage_ssh_config = false;

        # Package updates are managed through the Herdr flake input.
        update.version_check = false;
      };
    };
  };
}
