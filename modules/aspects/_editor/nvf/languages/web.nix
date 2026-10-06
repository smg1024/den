{inputs}: {
  lib,
  pkgs,
  ...
}: let
  prettier = "${pkgs.prettier}/bin/prettier";
  prettierCommand = ''
    require("conform.util").find_executable({ "node_modules/.bin/prettier" }, "${prettier}")
  '';
  nvfPackages = inputs.nvf.packages.${pkgs.stdenv.hostPlatform.system};
  fallbackPlugins = {
    # NVF's standalone Svelte plugin omits its compiler dependency in this pin.
    # The language server bundles a complete plugin with its peer dependencies.
    svelte = "${pkgs.svelte-language-server}/lib/node_modules/svelte-language-server/packages/language-server/node_modules/prettier-plugin-svelte/plugin.js";
    astro = "${nvfPackages.prettier-plugin-astro}/index.js";
  };
in {
  imports = [
    ./typescript.nix
    ./svelte.nix
    ./astro.nix
    ./tailwind.nix
  ];

  programs.nvf.settings.vim = {
    lsp.servers =
      lib.genAttrs ["typescript-language-server" "svelte-language-server" "astro-language-server"] (_: {
        # Conform/Prettier is the sole formatter for these languages.
        on_init = lib.generators.mkLuaInline ''
          function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
      })
      // {
        # NVF has no ESLint LSP preset in this pin; configure the native client.
        eslint = {
          enable = true;
          cmd = ["${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server" "--stdio"];
          filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact" "svelte" "astro"];
          workspace_required = true;

          # Do not start ESLint in projects that haven't opted into it.
          root_dir = lib.generators.mkLuaInline ''
            function(bufnr, on_dir)
              local markers = {
                "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
                "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
                ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
                ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
              }
              util.insert_package_json(markers, "eslintConfig", vim.api.nvim_buf_get_name(bufnr))
              local root = vim.fs.root(bufnr, markers)
              if root then
                on_dir(root)
              end
            end
          '';

          settings = {
            validate = "on";
            run = "onType";
            format = false;
            quiet = false;
            onIgnoredFiles = "off";
            nodePath = "";
            workingDirectory.mode = "auto";
            rulesCustomizations = [];
            experimental = {};
            problems.shortenToSingleLine = false;
            codeActionOnSave = {
              enable = false;
              mode = "all";
            };
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation.enable = true;
            };
          };

          before_init = lib.generators.mkLuaInline ''
            function(_, server_config)
              local root = server_config.root_dir
              server_config.settings.workspaceFolder = {
                uri = vim.uri_from_fname(root),
                name = vim.fs.basename(root),
              }
            end
          '';

          handlers = {
            "eslint/openDoc" = lib.generators.mkLuaInline ''
              function(_, result)
                if result then
                  vim.ui.open(result.url)
                end
                return vim.NIL
              end
            '';
            "eslint/noLibrary" = lib.generators.mkLuaInline ''
              function()
                vim.notify("ESLint: install eslint and the required plugins in this project", vim.log.levels.WARN)
                return vim.NIL
              end
            '';
          };
        };
      };

    formatter.conform-nvim = {
      # Infer parsers from the filename so Conform retains --stdin-filepath.
      presets.prettier.filetypeParser = lib.mkForce {};
      setupOpts.formatters.prettier = {
        command = lib.mkForce (lib.generators.mkLuaInline prettierCommand);
        prepend_args = lib.mkForce (lib.generators.mkLuaInline ''
          function(self, ctx)
            if (${prettierCommand})(self, ctx) ~= "${prettier}" then
              -- A project-local Prettier owns its plugin versions/configuration.
              return {}
            end
            local plugins = ${lib.generators.toLua {} fallbackPlugins}
            local plugin = plugins[vim.bo[ctx.buf].filetype]
            return plugin and { "--plugin", plugin } or {}
          end
        '');
      };
    };
  };
}
