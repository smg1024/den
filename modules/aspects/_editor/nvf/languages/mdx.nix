{
  lib,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    # NVF's Markdown module otherwise treats MDX as ordinary Markdown.
    filetype.extension.mdx = lib.mkForce "mdx";

    # Reuse the Markdown parser for prose highlighting, not for MDX diagnostics.
    treesitter.filetypeMappings.markdown = ["mdx"];

    lsp.servers.mdx-analyzer = {
      enable = true;
      cmd = ["${pkgs.mdx-language-server}/bin/mdx-language-server" "--stdio"];
      filetypes = ["mdx"];
      root_markers = ["tsconfig.json" "jsconfig.json" "package.json" ".git"];
      init_options.typescript.enabled = true;

      before_init = lib.generators.mkLuaInline ''
        function(_, server_config)
          local tsdk = util.get_typescript_server_path(server_config.root_dir)
          server_config.init_options.typescript.tsdk = tsdk ~= "" and tsdk
            or "${pkgs.typescript_5}/lib/node_modules/typescript/lib"
        end
      '';

      # Keep formatting with the shared project-aware Prettier configuration.
      on_init = lib.generators.mkLuaInline ''
        function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      '';
    };

    # Markdownlint/Oxide stay on .md; JSX and imports belong to MDX Analyzer.
    formatter.conform-nvim.setupOpts.formatters_by_ft.mdx = ["prettier"];
  };
}
