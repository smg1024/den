{
  programs.nvf.settings.vim = {
    # React, Next.js, and React Native use the project's JS/TS types and config.
    # Nixpkgs supplies tsserver as a fallback when the project lacks TypeScript.
    languages.typescript = {
      enable = true;
      lsp.servers = ["typescript-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
      extraDiagnostics.enable = false;
      extensions.ts-error-translator.enable = false;
    };

    languages.tsx = {
      enable = true;
      lsp.servers = ["typescript-language-server"];
      format = {
        enable = true;
        type = ["prettier"];
      };
      # Shared ESLint handles JSX/TSX too; do not enable NVF's Biome default.
      extraDiagnostics.enable = false;
    };
  };
}
