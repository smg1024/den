{
  den.aspects.macos-defaults.darwin = {config, ...}: let
    primaryUserHome = config.users.users.${config.system.primaryUser}.home;
  in {
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      watchIdAuth = true;
    };

    system = {
      defaults = {
        loginwindow = {
          GuestEnabled = false;
        };

        controlcenter = {
          AirDrop = false;
          BatteryShowPercentage = false;
          Bluetooth = false;
          Display = false;
          FocusModes = false;
          NowPlaying = false;
          Sound = false;
        };

        menuExtraClock = {
          Show24Hour = true;
          ShowDayOfMonth = false;
          ShowDayOfWeek = false;
          ShowSeconds = false;
          FlashDateSeparators = false;
          ShowDate = 1;
        };

        dock = {
          autohide = true;
          autohide-delay = 0.01;
          autohide-time-modifier = 0.1;
          mineffect = "suck";
          show-recents = false;
          tilesize = 50;
          magnification = true;
          largesize = 70;
          showMissionControlGestureEnabled = true;
        };

        finder = {
          AppleShowAllFiles = true;
          AppleShowAllExtensions = true;
          ShowStatusBar = true;
          ShowPathbar = true;
          FXPreferredViewStyle = "clmv";
          FXRemoveOldTrashItems = true;
          _FXEnableColumnAutoSizing = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
          _FXSortFoldersFirstOnDesktop = true;
          FXEnableExtensionChangeWarning = false;
          FXDefaultSearchScope = "SCcf";
          NewWindowTarget = "Other";
          NewWindowTargetPath = "file://${primaryUserHome}/Downloads";
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          QuitMenuItem = true;
        };

        trackpad = {
          Clicking = true;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
          TrackpadFourFingerHorizSwipeGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
          TrackpadPinch = true;
          TrackpadThreeFingerHorizSwipeGesture = 0;
          TrackpadThreeFingerVertSwipeGesture = 0;
          TrackpadTwoFingerDoubleTapGesture = true;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
        };

        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };

        smb = {
          NetBIOSName = config.networking.hostName;
          ServerDescription = config.networking.hostName;
        };

        WindowManager = {
          AppWindowGroupingBehavior = true;
          EnableStandardClickToShowDesktop = false;
          EnableTilingByEdgeDrag = false;
          EnableTilingOptionAccelerator = false;
          EnableTopTilingByEdgeDrag = false;
          StandardHideDesktopIcons = true;
          StandardHideWidgets = true;
        };

        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleKeyboardUIMode = 2;
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          AppleShowScrollBars = "WhenScrolling";
          AppleScrollerPagingBehavior = true;
          AppleEnableMouseSwipeNavigateWithScrolls = true;
          AppleEnableSwipeNavigateWithScrolls = true;
          AppleSpacesSwitchOnActivate = true;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSTableViewDefaultSizeMode = 2;
          "com.apple.keyboard.fnState" = true;
          "com.apple.sound.beep.feedback" = 0;
        };

        CustomUserPreferences = {
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.ImageCapture".disableHotPlug = true;
          "com.apple.dock" = {
            springboard-columns = 10;
            springboard-rows = 10;
            ResetLaunchPad = true;
          };
        };
      };

      keyboard = {
        enableKeyMapping = true;
      };
    };
  };
}
