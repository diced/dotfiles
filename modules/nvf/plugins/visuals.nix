{ lib, ... }:

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

    blink-indent.enable = true;

    rainbow-delimiters = {
      enable = true;
      setupOpts = {
        highlight = [
          "RainbowDelimiterBlue"
          "RainbowDelimiterGreen"
          "RainbowDelimiterYellow"
          "RainbowDelimiterRed"
          "RainbowDelimiterPink"
          "RainbowDelimiterPurple"
        ];

        # disables rainbow delimiters in jsx/tsx files
        strategy = lib.generators.mkLuaInline ''
          {
            [""] = function(bufnr)
              local ft = vim.bo[bufnr].filetype
              if ft == "typescriptreact" or ft == "javascriptreact" or ft == "html" then
                return nil -- This disables it
              end
              return require('rainbow-delimiters.strategy.global')
            end,
          }
        '';

        query = {
          "" = "rainbow-delimiters";

          typescriptreact = "";
          javascriptreact = "";
        };
      };
    };
  };
}
