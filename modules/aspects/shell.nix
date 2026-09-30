{den, ...}: {
  den.aspects.shell = {
    includes = [(den.batteries.user-shell "zsh")];

    homeManager = {
      programs.zsh.enableCompletion = true;

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
