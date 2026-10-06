{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Use Starship's default layout and the pinned preset for fallback icons.
    presets = ["nerd-font-symbols"];

    # Override recognizable symbols with emoji; other modules retain Nerd Fonts.
    # Symbol overrides do not enable modules that Starship disables by default.
    settings = {
      aws.symbol = "☁️ ";
      azure.symbol = "☁️ ";
      gcloud.symbol = "☁️ ";

      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "🪫 ";
        unknown_symbol = "❓ ";
        empty_symbol = "🪫 ";
      };

      bun.symbol = "🥟 ";
      conda.symbol = "🐍 ";
      container.symbol = "📦 ";
      deno.symbol = "🦕 ";
      directory.read_only = " 🔒";
      docker_context.symbol = "🐳 ";
      elixir.symbol = "💧 ";
      git_branch.symbol = "🌿 ";
      git_commit.tag_symbol = " 🏷️ ";
      golang.symbol = "🐹 ";
      gradle.symbol = "🐘 ";
      helm.symbol = "⚓ ";
      hostname.ssh_symbol = "🌐 ";
      java.symbol = "☕ ";
      kubernetes.symbol = "☸️ ";
      lua.symbol = "🌙 ";
      mojo.symbol = "🔥 ";
      nix_shell.symbol = "❄️ ";
      nodejs.symbol = "🟢 ";
      package.symbol = "📦 ";
      perl.symbol = "🐪 ";
      php.symbol = "🐘 ";
      python.symbol = "🐍 ";
      ruby.symbol = "💎 ";
      rust.symbol = "🦀 ";
      swift.symbol = "🐦 ";
      terraform.symbol = "🏗️ ";

      os.symbols = {
        Android = "🤖 ";
        Ios = "📱 ";
        Linux = "🐧 ";
        Macos = "🍎 ";
        NixOS = "❄️ ";
        Unknown = "❓ ";
        Windows = "🪟 ";
      };
    };
  };
}
