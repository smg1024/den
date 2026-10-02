{inputs, ...}: {
  den.aspects.editor.homeManager = {
    imports = [
      (import ./_editor/nvf.nix {inherit inputs;})
      (import ./_editor/zed.nix {inherit inputs;})
    ];
  };
}
