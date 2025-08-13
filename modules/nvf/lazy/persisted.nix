{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.auto-session.pname}" = {
    package = pkgs.vimPlugins.auto-session;
    setupModule = "auto-session";
  };
}
