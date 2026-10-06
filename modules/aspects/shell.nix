{den, ...}: {
  den.aspects.shell = {
    includes = [(den.batteries.user-shell "zsh")];

    homeManager = {
      programs.zsh = {
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "viins";

        history = {
          size = 10000;
          save = 10000;

          # Both modes use the same default history file and share sessions.
          share = true;
          ignoreAllDups = true;
          ignoreDups = true;
          ignoreSpace = true;
        };
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
