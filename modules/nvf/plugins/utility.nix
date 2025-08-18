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

      setupOpts = {
        open_for_directories = true;
      };
    };
  };

  vim.extraPackages = with pkgs; [ yazi ];
}
