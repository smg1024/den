{
  inputs,
  den,
  ...
}: {
  den.aspects.homebrew.includes = [den.aspects.hammerspoon];

  den.aspects.homebrew.darwin = {config, ...}: {
    imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

    # Manage Homebrew itself; nix-darwin manages the packages below.
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = config.system.primaryUser;
      mutableTaps = true;
    };

    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        upgrade = true;
        cleanup = "zap";
      };

      masApps = {
        KakaoTalk = 869223134;
        Across = 6444851827;
        Bitwarden = 1352778147;
        Pages = 361309726;
        Numbers = 361304891;
        Keynote = 361285480;
      };

      brews = [
        "cue"
        "mole"
        "rtk"
      ];

      casks = [
        "antigravity-cli"
        "aside"
        "atoll"
        "batfi"
        "chatgpt"
        "claude"
        "claude-code@latest"
        "codex"
        "codexbar"
        "discord"
        "finetune"
        "google-chrome"
        "iina"
        "keka"
        "kekaexternalhelper"
        "logi-options+"
        "postmelee/tap/alhangeul"
        "raycast"
        "snapzy"
        "stats"
        "tailscale-app"
        "telegram"
        "thaw@beta"
        "utm"
      ];
    };
  };
}
