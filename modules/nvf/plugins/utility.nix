{ pkgs, ... }:

{
  vim.utility = {
    vim-wakatime = {
      enable = true;
      cli-package = null;
    };

    yazi-nvim = {
      enable = true;

      mappings = {
        openYazi = "<leader>n";
      };
    };
  };

  vim.extraPackages = with pkgs; [ yazi ];
}
