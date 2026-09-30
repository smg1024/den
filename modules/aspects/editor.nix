{inputs, ...}: {
  den.aspects.editor.homeManager = {
    imports = [inputs.nvf.homeManagerModules.default];

    # Shared NVF preferences will go under programs.nvf.settings.vim.
    programs.nvf = {
      enable = true;
      defaultEditor = true;
    };

    # Some terminal tools prefer VISUAL over EDITOR, which NVF sets above.
    home.sessionVariables.VISUAL = "nvim";

    # Home Manager installs Zed from the pinned nixpkgs package set.
    programs.zed-editor.enable = true;
  };
}
