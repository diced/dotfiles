{ pkgs, ... }:

let
  package = pkgs.vimPlugins.nvim-ts-context-commentstring;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "ts_context_commentstring";

    setupOpts = {
      enable_autocmd = false;
    };
  };
}
