{lib, ...}: {
  programs.nvf.settings.vim.lsp = {
    # The preset starts only in detected Tailwind projects, including v4 setups.
    presets.tailwindcss-language-server.enable = true;
    servers.tailwindcss-language-server.filetypes = lib.mkForce [
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
      "svelte"
      "astro"
      "html"
      "css"
    ];
  };
}
