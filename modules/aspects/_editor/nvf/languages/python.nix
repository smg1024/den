{
  lib,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    languages.python = {
      enable = true;
      lsp.servers = ["pyright" "ruff"];
      format = {
        enable = true;
        type = ["ruff"];
      };
      # Pyright checks types and Ruff supplies lint diagnostics; no Mypy pass.
      extraDiagnostics.enable = false;
    };

    lsp.servers = {
      pyright = {
        # Ruff owns import organization; keep Pyright's type analysis enabled.
        settings.pyright.disableOrganizeImports = true;

        # Prefer the Python project over an enclosing Git repository.
        root_markers = lib.mkForce [
          "pyrightconfig.json"
          "pyproject.toml"
          "uv.lock"
          ".venv"
          "Pipfile"
          "requirements.txt"
          "setup.cfg"
          "setup.py"
          ".git"
        ];

        # Use uv's project-local interpreter without activating a shell first.
        before_init = lib.generators.mkLuaInline ''
          function(_, server_config)
            local root = server_config.root_dir
            if not root then
              return
            end

            local python = vim.fs.joinpath(root, ".venv", "bin", "python")
            if vim.fn.executable(python) == 1 then
              server_config.settings.python.pythonPath = python
            end
          end
        '';
      };

      ruff.on_attach = lib.generators.mkLuaInline ''
        function(client)
          -- Keep hover documentation with Pyright, and Ruff's lint actions.
          client.server_capabilities.hoverProvider = false
        end
      '';
    };

    # Replace NVF's buffer-indent overrides with Conform's upstream formatter.
    # Both full-file and range formatting then honor the project's Ruff config.
    formatter.conform-nvim.setupOpts.formatters.ruff = lib.mkForce {
      "inherit" = "ruff_format";
      command = "${pkgs.ruff}/bin/ruff";
    };
  };
}
