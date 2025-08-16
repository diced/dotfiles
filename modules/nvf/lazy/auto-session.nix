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
        "~/Projects"
        "~/git"
      ];
    };

    keys = [
      {
        mode = "n";
        key = "<leader>wr";
        action = ":SessionSearch<CR>";
        desc = "Session search";
      }
    ];
  };
}
