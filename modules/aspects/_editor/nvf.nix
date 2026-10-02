{
  inputs,
  den,
}: {
  config,
  home,
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
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {
      searchCase = "smart";
      hideSearchHighlight = true;

      options = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        wrap = false;
        scrolloff = 10;
        sidescrolloff = 8;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      undoFile.enable = true;

      spellcheck = {
        enable = true;
        languages = ["en"];
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;

        # Keep Enter normal and let super-tab own Tab/Shift-Tab.
        mappings = {
          confirm = null;
          next = null;
          previous = null;
        };

        setupOpts = {
          keymap = {
            preset = "super-tab";
            "<C-j>" = ["select_next" "fallback"];
            "<C-k>" = ["select_prev" "fallback"];
          };

          cmdline.keymap.preset = "inherit";
          completion.documentation.auto_show_delay_ms = 1000;
        };
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
        formatOnSave = true;

        servers.bash-language-server.settings.bashIde = {
          shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
          shfmt.path = "${pkgs.shfmt}/bin/shfmt";
        };

        servers.nixd.settings.nixd = {
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

      languages.lua = {
        enable = true;
        lsp.servers = ["lua-language-server"];
        format = {
          enable = true;
          type = ["stylua"];
        };
        extraDiagnostics = {
          enable = true;
          types = ["luacheck"];
        };
      };

      languages.bash = {
        enable = true;
        lsp.servers = ["bash-language-server"];
        format = {
          enable = true;
          type = ["shfmt"];
        };
        # Bash Language Server already provides ShellCheck diagnostics.
        extraDiagnostics.enable = false;
      };

      formatter.conform-nvim.setupOpts = {
        # Use the on-save hook, without a second asynchronous formatting pass.
        format_after_save = null;

        # Pinned NVF maps its Zsh formatter to sh; wire zsh explicitly instead.
        # shfmt detects .zshrc, other Zsh startup files, .zsh, and Zsh shebangs.
        # Do not attach Bash Language Server or ShellCheck to Zsh buffers.
        formatters_by_ft.zsh = ["shfmt"];
      };

      fzf-lua.enable = true;

      # Provide file icons for Neovim pickers.
      mini.icons.enable = true;

      utility = {
        surround = {
          enable = true;
          useVendoredKeybindings = true;
        };

        yazi-nvim = {
          enable = true;
          mappings = {
            openYazi = "<leader>-";
            openYaziDir = "<leader>e";
            yaziToggle = "<leader>E";
          };

          setupOpts = {
            clipboard_register = "+";
            enable_mouse_support = true;

            # grug-far is not enabled; keep its integration shortcut inactive.
            keymaps.replace_in_directory = false;

            integrations = {
              grep_in_directory = "fzf-lua";
              grep_in_selected_files = "fzf-lua";
              # The macOS default expects Homebrew's grealpath.
              resolve_relative_path_application = "${pkgs.coreutils}/bin/realpath";
            };
          };
        };
      };

      binds.whichKey = {
        enable = true;
        register."<leader>f" = "+FZF";
      };

      keymaps = [
        {
          key = "<leader>ff";
          mode = "n";
          action = "<Cmd>FzfLua files<CR>";
          desc = "Find files";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<Cmd>FzfLua live_grep_native<CR>";
          desc = "Search project text";
        }
        {
          key = "<leader><leader>";
          mode = "n";
          action = "<Cmd>FzfLua buffers<CR>";
          desc = "Buffers";
        }
        {
          key = "<leader>fo";
          mode = "n";
          action = "<Cmd>FzfLua oldfiles<CR>";
          desc = "Recent files";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<Cmd>FzfLua resume<CR>";
          desc = "Resume last picker";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = "<Cmd>FzfLua helptags<CR>";
          desc = "Help tags";
        }
        {
          key = "<leader>fk";
          mode = "n";
          action = "<Cmd>FzfLua keymaps<CR>";
          desc = "Keymaps";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = "<Cmd>FzfLua builtin<CR>";
          desc = "FzfLua commands";
        }
        {
          key = "n";
          mode = "n";
          action = "nzzzv";
          desc = "Next search result (centered)";
        }
        {
          key = "N";
          mode = "n";
          action = "Nzzzv";
          desc = "Previous search result (centered)";
        }
        {
          key = "<C-d>";
          mode = "n";
          action = "<C-d>zz";
          desc = "Half page down (centered)";
        }
        {
          key = "<C-u>";
          mode = "n";
          action = "<C-u>zz";
          desc = "Half page up (centered)";
        }
        {
          key = "<";
          mode = "v";
          action = "<gv";
          desc = "Indent left and reselect";
        }
        {
          key = ">";
          mode = "v";
          action = ">gv";
          desc = "Indent right and reselect";
        }
        {
          key = "J";
          mode = "n";
          action = "mzJ`z";
          desc = "Join lines and keep cursor position";
        }
      ];

      augroups = [{name = "NvfCore";}];
      autocmds = [
        {
          event = ["BufReadPost"];
          group = "NvfCore";
          desc = "Return to last cursor position";
          callback = lib.generators.mkLuaInline ''
            function()
              local mark = vim.api.nvim_buf_get_mark(0, '"')
              local line_count = vim.api.nvim_buf_line_count(0)
              if mark[1] > 0 and mark[1] <= line_count then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
              end
            end
          '';
        }
        {
          event = ["TextYankPost"];
          group = "NvfCore";
          desc = "Highlight yanked text for 250 ms";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.hl.on_yank({
                higroup = "IncSearch",
                timeout = 250,
              })
            end
          '';
        }
      ];
    };
  };

  # Some terminal tools prefer VISUAL over EDITOR, which NVF sets above.
  home.sessionVariables.VISUAL = "nvim";
}
