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

      suppressed_dirs = [
        "~/"
        "~/Downloads"
      ];

      allowed_dirs = [
        "~/Projects/*"
        "~/git/*"
      ];

      cwd_change_handling = true;
      pre_cwd_changed_cmds = [
        "tabdo Neotree close"
      ];

      post_cwd_changed_cmds = [
        "Neotree filesystem show"
      ];

      session_lens = {
        load_on_setup = true;
      };
    };
  };

  vim.options.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
}
