{ lib, ... }:

{
  vim.autocomplete.blink-cmp = {
    enable = true;
    setupOpts = {
      signature.enabled = true;

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
