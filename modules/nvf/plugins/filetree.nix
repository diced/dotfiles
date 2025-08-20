{ pkgs, lib, ... }:

{
  vim.filetree.nvimTree = {
    enable = true;

    openOnSetup = false;

    setupOpts = {
      disable_netrw = true;

      filters = {
        dotfiles = true;
      };

      update_focused_file = {
        enable = true;
      };

      git = {
        enable = true;
      };

      view = {
        width = 30;
      };

      renderer = {
        highlight_git = true;
      };

      diagnostics = {
        enable = true;
      };

      trash = {
        cmd = lib.optionalString pkgs.stdenv.isDarwin "${pkgs.darwin.trash}/bin/trash";
      };
    };

    mappings.toggle = "<leader>n";
  };

  vim.autocmds = [
    {
      event = [ "BufEnter" ];
      pattern = [ "NvimTree*" ];
      callback = lib.generators.mkLuaInline ''
        function()
          local api = require('nvim-tree.api')

          if not api.tree.is_visible() then
            api.tree.open()
          end
        end
      '';
    }
  ];
}
