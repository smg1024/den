{
  config,
  lib,
  pkgs,
  ...
}: let
  # Pin the editor's JDK independently of the shared CLI toolchain.
  jdk = pkgs.jdk25;
  jdtls = pkgs.jdt-language-server.override {inherit jdk;};
  googleJavaFormat = pkgs.google-java-format.override {jre = jdk;};
in {
  programs.nvf.settings.vim = {
    languages.java = {
      enable = true;
      lsp.servers = ["jdt-language-server"];
      treesitter.enable = true;

      # The pinned language module lacks google-java-format; use Conform directly.
      format.enable = false;
      dap.enable = false;
      extensions = {
        gradle-nvim.enable = false;
        maven-nvim.enable = false;
      };
    };

    lsp.servers.jdt-language-server = {
      # NVF's preset shares one workspace across projects. Hash the full root,
      # not its basename, so unrelated checkouts with the same name stay apart.
      cmd = lib.mkForce (lib.generators.mkLuaInline ''
        function(dispatchers, server_config)
          local root = server_config.root_dir or vim.fn.getcwd()
          root = vim.uv.fs_realpath(root) or root
          local cache = vim.fs.joinpath(
            vim.fn.stdpath("cache"), "jdtls", "${jdtls.version}", vim.fn.sha256(root)
          )
          vim.fn.mkdir(cache, "p")

          return vim.lsp.rpc.start({
            "${lib.getExe jdtls}",
            "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar",
            "-configuration", vim.fs.joinpath(cache, "config"),
            "-data", vim.fs.joinpath(cache, "workspace"),
          }, dispatchers, {
            cwd = root,
            env = server_config.cmd_env,
          })
        end
      '');

      # The project-specific -data argument above owns the workspace location.
      init_options.workspace = lib.mkForce (lib.generators.mkLuaInline "nil");

      # Apply the JDK and Gradle choices before JDTLS first imports the project.
      before_init = lib.generators.mkLuaInline ''
        function(params, server_config)
          params.initializationOptions.settings = server_config.settings
        end
      '';

      settings.java = {
        format.enabled = false;

        configuration.runtimes = [
          {
            name = "JavaSE-25";
            path = jdk.home;
            default = true;
          }
        ];

        import.gradle = {
          java.home = jdk.home;
          # Prefer a project's wrapper; use Nix's Gradle 9 when it has none.
          wrapper.enabled = true;
          home = "${config.programs.gradle.package}/libexec/gradle";
        };
      };
    };

    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft.java = ["google-java-format"];
        formatters.google-java-format.command = lib.getExe googleJavaFormat;
      };
    };
  };
}
