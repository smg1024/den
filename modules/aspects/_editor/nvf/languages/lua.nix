{
  programs.nvf.settings.vim.languages.lua = {
    enable = true;
    lsp.servers = ["lua-language-server"];
    format = {
      enable = true;
      type = ["stylua"];
    };
    extraDiagnostics = {
      enable = true;
      types = ["luacheck"];
    };
  };
}
