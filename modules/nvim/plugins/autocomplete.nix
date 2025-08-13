{ ... }:

{
  vim.autocomplete.blink-cmp = {
    enable = true;
    setupOpts = {
      signature.enabled = true;

      keymap = {
        "<Up>" = ["select_prev" "fallback"];
        "<Down>" = ["select_next" "fallback"];
      };
    };
  };
}
