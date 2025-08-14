{ ... }:

{
  vim.treesitter = {
    enable = true;
    autotagHtml = true;
    fold = true;

    context = {
      enable = true;

      setupOpts = {
        multiline_threshold = 1;
        max_lines = 5;

        separator = "─";
      };
    };
  };
}
