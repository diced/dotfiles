{ ... }:

{
  vim.lsp = {
    enable = true;
    formatOnSave = true;

    inlayHints.enable = true;

    trouble = {
      enable = true;
      mappings.lspReferences = null;
    };

    otter-nvim.enable = true;

    mappings.goToDefinition = null;

    presets = {
      tailwindcss-language-server.enable = true;
    };
  };
}
