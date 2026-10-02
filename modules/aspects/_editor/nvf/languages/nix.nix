{
  den,
  home,
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  # Follow the same working checkout as nh, rather than a frozen store copy.
  denFlake = "builtins.getFlake ${builtins.toJSON config.programs.nh.flake}";

  # Derive the hostname lookup from Den; adding a host needs no editor changes.
  darwinOptions = lib.mapAttrs' (name: host:
    lib.nameValuePair (lib.toLower host.hostName) {
      expr = "(${denFlake}).darwinConfigurations.${builtins.toJSON name}.options";
    }) (lib.filterAttrs (_: host: host.class == "darwin")
    (den.hosts.${pkgs.stdenv.hostPlatform.system} or {}));
in {
  programs.nvf.settings.vim = {
    languages.nix = {
      enable = true;
      lsp.servers = ["nixd"];
      format = {
        enable = true;
        type = ["alejandra"];
      };
      extraDiagnostics = {
        enable = true;
        types = ["deadnix" "statix"];
      };
    };

    lsp.servers.nixd.settings.nixd = {
      nixpkgs.expr = "import (${denFlake}).inputs.nixpkgs { system = \"${pkgs.stdenv.hostPlatform.system}\"; }";
      formatting.command = ["${pkgs.alejandra}/bin/alejandra"];

      options =
        {
          # The selected Home Manager generation determines the mode.
          home-manager.expr = "(${denFlake}).homeConfigurations.${builtins.toJSON home.name}.options";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          # Standalone homes have no host binding: select it at Neovim startup.
          darwin = lib.generators.mkLuaInline ''
            (function()
              local hosts = ${lib.generators.toLua {} darwinOptions}
              local hostname = (vim.uv.os_gethostname() or ""):lower()
              local options = hosts[hostname] or hosts[hostname:match("^[^.]+") or ""]

              if not options then
                vim.schedule(function()
                  vim.notify(
                    "nixd: no Den Darwin configuration for hostname '" .. hostname
                      .. "'; skipping Darwin option completion",
                    vim.log.levels.WARN
                  )
                end)
              end

              return options
            end)()
          '';
        };
    };
  };
}
