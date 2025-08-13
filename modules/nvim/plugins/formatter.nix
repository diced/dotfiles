{ ... }:

{
  vim.formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      formatters = {
        prettier.command = "node_modules/.bin/prettier";
      };

      formatters_by_ft = {
        javascript = ["prettier"];
        typescript = ["prettier"];
        typescriptreact = ["prettier"];
        astro = ["prettier"];
      };
    };
  };
}
