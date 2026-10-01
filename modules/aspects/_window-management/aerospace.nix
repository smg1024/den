{
  lib,
  pkgs,
  ...
}: let
  inherit
    (import ./aerospace-rules.nix)
    floatingRule
    workspaceRule
    ;
in
  lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    programs.aerospace = {
      enable = true;
      # Home Manager owns login startup through its launchd agent.
      launchd.enable = true;

      settings = {
        config-version = 2;
        persistent-workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
        accordion-padding = 20;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
        automatically-unhide-macos-hidden-apps = false;

        key-mapping = {
          preset = "qwerty";
        };

        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "main";
          "3" = "main";
          "4" = "main";
          "5" = "main";
          "6" = ["secondary" "main"];
          "7" = ["secondary" "main"];
          "8" = ["secondary" "main"];
          "9" = ["secondary" "main"];
        };

        gaps = {
          inner.horizontal = 3;
          inner.vertical = 3;
          outer.left = 3;
          outer.bottom = 3;
          outer.top = 3;
          outer.right = 3;
        };

        mode.main.binding = {
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-1 = "workspace --auto-back-and-forth 1";
          alt-2 = "workspace --auto-back-and-forth 2";
          alt-3 = "workspace --auto-back-and-forth 3";
          alt-4 = "workspace --auto-back-and-forth 4";
          alt-5 = "workspace --auto-back-and-forth 5";
          alt-6 = "workspace --auto-back-and-forth 6";
          alt-7 = "workspace --auto-back-and-forth 7";
          alt-8 = "workspace --auto-back-and-forth 8";
          alt-9 = "workspace --auto-back-and-forth 9";
          alt-shift-1 = ["move-node-to-workspace 1" "workspace --auto-back-and-forth 1"];
          alt-shift-2 = ["move-node-to-workspace 2" "workspace --auto-back-and-forth 2"];
          alt-shift-3 = ["move-node-to-workspace 3" "workspace --auto-back-and-forth 3"];
          alt-shift-4 = ["move-node-to-workspace 4" "workspace --auto-back-and-forth 4"];
          alt-shift-5 = ["move-node-to-workspace 5" "workspace --auto-back-and-forth 5"];
          alt-shift-6 = ["move-node-to-workspace 6" "workspace --auto-back-and-forth 6"];
          alt-shift-7 = ["move-node-to-workspace 7" "workspace --auto-back-and-forth 7"];
          alt-shift-8 = ["move-node-to-workspace 8" "workspace --auto-back-and-forth 8"];
          alt-shift-9 = ["move-node-to-workspace 9" "workspace --auto-back-and-forth 9"];
          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-node-to-monitor --wrap-around next";

          cmd-h = [];
          cmd-alt-h = [];

          alt-shift-semicolon = "mode service";
          alt-shift-r = "mode resize";
        };

        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          f = ["layout floating tiling" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];
          alt-shift-h = ["join-with left" "mode main"];
          alt-shift-j = ["join-with down" "mode main"];
          alt-shift-k = ["join-with up" "mode main"];
          alt-shift-l = ["join-with right" "mode main"];
        };

        mode.resize.binding = {
          minus = "resize smart -50";
          equal = "resize smart +50";
          esc = "mode main";
        };

        # Shared across hosts and modes, including apps that may not be installed.
        on-window-detected = [
          (workspaceRule "com.mitchellh.ghostty" "1")
          (workspaceRule "dev.zed.Zed" "1")
          (workspaceRule "dev.zed.Zed-Nightly" "1")
          (workspaceRule "com.apple.dt.Xcode" "1")
          (workspaceRule "com.google.android.studio" "1")
          (workspaceRule "com.jetbrains.datagrip" "1")
          (workspaceRule "app.zen-browser.zen" "2")
          (workspaceRule "com.google.Chrome" "2")
          (workspaceRule "at.studio.AsideBrowser" "2")
          (workspaceRule "com.anthropic.claudefordesktop" "3")
          (workspaceRule "com.openai.codex" "3")
          (workspaceRule "com.apple.campo" "3")
          (workspaceRule "com.postmelee.alhangeul" "4")
          (workspaceRule "com.apple.Numbers" "4")
          (workspaceRule "com.apple.Pages" "4")
          (workspaceRule "com.apple.Keynote" "4")
          (workspaceRule "notion.id" "4")
          (workspaceRule "md.obsidian" "4")
          (workspaceRule "com.daymore.Across" "6")
          (workspaceRule "com.bitwarden.desktop" "6")
          (workspaceRule "com.apple.mail" "7")
          (workspaceRule "com.hnc.Discord" "8")
          (workspaceRule "com.tinyspeck.slackmacgap" "8")
          (workspaceRule "com.kakao.KakaoTalkMac" "9")
          (workspaceRule "ru.keepcoder.Telegram" "9")
          (floatingRule "com.apple.finder")
          (floatingRule "com.apple.Notes")
          (floatingRule "com.apple.ScreenSharing")
          (floatingRule "com.apple.dt.Devices")
          (floatingRule "com.apple.reminders")
          (floatingRule "org.hammerspoon.Hammerspoon")
          (floatingRule "com.utmapp.UTM")
          (floatingRule "com.apple.MobileSMS")
          (floatingRule "cc.ffitch.shottr")
          (floatingRule "com.apple.Preview")
          (floatingRule "com.Ebullioscopic.Atoll")
          (floatingRule "io.tailscale.ipn.macsys")
          (floatingRule "com.stonerl.Thaw")
          (floatingRule "com.logi.optionsplus")
          (floatingRule "com.colliderli.iina")
          (floatingRule "eu.exelban.Stats")
          (floatingRule "com.trongduong.snapzy")
          (floatingRule "com.electron.dockerdesktop")
        ];

        after-startup-command = [
          "layout --workspace 1 --root h_accordion"
          "layout --workspace 2 --root h_accordion"
          "layout --workspace 3 --root h_accordion"
          "layout --workspace 6 --root h_accordion"
        ];
      };
    };
  }
