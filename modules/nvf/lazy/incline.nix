{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.incline-nvim.pname}" = {
    package = pkgs.vimPlugins.incline-nvim;
    setupModule = "incline";
  };
}
