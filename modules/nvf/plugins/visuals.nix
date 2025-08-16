{ ... }:

{
  vim.visuals = {
    # notifications in bottom corner
    fidget-nvim.enable = true;

    nvim-scrollbar.enable = true;
    nvim-web-devicons.enable = true;

    indent-blankline = {
      enable = true;

      setupOpts = {
        exclude = {
          filetypes = [ "dashboard" ];
        };
      };
    };

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
