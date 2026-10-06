{lib, ...}: {
  programs.nvf.settings.vim = {
    languages.html = {
      enable = true;
      lsp.servers = ["superhtml"];
      format = {
        enable = true;
        type = ["prettier"];
      };
      extraDiagnostics.enable = false;
    };

    # SuperHTML validates HTML5, not XHTML or framework component syntax.
    lsp.servers.superhtml.filetypes = lib.mkForce ["html"];

    # This NVF pin skips HTML's Conform setup when its LSP is enabled.
    formatter.conform-nvim = {
      enable = true;
      presets.prettier.enable = true;
      setupOpts.formatters_by_ft.html = ["prettier"];
    };
  };
}
