{ pkgs, ... }:

let
  package = pkgs.vimPlugins.harpoon2;

in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "harpoon";

    after = ''
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED


      -- checks nvim tree or other buffers
      local function is_valid_buffer()
        local ft = vim.bo.filetype
        local ignore = {
          "NvimTree",
        }
        for _, bad in ipairs(ignore) do
          if ft == bad then
            return false
          end
        end
        return true
      end

      vim.keymap.set("n", "<leader>a", function()
        if is_valid_buffer() then
          harpoon:list():add()
        else
          vim.notify("Cannot add this buffer type to Harpoon (" .. vim.bo.filetype .. ")", vim.log.levels.WARN)
        end
      end, { desc = "Add current file to Harpoon" })

      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<C-a>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-d>", function() harpoon:list():next() end)
    '';
  };
}
