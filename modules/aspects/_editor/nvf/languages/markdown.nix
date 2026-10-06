{
  programs.nvf.settings = {lib, ...}: {
    vim = {
      languages.markdown = {
        enable = true;
        lsp.servers = ["markdown-oxide"];
        format = {
          enable = true;
          type = ["prettier"];
        };
        extraDiagnostics = {
          enable = true;
          types = ["markdownlint-cli2"];
        };

        # Install both markdown and markdown_inline for inline rendering.
        treesitter.enable = true;
        extensions.render-markdown-nvim = {
          enable = true;
          setupOpts = {
            file_types = ["markdown"];
            checkbox.checked.scope_highlight = "@markup.strikethrough";
          };
        };
      };

      # Let Oxide watch linked notes created/renamed while Neovim is running.
      lsp.servers.markdown-oxide.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true;

      # Lint only this buffer, even if the project's CLI config defines globs.
      diagnostics.nvim-lint.linters.markdownlint-cli2.args = ["--no-globs" "-"];
      pluginRC.markdownlint-project = lib.nvim.dag.entryAfter ["nvim-lint"] ''
        local lint = require("lint")
        local markdownlint = lint.linters["markdownlint-cli2"]
        lint.linters["markdownlint-cli2"] = function()
          local linter = vim.deepcopy(markdownlint)
          -- CLI2 resolves stdin's rules from its working directory, not the buffer.
          linter.cwd = vim.fs.root(0, {
            ".markdownlint-cli2.jsonc", ".markdownlint-cli2.yaml",
            ".markdownlint-cli2.cjs", ".markdownlint-cli2.mjs",
            ".markdownlint.jsonc", ".markdownlint.json",
            ".markdownlint.yaml", ".markdownlint.yml",
            ".markdownlint.cjs", ".markdownlint.mjs", ".git",
          }) or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
          return linter
        end
      '';
    };
  };
}
