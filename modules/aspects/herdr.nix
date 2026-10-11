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
          shell_mode = "auto";
          new_cwd = "follow";
        };

        # Follow Ghostty's palette and deliver background agent notifications.
        theme.name = "terminal";
        ui = {
          sidebar_width = 32;
          agent_panel_sort = "priority";
          toast.delivery = "terminal";
          sound.enabled = false;
        };

        # Native conversation restore needs each agent's Herdr integration.
        session.resume_agents_on_restore = true;

        # Package updates are managed through the Herdr flake input.
        update.version_check = false;
      };
    };
  };
}
