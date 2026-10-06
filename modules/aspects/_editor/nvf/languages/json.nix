{lib, ...}: {
  imports = [./schemas.nix];

  programs.nvf.settings.vim = {
    languages.json = {
      enable = true;
      lsp.servers = ["vscode-json-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
    };

    lsp.servers.vscode-json-language-server = {
      # Prettier owns JSON/JSONC formatting; the server handles schemas.
      init_options.provideFormatter = lib.mkForce false;
      settings.json = {
        validate.enable = true;
        schemas = lib.generators.mkLuaInline ''
          require("schemastore").json.schemas()
        '';
      };
    };
  };
}
