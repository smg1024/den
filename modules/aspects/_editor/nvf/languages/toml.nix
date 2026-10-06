{lib, ...}: {
  programs.nvf.settings.vim = {
    languages.toml = {
      enable = true;
      lsp.servers = ["taplo"];
      format = {
        enable = true;
        type = ["taplo"];
      };
      # Taplo already supplies diagnostics; no additional Tombi process.
      extraDiagnostics.enable = false;
    };

    lsp.servers.taplo = {
      root_markers = lib.mkForce [".taplo.toml" "taplo.toml" ".git"];
      on_init = lib.generators.mkLuaInline ''
        function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      '';
    };

    formatter.conform-nvim.setupOpts.formatters.taplo = {
      # Honor project formatting instead of NVF's forced alignment/indentation.
      args = lib.mkForce ["format" "--stdin-filepath" "$FILENAME" "-"];
      cwd = lib.generators.mkLuaInline ''
        require("conform.util").root_file({ ".taplo.toml", "taplo.toml", ".git" })
      '';
    };
  };
}
