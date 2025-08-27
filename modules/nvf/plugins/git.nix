{ ... }:

{
  vim.git = {
    gitsigns.enable = true;

    neogit = {
      enable = true;

      setupOpts = {
        kind = "floating";
      };
    };
  };
}
