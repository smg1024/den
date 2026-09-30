{inputs, ...}: {
  imports = [inputs.den.flakeModule];

  # Den also supplies these systems to flake-parts.
  den.systems = ["aarch64-darwin"];
}
