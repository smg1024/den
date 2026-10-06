{
  config,
  pkgs,
  ...
}: {
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  # Prefer ./mvnw in projects that provide it; otherwise use pinned Maven 3.9.
  home.packages = [
    (pkgs.maven.override {jdk_headless = config.programs.java.package;})
  ];
}
