{
  inputs,
  den,
}: {
  home,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    (import ./languages/nix.nix {inherit den home;})
    ./languages/lua.nix
    ./languages/shell.nix
    ./languages/python.nix
    ./languages/rust.nix
    ./languages/java.nix
    (import ./languages/web.nix {inherit inputs;})
    ./languages/json.nix
    ./languages/yaml.nix
    ./languages/toml.nix
    ./languages/markdown.nix
    ./languages/mdx.nix
    ./languages/just.nix
  ];

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

        # Keep folds available, but start each buffer with its contents visible.
        foldlevel = 99;
        foldlevelstart = 99;
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

      theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
        transparent = false;
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

      # Install parsers for the selected language modules, not every grammar.
      languages.enableTreesitter = true;

      treesitter = {
        enable = true;
        addDefaultGrammars = true;
        highlight.enable = true;
        indent.enable = true;
        fold = true;

        # Parsers are supplied by Nix; no runtime parser compiler is needed.
        vendorCLI = false;
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
        formatOnSave = true;
      };

      formatter.conform-nvim.setupOpts = {
        # Use the on-save hook, without a second asynchronous formatting pass.
        format_after_save = null;

        # Allow JVM and Rust toolchain startup without slowing other formatters.
        format_on_save = lib.generators.mkLuaInline ''
          function(bufnr)
            if not vim.g.formatsave or vim.b[bufnr].disableFormatSave then
              return
            end
            local timeouts = { java = 3000, rust = 2000 }
            return {
              lsp_format = "fallback",
              timeout_ms = timeouts[vim.bo[bufnr].filetype] or 500,
            }
          end
        '';
      };

      fzf-lua.enable = true;

      mini = {
        ai = {
          enable = true;
          # Preserve native an/in syntax selection in Visual mode.
          setupOpts.mappings = {
            around_next = "aN";
            inside_next = "iN";
            around_last = "aL";
            inside_last = "iL";
          };
        };

        bufremove.enable = true;

        pairs = {
          enable = true;
          setupOpts.modes = {
            insert = true;
            command = false;
            terminal = false;
          };
        };

        move = {
          enable = true;
          # Keep Alt+h/j/k/l available to AeroSpace instead of Neovim.
          setupOpts.mappings = {
            left = "<leader>mh";
            down = "<leader>mj";
            up = "<leader>mk";
            right = "<leader>ml";
            line_left = "<leader>mh";
            line_down = "<leader>mj";
            line_up = "<leader>mk";
            line_right = "<leader>ml";
          };
        };

        # Share file icons between pickers and the status line.
        icons.enable = true;
        statusline.enable = true;

        indentscope = {
          enable = true;
          # Mark the current indentation scope without an animated reveal.
          setupOpts.draw.animation = lib.generators.mkLuaInline ''
            require("mini.indentscope").gen_animation.none()
          '';
        };

        # Highlight trailing whitespace; do not automatically trim it on save.
        trailspace.enable = true;
      };

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
        register = {
          "<leader>b" = "+Buffers";
          "<leader>f" = "+FZF";
          "<leader>m" = "+Move";
        };
      };

      keymaps = [
        {
          key = "<leader>bd";
          mode = "n";
          action = "<Cmd>lua MiniBufremove.delete(0, false)<CR>";
          desc = "Close buffer (keep splits)";
        }
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
