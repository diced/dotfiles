{ ... }:

{
  vim.git = {
    gitsigns.enable = true;

    neogit = {
      enable = true;

      mappings.open = "<leader>gg";

      setupOpts = {
        kind = "floating";

        commit_editor.kind = "floating";
      };
    };
  };
}
