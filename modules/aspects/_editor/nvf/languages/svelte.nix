{
  programs.nvf.settings.vim.languages.svelte = {
    enable = true;
    lsp.servers = ["svelte-language-server"];
    format = {
      enable = true;
      type = ["prettier"];
    };
    # The shared ESLint server uses the project's Svelte lint configuration.
    extraDiagnostics.enable = false;
  };
}
