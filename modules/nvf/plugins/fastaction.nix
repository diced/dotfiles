{ ... }:

{
  vim = {
    ui.fastaction = {
      enable = true;
      setupOpts = {
        dismiss_keys = [
          "<Esc>"
          "q"
        ];

        popup.title = false;
      };
    };

    lsp.mappings.codeAction = null;
    keymaps = [
      {
        mode = "n";
        key = "<leader>la";
        lua = true;
        action = "function() require('fastaction').code_action() end";
      }
    ];
  };
}
