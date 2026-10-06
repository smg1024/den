{
  programs.nvf.settings.vim = {
    languages.scss = {
      enable = true;
      lsp.servers = ["vscode-css-language-server"];
      # NVF groups SCSS and indented Sass; only wire the supported syntax below.
      format.enable = false;
      extraDiagnostics.enable = false;
    };

    formatter.conform-nvim.setupOpts.formatters_by_ft.scss = ["prettier"];
  };
}
