{ pkgs, ... }:

let
  # use some fork that adds blink highlights
  # package = pkgs.vimUtils.buildVimPlugin {
  #   pname = "github-nvim-theme";
  #   version = "2010b7a62f6fed564f95b2a76bb04fb773c45691";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tim3nd";
  #     repo = "github-nvim-theme";
  #     rev = "2010b7a62f6fed564f95b2a76bb04fb773c45691";
  #     sha256 = "sha256-6mhku7huNkDBLHBQWpQgAFduquBQfCJ25Rldha42A/g=";
  #   };
  # };
  package = pkgs.vimPlugins.github-nvim-theme;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "github-theme";
    lazy = false;
    priority = 1000;

    after = ''
      require('github-theme').compile()
      vim.cmd('colorscheme github_dark_default')

      vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#1f6feb" })

    '';

    setupOpts = {
      specs.github_dark_default = {
        bg0 = "#111111";
        bg1 = "#161616";
      };
      groups.all = {
        # blink cmp
        BlinkCmpMenu.bg = "#1f1f1f";

        CursorLine.bg = "#1f1f1f";

        FloatBorder.fg = "#303237";

        # treesitter
        TreesitterContextSeparator.fg = "#303237";

        # copilot.lua colors
        CopilotSuggestion.fg = "#474a4f";

        NormalFloat.bg = "#161616";

        # rainbow delimiters
        RainbowDelimiterBlue.fg = "#80ccff";
        RainbowDelimiterGreen.fg = "#6fdd8b";
        RainbowDelimiterYellow.fg = "#eac54f";
        RainbowDelimiterRed.fg = "#ffaba8";
        RainbowDelimiterPink.fg = "#ffadda";
        RainbowDelimiterPurple.fg = "#d8b9ff";

        "@tag.jsx".fg = "#ff757f";
        # "@keyword.exception".link = "Function";
      };
    };
  };
}
