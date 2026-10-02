{
  inputs,
  den,
  ...
}: {
  den.aspects.editor.homeManager = {
    imports = [
      (import ./_editor/nvf.nix {inherit inputs den;})
      (import ./_editor/zed.nix {inherit inputs;})
    ];
  };
}
