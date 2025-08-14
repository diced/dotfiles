{ pkgs, ... }:

{
  vim.lazy.plugins."${pkgs.vimPlugins.auto-session.pname}" = {
    package = pkgs.vimPlugins.auto-session;
    setupModule = "auto-session";

    setupOpts = {
      pre_save_cmds = [
        "Neotree close"
      ];

      post_restore_cmds = [
        "Neotree filesystem show"
      ];
    };
  };
}
