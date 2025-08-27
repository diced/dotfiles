{ pkgs, ... }:

let
  package = pkgs.vimPlugins.catppuccin-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "catppuccin";

    lazy = false;
    priority = 1000;

    after = ''
      vim.cmd('colorscheme catppuccin-mocha')

      vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#1f6feb" })
    '';

    setupOpts = {
      color_overrides = {
        mocha = {
          base = "#111111";
          mantle = "#161616";
          crust = "#1f1f1f";
        };
      };
    };
  };
}
