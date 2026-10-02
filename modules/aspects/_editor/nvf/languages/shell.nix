{pkgs, ...}: {
  programs.nvf.settings.vim = {
    languages.bash = {
      enable = true;
      lsp.servers = ["bash-language-server"];
      format = {
        enable = true;
        type = ["shfmt"];
      };
      # Bash Language Server already provides ShellCheck diagnostics.
      extraDiagnostics.enable = false;
    };

    lsp.servers.bash-language-server.settings.bashIde = {
      shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
      shfmt.path = "${pkgs.shfmt}/bin/shfmt";
    };

    # Pinned NVF maps its Zsh formatter to sh; wire zsh explicitly instead.
    # shfmt detects .zshrc, other Zsh startup files, .zsh, and Zsh shebangs.
    # Do not attach Bash Language Server or ShellCheck to Zsh buffers.
    formatter.conform-nvim.setupOpts.formatters_by_ft.zsh = ["shfmt"];
  };
}
