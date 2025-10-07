{ ... }:

{
  vim.git = {
    neogit = {
      enable = true;

      mappings.open = "<leader>gg";

      setupOpts = {
        kind = "floating";

        commit_editor.kind = "floating";
      };
    };

    gitsigns.enable = true;
    hunk-nvim.enable = true;
    gitlinker-nvim.enable = true;
  };

  vim.keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gl";
      lua = true;
      action = "require('gitlinker').link";
      desc = "GitLinker: Copy Remote URL";
    }
  ];
}
