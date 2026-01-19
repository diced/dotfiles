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

    # highlights all references of a var
    illuminate.enable = true;

    borders.enable = true;
  };
}
