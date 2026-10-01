{inputs, ...}: {
  den.aspects.editor.homeManager = {
    imports = [
      inputs.nvf.homeManagerModules.default
      (import ./_editor/zed.nix {inherit inputs;})
    ];

    # Shared NVF preferences will go under programs.nvf.settings.vim.
    programs.nvf = {
      enable = true;
      defaultEditor = true;
    };

    # Some terminal tools prefer VISUAL over EDITOR, which NVF sets above.
    home.sessionVariables.VISUAL = "nvim";
  };
}
