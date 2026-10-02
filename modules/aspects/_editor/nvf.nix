{inputs}: {
  lib,
  pkgs,
  ...
}: {
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
