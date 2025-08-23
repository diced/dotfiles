{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.typescript-tools-nvim.pname}" = {
    package = pkgs.vimPlugins.typescript-tools-nvim;
    setupModule = "typescript-tools";
    lazy = false;

    keys = [
      {
        mode = "n";
        key = "<A-O>";
        lua = true;
        action = "function() require('typescript-tools.api').organize_imports() end";
        desc = "Typescript: Organize Imports";
      }
    ];
  };
}
