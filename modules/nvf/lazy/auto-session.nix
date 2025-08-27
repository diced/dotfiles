{ pkgs, ... }:

let
  package = pkgs.vimPlugins.auto-session;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "auto-session";
    lazy = false;

    setupOpts = {
      suppressed_dirs = [
        "~"
        "~/Downloads"
      ];

      post_restore_cmds = [
        "NvimTreeOpen"
      ];

      pre_restore_cmds = [
        "NvimTreeClose"
      ];
    };

    before = ''
      local arg = vim.fn.expand(vim.fn.argv(0))
      if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
        pcall(vim.api.nvim_set_current_dir, arg)
      elseif vim.fn.bufname("%") ~= "" then
        local dir = vim.fn.expand("%:p:h")
        if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
          pcall(vim.api.nvim_set_current_dir, dir)
        end
      end
    '';

    after = ''
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    '';

    keys = [
      {
        mode = "n";
        key = "<leader>ss";
        action = ":SessionSearch<CR>";
        desc = "Session search";
      }
    ];
  };
}
