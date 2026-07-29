{ lib, ... }:

{
  vim.formatter.conform-nvim = {
    enable = true;

    setupOpts = {
      formatters = {
        prettier.command = lib.mkForce "node_modules/.bin/prettier";
      };

      formatters_by_ft = {
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        astro = [ "prettier" ];
        markdown = [ "prettier" ];
        mdx = [ "prettier" ];
        c = [ ];
        cpp = [ ];
      };
    };
  };
}
