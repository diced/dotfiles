{ pkgs, ... }:

let
  package = pkgs.vimPlugins.auto-save-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "auto-save";
    cmd = "ASToggle";
    event = [
      "InsertLeave"
      "TextChanged"
    ];
  };
}
