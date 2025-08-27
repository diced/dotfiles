{ pkgs, ... }:

let
  package = pkgs.vimPlugins.typescript-tools-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

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
