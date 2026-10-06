{
  lib,
  pkgs,
  ...
}: let
  nixTools = {
    cargo = "${pkgs.cargo}/bin/cargo";
    cargo-clippy = "${pkgs.clippy}/bin/cargo-clippy";
    clippy-driver = "${pkgs.clippy}/bin/clippy-driver";
    rustc = "${pkgs.rustc}/bin/rustc";
    rustdoc = "${pkgs.rustc}/bin/rustdoc";
    rustfmt = "${pkgs.rustfmt}/bin/rustfmt";
    rust-analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };
  nixToolPath = lib.makeBinPath [pkgs.cargo pkgs.rustc pkgs.clippy pkgs.rustfmt pkgs.rust-analyzer];

  # Private to NVF: ordinary shell commands keep the shared Nix-pinned toolchain.
  rustTools = pkgs.symlinkJoin {
    name = "nvf-project-rust-tools";
    paths = lib.mapAttrsToList (name: fallback:
      pkgs.writeShellApplication {
        inherit name;
        text = ''
          project_dir="$PWD"

          # NVF/Conform may ask Cargo about a manifest outside Neovim's cwd.
          manifest=""
          next_is_manifest=false
          for arg in "$@"; do
            if "$next_is_manifest"; then
              manifest="$arg"
              next_is_manifest=false
            elif [[ "$arg" == --manifest-path ]]; then
              next_is_manifest=true
            elif [[ "$arg" == --manifest-path=* ]]; then
              manifest="''${arg#--manifest-path=}"
            fi
          done
          if [[ -n "$manifest" ]]; then
            [[ "$manifest" == /* ]] || manifest="$PWD/$manifest"
            project_dir="''${manifest%/*}"
          fi

          # A missing declared toolchain must fail, never download or fall back.
          export RUSTUP_AUTO_INSTALL=0
          unset RUSTUP_TOOLCHAIN
          search_dir="$project_dir"
          while :; do
            if [[ -f "$search_dir/rust-toolchain.toml" || -f "$search_dir/rust-toolchain" ]]; then
              compiler="$(cd "$project_dir" && ${pkgs.rustup}/bin/rustup which rustc)"
              export RUSTUP_TOOLCHAIN="''${compiler%/bin/rustc}"
              export RUSTC="$compiler"
              export RUSTDOC="$RUSTUP_TOOLCHAIN/bin/rustdoc"
              export RUST_SRC_PATH="$RUSTUP_TOOLCHAIN/lib/rustlib/src/rust/library"
              export PATH="$RUSTUP_TOOLCHAIN/bin:$PATH"
              ${lib.optionalString (name == "rust-analyzer") ''
            if [[ ! -f "$RUST_SRC_PATH/core/src/lib.rs" ]]; then
              echo "NVF: install rust-src for this project's toolchain before starting rust-analyzer" >&2
              exit 1
            fi
          ''}
              exec ${pkgs.rustup}/bin/${name} "$@"
            fi
            [[ "$search_dir" != / ]] || break
            search_dir="''${search_dir%/*}"
            [[ -n "$search_dir" ]] || search_dir=/
          done

          export RUSTC=${nixTools.rustc}
          export RUSTDOC=${nixTools.rustdoc}
          export RUST_SRC_PATH=${pkgs.rustPlatform.rustLibSrc}
          export PATH="${nixToolPath}:$PATH"
          exec ${fallback} "$@"
        '';
      })
    nixTools;
  };
in {
  # Expose the manager, not Rustup's cargo/rustc proxies that would shadow Nix.
  home.packages = [
    (pkgs.writeShellScriptBin "rustup" ''
      exec ${pkgs.rustup}/bin/rustup "$@"
    '')
  ];

  programs.nvf.settings.vim = {
    # extraPackages is appended to PATH, behind the shell's existing Rust tools.
    luaConfigPre = ''
      vim.env.PATH = "${rustTools}/bin:" .. (vim.env.PATH or "")
    '';

    languages.rust = {
      enable = true;
      lsp.servers = ["rust-analyzer"];
      format = {
        enable = true;
        type = ["rustfmt"];
      };
    };

    lsp.servers.rust-analyzer = {
      # Neovim's cwd may be a different project; select per LSP workspace.
      cmd = lib.mkForce (lib.generators.mkLuaInline ''
        function(dispatchers, server_config)
          return vim.lsp.rpc.start({ "${rustTools}/bin/rust-analyzer" }, dispatchers, {
            cwd = server_config.root_dir,
            env = server_config.cmd_env,
          })
        end
      '');

      settings.rust-analyzer = {
        checkOnSave = true;
        check.command = "clippy";
      };
    };

    formatter.conform-nvim.setupOpts = {
      formatters.rustfmt = {
        command = lib.mkForce "${rustTools}/bin/rustfmt";
        # Toolchain and rustfmt.toml lookup must start at this buffer's directory.
        cwd = lib.generators.mkLuaInline ''
          function(_, ctx)
            return ctx.dirname
          end
        '';
      };
    };
  };
}
