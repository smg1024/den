{
  den.aspects.hammerspoon = {
    darwin.homebrew.casks = ["hammerspoon"];

    homeManager = {lib, ...}: {
      # The same shortcuts apply on every Mac and in both home modes.
      home.file.".hammerspoon" = {
        source = ./_hammerspoon;
        recursive = true;
      };

      home.activation.reloadHammerspoon = lib.hm.dag.entryAfter ["linkGeneration"] ''
        hs=
        for candidate in /opt/homebrew/bin/hs /usr/local/bin/hs; do
          if [[ -x "$candidate" ]]; then
            hs="$candidate"
            break
          fi
        done

        if [[ -n "$hs" ]]; then
          run "$hs" -c "hs.reload()" || echo "warning: failed to reload Hammerspoon" >&2
        else
          verboseEcho "Skipping Hammerspoon reload because hs was not found"
        fi
      '';
    };
  };
}
