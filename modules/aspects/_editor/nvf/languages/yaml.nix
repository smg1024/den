{lib, ...}: {
  imports = [./schemas.nix];

  programs.nvf.settings.vim = {
    languages.yaml = {
      enable = true;
      lsp.servers = ["yaml-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
    };

    lsp.servers.yaml-language-server.settings.yaml = {
      format.enable = false;

      # Use the pinned catalog instead of downloading the complete live catalog.
      schemaStore = {
        enable = false;
        url = "";
      };
      schemas = lib.generators.mkLuaInline ''
        require("schemastore").yaml.schemas({
          select = { "GitHub Workflow", "GitHub Action", "docker-compose.yml" },
        })
      '';
      kubernetesCRDStore.enable = false;

      # SOPS payloads have custom keys and encrypted values, not an app schema.
      # Keep YAML syntax diagnostics; an explicit schema modeline still wins.
      disableSchemaDetection = ["**/secrets/*.yaml" "**/secrets/*.yml"];
    };
  };
}
