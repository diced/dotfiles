{ ... }:

{
  vim.visuals = {
    # notifications in bottom corner
    fidget-nvim = {
      enable = true;
      setupOpts = {
        notification = {
          override_vim_notify = true;

          window.border = "none";
        };
      };
    };

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
          "RainbowDelimiterGreen"
          "RainbowDelimiterYellow"
          "RainbowDelimiterRed"
          "RainbowDelimiterPink"
          "RainbowDelimiterPurple"
        ];
      };
    };
  };
}
