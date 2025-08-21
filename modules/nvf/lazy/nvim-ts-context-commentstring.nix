{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.nvim-ts-context-commentstring.pname}" = {
    package = pkgs.vimPlugins.nvim-ts-context-commentstring;
    setupModule = "ts_context_commentstring";

    setupOpts = {
      enable_autocmd = false;
    };
  };
}
