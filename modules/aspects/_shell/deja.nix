{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.deja];

  # Load after shell keymaps and prompt integration, before syntax highlighting.
  programs.zsh.initContent = lib.mkOrder 1100 ''
    export DEJA_CYCLE_KEY='^N'
    export DEJA_FUZZY=smart
    export DEJA_EMPTY=off
    export DEJA_HIGHLIGHT_STYLE='fg=8'

    # Keep Tab for completion; Deja's arrows accept suggestions, not Enter.
    # Both modes share Deja's per-user database and cached integration script.
    if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
      source "$HOME/.local/share/deja/init.zsh"
    else
      eval "$(${lib.getExe pkgs.deja} init zsh)"
    fi
  '';
}
