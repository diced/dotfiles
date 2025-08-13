{ ... }:

{
  vim.visuals = {
    # notifications in bottom corner
    fidget-nvim.enable = true;

    indent-blankline.enable = true;
    nvim-scrollbar.enable = true;
    nvim-web-devicons.enable = true;

    rainbow-delimiters = {
      enable = false;
      setupOpts = {
        highlight = [
          "RainbowDelimiterBlue"
          "RainbowDelimiterRed"
          "RainbowDelimiterYellow"
          "RainbowDelimiterOrange"
          "RainbowDelimiterGreen"
          "RainbowDelimiterViolet"
          "RainbowDelimiterCyan"
        ];
      };
    };
  };
}
