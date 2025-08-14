{ ... }:

{
  vim.filetree.neo-tree = {
    enable = true;
    setupOpts = {
      close_if_last_window = true;

      filesystem = {
        filtered_items = {
          visible = true;
          hide_hidden = false;
          hide_gitignored = false;

          never_show = [
            ".git"
            ".DS_Store"
          ];
        };

        follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };

        use_libuv_file_watcher = true;
      };

      window = {
        position = "left";
        width = 30;
      };
    };
  };
}
