{ pkgs, ... }:

let
  package = pkgs.vimPlugins.SchemaStore-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    lazy = false;
  };
}
