{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.barbar-nvim.pname}" = {
    package = pkgs.vimPlugins.barbar-nvim;
    setupModule = "barbar";
  };
}
