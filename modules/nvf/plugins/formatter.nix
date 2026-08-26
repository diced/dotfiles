{ ... }:

{
  vim.formatter.conform-nvim = {
    enable = true;

    setupOpts.formatters_by_ft = {
      javascript = [ "oxfmt" ];
      javascriptreact = [ "oxfmt" ];
      typescript = [ "oxfmt" ];
      typescriptreact = [ "oxfmt" ];
      json = [ "oxfmt" ];
      jsonc = [ "oxfmt" ];
      css = [ "oxfmt" ];
      scss = [ "oxfmt" ];
      less = [ "oxfmt" ];
      html = [ "oxfmt" ];
      vue = [ "oxfmt" ];
      svelte = [ "oxfmt" ];
      markdown = [ "oxfmt" ];
      mdx = [ "oxfmt" ];
      yaml = [ "oxfmt" ];

      c = [ ];
      cpp = [ ];
    };
  };
}
