{ ... }:

{
  vim.ui = {
    # highlight colors in editor
    colorizer = {
      enable = true;
      setupOpts.filetypes = {
        "*" = {};
      };
    };

    # replaces cmdline ui
    noice.enable = true;

    # highlights all references of a var
    illuminate.enable = true;
  }; 
}
