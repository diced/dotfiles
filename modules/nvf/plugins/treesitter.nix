{ pkgs, ... }:

{
  vim.treesitter = {
    enable = true;
    autotagHtml = true;
    fold = true;

    grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      dockerfile
      prisma
      json
    ];

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
