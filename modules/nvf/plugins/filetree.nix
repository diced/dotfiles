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

      actions.open_file = {
        resize_window = true;
      };

      trash = {
        cmd =
          if pkgs.stdenv.isDarwin then
            "${pkgs.darwin.trash}/bin/trash"
          else if pkgs.stdenv.isLinux then
            "${pkgs.trash-cli}/bin/trash-put"
          else
            "";
      };

      on_attach = lib.generators.mkLuaInline ''
        function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end


          vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
          vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))

          vim.keymap.set("n", "r", api.fs.rename_basename, opts("Rename: Basename"))
          vim.keymap.set("n", "R", api.fs.rename, opts("Rename"))
          vim.keymap.set("n", "u", api.fs.rename_full, opts("Rename: Full Path"))

          vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
          vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
          vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
          vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))

          vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
          vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
          vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))

          vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "O", api.node.run.system, opts("Open With System Opener"))

          vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))

          vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        end
      '';
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
