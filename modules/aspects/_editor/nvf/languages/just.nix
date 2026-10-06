{lib, ...}: {
  programs.nvf.settings.vim = {
    languages.just = {
      enable = true;
      lsp.servers = ["just-lsp"];
      treesitter.enable = true;
      format = {
        enable = true;
        type = ["just"];
      };
    };

    lsp.servers.just-lsp = {
      root_markers = lib.mkForce ["Justfile" "justfile" ".justfile" ".git"];

      # Conform owns formatting; keep LSP completion, diagnostics and navigation.
      on_init = lib.generators.mkLuaInline ''
        function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      '';
    };
  };
}
