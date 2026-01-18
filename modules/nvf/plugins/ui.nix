{ ... }:

{
  vim.ui = {
    # highlight colors in editor
    colorizer = {
      enable = true;
      setupOpts = {
        filetypes = {
          "*" = { };
        };

        tailwind = true;
      };
    };

    # replaces cmdline ui
    noice.enable = true;

    # highlights all references of a var
    illuminate.enable = true;

    borders.enable = true;
  };
}
