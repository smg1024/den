{pkgs, ...}: {
  # Pin the schema catalog with nixpkgs; language servers fetch schemas on demand.
  programs.nvf.settings.vim.startPlugins = [pkgs.vimPlugins.SchemaStore-nvim];
}
