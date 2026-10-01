{
  den.aspects.git.homeManager = {config, ...}: {
    programs.git = {
      enable = true;

      signing = {
        format = "ssh";
        key = config.sops.secrets.git_ssh.path;
        signByDefault = true;
      };

      settings = {
        # Each mode supplies its identity; never guess it from the system account.
        user.useConfigOnly = true;

        push.autoSetupRemote = true;
      };
    };

    programs.zsh.shellAliases = {
      g = "git";
      gaa = "git add --all";
      gc = "git commit --verbose";
      gca = "git commit --amend";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      glg = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
      gp = "git push";
      gst = "git status";
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # Read once per interactive shell; start a fresh shell after changing modes.
    programs.zsh.initContent = ''
      if [[ -r "${config.sops.secrets.gh_token.path}" ]]; then
        export GH_TOKEN="$(< "${config.sops.secrets.gh_token.path}")"
      fi
    '';
  };
}
