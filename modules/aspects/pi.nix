{
  den.aspects.pi.homeManager = {
    programs.pi-coding-agent = {
      enable = true;
      mutableSettings = true;

      settings = {
        defaultProvider = "jev";
        defaultModel = "auto";
        enabledModels = [
          "auto"
          "claude-fable-5-2"
          "claude-opus-5-5"
          "claude-sonnet-5-5"
          "gpt-6-luna"
          "gpt-6.1-terra"
          "gpt-6.2-astra"
          "gpt-6.2-sol"
        ];
        defaultProjectTrust = "always";
        compaction.enabled = true;
        defaultTools = ["+codemode" "+grep" "+find" "+ls"];
        codemode.mode = "on";
        packages = [
          "git:github.com/earendil-works/pi-claude-code"
          "npm:pi-web-access"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:context-mode"
          "npm:@juicesharp/rpiv-todo"
          "git:github.com/smg1024/jev-router"
          "npm:pi-subagents"
        ];
      };
    };
  };
}
