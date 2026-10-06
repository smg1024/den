{lib, ...}: {
  programs.nvf.settings.vim = {
    languages.css = {
      enable = true;
      lsp.servers = ["vscode-css-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
    };

    lsp.servers.vscode-css-language-server = {
      # NVF's CSS/SCSS modules also attach to LESS/Sass by default.
      filetypes = lib.mkForce ["css" "scss"];
      init_options.provideFormatter = lib.mkForce false;
    };
  };
}
