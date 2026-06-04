{ lib, ... }:

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
      superhtml.enable = lib.mkForce false;
    };

    servers.clangd = {
      cmd = lib.mkForce [
        "clangd"
        "--background-index"
        "--query-driver=**/.platformio/packages/toolchain-xtensa-esp32*/bin/*-g*,**/.platformio/packages/toolchain-riscv32-esp*/bin/*-g*"
      ];
    };
  };
}
