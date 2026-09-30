{pkgs, ...}: {
  programs.gradle = {
    enable = true;
    package = pkgs.gradle_9;

    settings = {
      "org.gradle.java.home" = "${pkgs.jdk25.home}";
      "org.gradle.caching" = true;
      "org.gradle.parallel" = true;
      "org.gradle.jvmargs" = "-Xmx2g -XX:MaxMetaspaceSize=512m -Dfile.encoding=UTF-8";
      "org.gradle.warning.mode" = "summary";
      "org.gradle.java.installations.paths" = "${pkgs.jdk25.home}";
    };
  };
}
