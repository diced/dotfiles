{ pkgs, ... }:

let
  package = pkgs.vimPlugins.diffview-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "diffview";
  };
}
