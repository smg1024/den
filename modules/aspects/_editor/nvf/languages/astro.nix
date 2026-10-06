{
  lib,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    languages.astro = {
      enable = true;
      lsp.servers = ["astro-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
      extraDiagnostics.enable = false;
    };

    lsp.servers.astro-language-server = {
      # Use an explicit JS SDK instead of NVF's NODE_PATH wrapper, which points
      # at the native TypeScript package in this nixpkgs pin.
      cmd = lib.mkForce ["${pkgs.astro-language-server}/bin/astro-ls" "--stdio"];
      before_init = lib.mkForce (lib.generators.mkLuaInline ''
        function(_, server_config)
          local tsdk = util.get_typescript_server_path(server_config.root_dir)
          server_config.init_options.typescript.tsdk = tsdk ~= "" and tsdk
            or "${pkgs.typescript_5}/lib/node_modules/typescript/lib"
        end
      '');
    };
  };
}
