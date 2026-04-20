{ pkgs, ... }:

let
  package = pkgs.vimPlugins.glance-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "glance";

    after = ''
      vim.keymap.set('n', '<leader>lgd', '<CMD>Glance definitions<CR>')
      vim.keymap.set('n', '<leader>lr', '<CMD>Glance references<CR>')
      vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
      vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')
    '';
  };
}
