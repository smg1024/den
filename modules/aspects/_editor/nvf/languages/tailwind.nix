{
  lib,
  pkgs,
  ...
}: let
  # Recognize Tailwind's directives without hiding misspelled at-rules.
  cssData = pkgs.writeText "tailwind.css-data.json" (builtins.toJSON {
    version = 1.1;
    atDirectives = map (name: {inherit name;}) [
      "@tailwind"
      "@apply"
      "@config"
      "@plugin"
      "@theme"
      "@source"
      "@utility"
      "@variant"
      "@custom-variant"
      "@reference"
      "@screen"
    ];
  });
in {
  programs.nvf.settings.vim.lsp = {
    # The preset starts only in detected Tailwind projects, including v4 setups.
    presets.tailwindcss-language-server.enable = true;
    servers.tailwindcss-language-server.filetypes = lib.mkForce [
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
      "svelte"
      "astro"
      "html"
      "css"
      "scss"
    ];

    # The extracted CSS server receives custom data through this notification,
    # not VS Code's client-side css.customData setting.
    servers.vscode-css-language-server.on_init = lib.generators.mkLuaInline ''
      function(client)
        -- One positional argument containing the list of custom-data URLs.
        client:notify("css/customDataChanged", { { vim.uri_from_fname("${cssData}") } })
      end
    '';
  };
}
