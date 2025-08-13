{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.auto-save-nvim.pname}" = {
    package = pkgs.vimPlugins.auto-save-nvim;
    setupModule = "auto-save";
    cmd = "ASToggle";
    event = [ "InsertLeave" "TextChanged" ];
  };
}

