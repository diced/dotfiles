{ lib, ... }:

{
  vim.autocomplete.blink-cmp = {
    enable = true;
    setupOpts = {
      signature.enabled = true;

      completion = {
        documentation = {
          window = {
            border = "padded";
          };
        };
      };

      signature = {
        window.border = "padded";
      };

      completion.list.selection = {
        preselect = false;
        auto_insert = false;
      };

      keymap = {
        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];
      };

      enabled = lib.generators.mkLuaInline ''
        function()
          return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype)
        end
      '';
    };
  };
}
