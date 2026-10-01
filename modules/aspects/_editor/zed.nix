{inputs}: {pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    package = inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = false;

    extraPackages = with pkgs; [
      nixd
      alejandra
      stylua
      prettier
      typescript
      mdx-language-server
      jdt-language-server
      google-java-format
      taplo
    ];

    extensions = [
      "astro"
      "caddyfile"
      "catppuccin"
      "catppuccin-icons"
      "dockerfile"
      "git-firefly"
      "groovy"
      "html"
      "java"
      "just"
      "kotlin"
      "lua"
      "make"
      "mdx"
      "nix"
      "sql"
      "svelte"
      "tombi"
      "toml"
    ];

    mutableUserSettings = true;
    mutableUserKeymaps = true;
    mutableUserTasks = true;
    mutableUserDebug = true;

    userSettings = {
      format_on_save = "on";
      ui_font_family = "D2KodingLigature Nerd Font";
      ui_font_fallbacks = ["MesloLGL Nerd Font"];
      colorize_brackets = true;
      toolbar = {
        code_actions = true;
      };
      tab_size = 2;
      show_signature_help_after_edits = false;
      auto_signature_help = false;
      redact_private_values = false;
      cli_default_open_behavior = "existing_window";
      edit_predictions = {
        provider = "copilot";
      };
      agent_servers = {
        codex-acp = {
          default_config_options = {
            model = "gpt-5.6-sol";
            reasoning_effort = "xhigh";
            mode = "agent-full-access";
            fast-mode = true;
          };
          type = "registry";
        };
        claude-acp = {
          default_config_options = {
            model = "default";
            effort = "xhigh";
            mode = "auto";
            fast = true;
          };
          type = "registry";
        };
      };
      session = {
        trust_all_worktrees = true;
      };
      git = {
        inline_blame = {
          enabled = true;
        };
      };
      status_bar = {
        show_active_file = false;
      };
      gutter = {
        line_numbers = true;
      };
      cursor_shape = "bar";
      cursor_blink = true;
      use_system_window_tabs = true;
      show_whitespaces = "all";
      show_edit_predictions = true;
      git_panel = {
        collapse_untracked_diff = true;
        show_count_badge = true;
        diff_stats = true;
        file_icons = true;
        tree_view = true;
        dock = "right";
      };
      icon_theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Macchiato";
      };
      base_keymap = "VSCode";
      theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Macchiato";
      };
      ui_font_size = 17.0;
      buffer_font_size = 15.0;
      agent_ui_font_size = 18.0;
      file_finder = {
        modal_max_width = "medium";
      };
      buffer_font_family = "D2KodingLigature Nerd Font";
      buffer_font_fallbacks = ["MesloLGL Nerd Font"];
      vim_mode = true;
      vim = {
        use_smartcase_find = true;
      };
      which_key = {
        delay_ms = 500;
        enabled = true;
      };
      relative_line_numbers = "enabled";
      use_smartcase_search = true;
      vertical_scroll_margin = 5;
      horizontal_scroll_margin = 10;
      tab_bar = {
        show = true;
        show_nav_history_buttons = false;
      };
      scrollbar = {
        show = "auto";
      };
      tabs = {
        file_icons = true;
        git_status = false;
        show_diagnostics = "errors";
        show_close_button = "hover";
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        background_coloring = "indent_aware";
      };
      centered_layout = {
        left_padding = 0.15;
        right_padding = 0.15;
      };
      agent = {
        default_model = {
          speed = "fast";
          provider = "openai-subscribed";
          model = "gpt-5.6-sol";
          enable_thinking = true;
          effort = "xhigh";
        };
        favorite_models = [
          {
            provider = "openai-subscribed";
            model = "gpt-5.6-sol";
            enable_thinking = true;
            effort = "xhigh";
            speed = "fast";
          }
        ];
        default_profile = "write";
        sidebar_side = "left";
        dock = "left";
        inline_assistant_model = {
          provider = "openai-subscribed";
          model = "gpt-5.6-sol";
        };
        notify_when_agent_waiting = "primary_screen";
        play_sound_when_agent_done = "never";
        single_file_review = true;
        model_parameters = [];
        tool_permissions = {
          default = "allow";
          tools = {
            terminal = {
              always_allow = [
                {
                  pattern = "^(cargo|npm|bun|pnpm|yarn|deno)\\s+(build|test|check|run|format|lint|fix)";
                }
                {
                  pattern = "^(git\\s+(add|commit|diff|log|status|push|pull|branch\\s+-[Dd]))";
                }
                {
                  pattern = "^(ls|cat|head|tail|wc|echo|pwd|which|type|file)";
                }
              ];
              always_deny = [
                {
                  pattern = "^(sudo|su|doas)\\s";
                }
                {
                  pattern = "^rm\\s+-[rf]\\s+/";
                }
              ];
            };
            fetch = {
              always_allow = [
                {
                  pattern = "^https://(api\\.)?github\\.com";
                }
                {
                  pattern = "^https://raw\\.githubusercontent\\.com";
                }
              ];
            };
          };
        };
        sandbox_permissions = {
          allow_all_hosts = true;
          allow_unsandboxed = true;
          write_paths = ["/tmp/zed/sandbox"];
        };
      };
      inlay_hints = {
        show_background = true;
        enabled = true;
      };
      languages = {
        Python = {
          formatter = {
            language_server = {
              name = "ruff";
            };
          };
        };
        Rust = {
          enable_language_server = true;
          formatter = {
            language_server = {
              name = "rust-analyzer";
            };
          };
          language_servers = [
            "rust-analyzer"
            "!rustc"
          ];
        };
        Markdown = {
          format_on_save = "off";
          preferred_line_length = 80;
        };
        MDX = {
          language_servers = ["mdx-analyzer"];
          formatter = {
            external = {
              command = "${pkgs.prettier}/bin/prettier";
              arguments = ["--stdin-filepath" "{buffer_path}"];
            };
          };
          format_on_save = "on";
          preferred_line_length = 80;
          tab_size = 2;
        };
        JSON = {};
        JSONC = {};
        Java = {
          enable_language_server = true;
          language_servers = ["jdtls"];
          formatter = {
            external = {
              command = "${pkgs.google-java-format}/bin/google-java-format";
              arguments = [
                "--assume-filename"
                "{buffer_path}"
                "-"
              ];
            };
          };
          format_on_save = "on";
        };
        Nix = {
          language_servers = ["nixd" "!nil"];
          formatter = {
            external = {
              command = "${pkgs.alejandra}/bin/alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };
        Lua = {
          formatter = {
            external = {
              command = "${pkgs.stylua}/bin/stylua";
              arguments = [
                "--syntax=Lua54"
                "--respect-ignores"
                "--stdin-filepath"
                "{buffer_path}"
                "-"
              ];
            };
          };
        };
        Svelte = {
          language_servers = ["!biome" "..."];
          formatter = "prettier";
        };
        Astro = {
          language_servers = ["!biome" "..."];
          formatter = "prettier";
        };
        TOML = {
          language_servers = ["taplo"];
          format_on_save = "on";
          formatter = {
            external = {
              command = "${pkgs.taplo}/bin/taplo";
              arguments = ["fmt" "--option" "align_entries=true" "-"];
            };
          };
        };
      };
      lsp = {
        # GUI launches bypass the CLI wrapper provided by extraPackages.
        nixd.binary.path = "${pkgs.nixd}/bin/nixd";
        taplo.binary = {
          path = "${pkgs.taplo}/bin/taplo";
          arguments = ["lsp" "stdio"];
        };
        jdtls = {
          settings = {
            jdtls_launcher = "${pkgs.jdt-language-server}/bin/jdtls";
            java_home = "${pkgs.jdk25.home}";
            lombok_support = true;
          };
        };
        mdx-analyzer = {
          binary = {
            path = "${pkgs.mdx-language-server}/bin/mdx-language-server";
            arguments = ["--stdio"];
          };
          initialization_options = {
            typescript = {
              enabled = true;
              tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
            };
          };
        };
        rust-analyzer = {
          initialization_options = {
            inlayHints = {
              bindingModeHints = {
                enable = true;
              };
              chainingHints = {
                enable = true;
              };
              closingBraceHints = {
                enable = true;
              };
              lifetimeElisionHints = {
                enable = "skip_trivial";
              };
              typeHints = {
                enable = true;
              };
              parameterHints = {
                enable = true;
              };
              reborrowHints = {
                enable = "mutable";
              };
            };
            checkOnSave = true;
            check = {
              command = "clippy";
            };
            cargo = {
              features = "all";
            };
            procMacro = {
              enable = true;
            };
          };
        };
        biome = {
          settings = {
            lineWidth = 100;
            indentStyle = "space";
            indentWidth = 2;
            organizeImports = {
              enabled = true;
            };
            linter = {
              enabled = true;
            };
            formatter = {
              enabled = true;
            };
            javascript = {
              formatter = {
                quoteStyle = "double";
                semicolons = "always";
                trailingCommas = "all";
              };
            };
          };
        };
      };
      terminal = {
        shell = "system";
        show_count_badge = true;
        font_size = 16.0;
        font_family = "D2KodingLigature Nerd Font";
        font_fallbacks = ["MesloLGL Nerd Font"];
        env = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
      file_types = {
        Dockerfile = [
          "Dockerfile"
          "Dockerfile.*"
        ];
        JSON = [
          "json"
          "jsonc"
          "*.code-snippets"
        ];
      };
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/out"
        "**/result"
        "**/dist"
        "**/.husky"
        "**/.turbo"
        "**/.vscode-test"
        "**/.vscode"
        "**/.next"
        "**/.storybook"
        "**/.tap"
        "**/.nyc_output"
        "**/report"
        "**/node_modules"
      ];
      telemetry = {
        diagnostics = true;
        metrics = false;
      };
      project_panel = {
        hide_root = true;
        git_status = true;
        diagnostic_badges = true;
        show_diagnostics = "errors";
        auto_fold_dirs = false;
        button = true;
        dock = "right";
        entry_spacing = "comfortable";
      };
      outline_panel = {
        dock = "right";
      };
      collaboration_panel = {
        dock = "right";
      };
      active_pane_modifiers = {
        inactive_opacity = 0.5;
      };
      title_bar = {
        show_branch_status_icon = true;
      };
      soft_wrap = "editor_width";
    };

    userKeymaps = [
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
        bindings = {
          "space g h d" = "editor::ToggleSelectedDiffHunks";
          "space g s" = "git_panel::Toggle";
          "space c i" = "editor::ToggleInlayHints";
          "space u w" = "editor::ToggleSoftWrap";
          "space m p" = "markdown::OpenPreview";
          "space m P" = "markdown::OpenPreviewToTheSide";
          "space f p" = "projects::OpenRecent";
          "space f w" = "pane::DeploySearch";
          "space f b" = "buffer_search::Deploy";
          "space a i" = "assistant::InlineAssist";
          "space a c" = "agent::ToggleFocus";
          "space a n" = "agent::NewThread";
          "space a m" = "agent::ToggleModelSelector";
          "space a a" = "agent::OpenProjectAGENTS.mdRules";
          "space a d" = "agent::OpenAgentDiff";
          "g f" = "editor::OpenExcerpts";
          alt-k = "editor::MoveLineUp";
          alt-j = "editor::MoveLineDown";
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
          "space c a" = "editor::ToggleCodeActions";
          "space c r" = "editor::Rename";
          "space c f" = "editor::Format";
          "g d" = "editor::GoToDefinition";
          "g D" = "editor::GoToDefinitionSplit";
          "g i" = "editor::GoToImplementation";
          "g I" = "editor::GoToImplementationSplit";
          "g t" = "editor::GoToTypeDefinition";
          "g T" = "editor::GoToTypeDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          "] d" = "editor::GoToDiagnostic";
          "[ d" = "editor::GoToPreviousDiagnostic";
          "] e" = [
            "editor::GoToDiagnostic"
            {severity = "error";}
          ];
          "[ e" = [
            "editor::GoToPreviousDiagnostic"
            {severity = "error";}
          ];
          "] w" = [
            "editor::GoToDiagnostic"
            {severity = "warning";}
          ];
          "[ w" = [
            "editor::GoToPreviousDiagnostic"
            {severity = "warning";}
          ];
          "] H" = [
            "editor::GoToDiagnostic"
            {severity = "hint";}
          ];
          "[ H" = [
            "editor::GoToPreviousDiagnostic"
            {severity = "hint";}
          ];
          "space f s" = "outline::Toggle";
          "space f S" = "project_symbols::Toggle";
          "space x x" = "diagnostics::Deploy";
          "] h" = "editor::GoToHunk";
          "[ h" = "editor::GoToPreviousHunk";
          "space g d" = "git::Diff";
          "space g b" = "editor::ToggleGitBlameInline";
          "space g h e" = "editor::ExpandAllDiffHunks";
          shift-h = "pane::ActivatePreviousItem";
          shift-l = "pane::ActivateNextItem";
          "space space" = "file_finder::Toggle";
          "space e" = "pane::RevealInProjectPanel";
          "space w w" = "workspace::ActivatePreviousPane";
          "space w -" = "pane::SplitDown";
          "space w |" = "pane::SplitRight";
          ctrl-shift-k = "vim::ResizePaneUp";
          ctrl-shift-j = "vim::ResizePaneDown";
          ctrl-shift-h = "vim::ResizePaneLeft";
          ctrl-shift-l = "vim::ResizePaneRight";
        };
      }
      {
        context = "EmptyPane || SharedScreen";
        bindings = {
          "space space" = "file_finder::Toggle";
          "space f p" = "projects::OpenRecent";
          "space a c" = "agent::ToggleFocus";
          "space g s" = "git_panel::Toggle";
        };
      }
      {
        context = "Editor && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          "g c" = "editor::ToggleComments";
          "space a e" = [
            "assistant::InlineAssist"
            {
              prompt = "Explain the selected code. Cover purpose, control flow, and non-obvious behavior.";
            }
          ];
          "space a f" = [
            "assistant::InlineAssist"
            {
              prompt = "Fix bugs and issues in the selected code. Identify root causes, not just symptoms.";
            }
          ];
          "space a t" = [
            "assistant::InlineAssist"
            {
              prompt = "Generate focused unit tests for the selected code. Use the project's test framework and conventions. Output with arrange/act/assert sections.";
            }
          ];
          "space a r" = [
            "assistant::InlineAssist"
            {
              prompt = "Refactor the selected code for clarity and maintainability without changing external behavior. Extract functions, simplify conditions, remove duplication.";
            }
          ];
          "space a d" = [
            "assistant::InlineAssist"
            {
              prompt = "Add concise inline documentation comments to the selected code without changing logic.";
            }
          ];
          "space a k" = [
            "assistant::InlineAssist"
            {
              prompt = "Summarize the selected code. One-paragraph summary plus key takeaways.";
            }
          ];
          "space a n" = "agent::NewThread";
          "space a v" = [
            "action::Sequence"
            [
              "agent::ToggleFocus"
              "agent::AddSelectionToThread"
            ]
          ];
        };
      }
      {
        context = "Workspace";
        bindings = {
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          a = "project_panel::NewFile";
          A = "project_panel::NewDirectory";
          r = "project_panel::Rename";
          d = "project_panel::Delete";
          x = "project_panel::Cut";
          c = "project_panel::Copy";
          p = "project_panel::Paste";
          "space e" = "workspace::ToggleRightDock";
        };
      }
    ];

    userDebug = [
      {
        adapter = "Java";
        request = "launch";
        label = "Launch Java";
        cwd = "$ZED_WORKTREE_ROOT";
        stopOnEntry = false;
      }
    ];
  };
}
