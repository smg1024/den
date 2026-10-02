{
  inputs,
  den,
  ...
}: {
  den.aspects.editor.homeManager = {
    imports = [
      (import ./_editor/nvf {inherit inputs den;})
      (import ./_editor/zed.nix {inherit inputs;})
    ];
  };
}
